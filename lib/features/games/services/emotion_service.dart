import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

/// Result of an emotion detection inference.
class EmotionResult {
  /// The detected emotion label (e.g. "Happiness", "Sadness").
  final String label;

  /// The confidence score for the detected emotion (0.0 – 1.0).
  final double confidence;

  /// All probabilities for the 8 emotion classes.
  final List<double> probabilities;

  const EmotionResult({
    required this.label,
    required this.confidence,
    required this.probabilities,
  });
}

/// Service that handles TFLite model loading, face detection, and emotion inference.
///
/// Uses [google_ml_kit] for face detection and [tflite_flutter] for inference.
class EmotionService {
  static const String _modelPath = 'assets/ai/model.tflite';
  static const String _labelsPath = 'assets/ai/labels.txt';
  static const int _inputSize = 48;

  Interpreter? _interpreter;
  FaceDetector? _faceDetector;
  List<String> _labels = [];
  bool _isInitialized = false;
  bool _isBusy = false;

  bool get isInitialized => _isInitialized;

  /// Initialize the TFLite interpreter and face detector.
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Load labels
      final labelsData = await rootBundle.loadString(_labelsPath);
      _labels = labelsData
          .split('\n')
          .map((l) => l.trim())
          .where((l) => l.isNotEmpty)
          .toList();
      developer.log(
        'EmotionService: Loaded ${_labels.length} emotion labels: $_labels',
      );

      // Load TFLite model
      _interpreter = await Interpreter.fromAsset(_modelPath);
      developer.log('EmotionService: TFLite model loaded successfully');

      // Configure face detector
      final options = FaceDetectorOptions(
        enableContours: false,
        enableClassification: false,
        enableTracking: false,
        enableLandmarks: false,
        performanceMode: FaceDetectorMode.fast,
        minFaceSize: 0.15,
      );
      _faceDetector = FaceDetector(options: options);
      developer.log('EmotionService: Face detector initialized');

      _isInitialized = true;
    } catch (e, stack) {
      developer.log(
        'EmotionService: Initialization error: $e\n$stack',
        name: 'EmotionService',
      );
      rethrow;
    }
  }

  /// Process a [CameraImage] frame and return an [EmotionResult] if a face is detected.
  ///
  /// Returns `null` if no face is detected or the service is busy processing.
  /// Never throws — all errors are caught, logged, and return `null`.
  Future<EmotionResult?> processFrame(
    CameraImage cameraImage,
    CameraDescription camera,
  ) async {
    if (!_isInitialized) {
      developer.log(
        'EmotionService: processFrame called before initialization',
        name: 'EmotionService',
      );
      return null;
    }
    if (_isBusy) return null;
    _isBusy = true;

    try {
      // Step 1: Detect faces using ML Kit
      final inputImage = _convertCameraImageToInputImage(cameraImage, camera);
      if (inputImage == null) {
        developer.log(
          'EmotionService: Failed to convert camera image to InputImage',
          name: 'EmotionService',
        );
        return null;
      }

      final List<Face> faces;
      try {
        faces = await _faceDetector!.processImage(inputImage);
      } catch (faceError) {
        developer.log(
          'EmotionService: Face detection threw: $faceError',
          name: 'EmotionService',
        );
        return null;
      }

      if (faces.isEmpty) {
        return null;
      }

      developer.log(
        'EmotionService: ${faces.length} face(s) detected',
        name: 'EmotionService',
      );

      // Step 2: Convert camera image to img.Image for cropping
      final fullImage = _convertCameraImageToImage(cameraImage);
      if (fullImage == null) {
        developer.log(
          'EmotionService: Failed to convert CameraImage to img.Image',
          name: 'EmotionService',
        );
        return null;
      }

      // Step 3: Crop the face region
      final face = faces.first;
      final faceImage = _cropFace(
        fullImage,
        face.boundingBox,
        cameraImage.width,
        cameraImage.height,
      );
      if (faceImage == null) {
        developer.log(
          'EmotionService: Failed to crop face region (bbox: ${face.boundingBox})',
          name: 'EmotionService',
        );
        return null;
      }

      // Step 4: Preprocess to 48x48 grayscale float32 [1, 48, 48, 1]
      final input = _preprocessImage(faceImage);

      // Step 5: Prepare output tensor [1, numClasses] and run inference.
      final output = List.generate(1, (_) => List.filled(_labels.length, 0.0));
      try {
        _interpreter!.run(input, output);
      } catch (inferenceError, inferenceStack) {
        developer.log(
          'EmotionService: TFLite inference failed: $inferenceError\n$inferenceStack',
          name: 'EmotionService',
        );
        return null;
      }

      // Step 6: Output is now [1, numClasses]
      final List<double> probabilities = output[0].cast<double>();

      // Step 7: Apply softmax to get normalized probabilities
      final normalizedProbs = _softmax(probabilities);

      // Step 8: Find the emotion with the highest probability
      int maxIndex = 0;
      double maxProb = normalizedProbs[0];
      for (int i = 1; i < normalizedProbs.length; i++) {
        if (normalizedProbs[i] > maxProb) {
          maxProb = normalizedProbs[i];
          maxIndex = i;
        }
      }

      if (maxIndex >= _labels.length) {
        developer.log(
          'EmotionService: maxIndex $maxIndex out of bounds for ${_labels.length} labels',
          name: 'EmotionService',
        );
        return null;
      }

      developer.log(
        'EmotionService: Detected ${_labels[maxIndex]} (${(maxProb * 100).toStringAsFixed(1)}%)',
        name: 'EmotionService',
      );

      return EmotionResult(
        label: _labels[maxIndex],
        confidence: maxProb,
        probabilities: normalizedProbs,
      );
    } catch (e, stack) {
      developer.log(
        'EmotionService: Unexpected processFrame error: $e\n$stack',
        name: 'EmotionService',
      );
      return null;
    } finally {
      _isBusy = false;
    }
  }

  /// Convert [CameraImage] to ML Kit [InputImage].
  InputImage? _convertCameraImageToInputImage(
    CameraImage image,
    CameraDescription camera,
  ) {
    try {
      final sensorOrientation = camera.sensorOrientation;
      InputImageRotation? rotation;

      // Determine the rotation based on the sensor orientation
      switch (sensorOrientation) {
        case 0:
          rotation = InputImageRotation.rotation0deg;
          break;
        case 90:
          rotation = InputImageRotation.rotation90deg;
          break;
        case 180:
          rotation = InputImageRotation.rotation180deg;
          break;
        case 270:
          rotation = InputImageRotation.rotation270deg;
          break;
        default:
          rotation = InputImageRotation.rotation0deg;
      }

      // For Android: YUV_420 format
      if (image.format.group == ImageFormatGroup.yuv420) {
        final planes = image.planes;
        final bytes = _concatenatePlanes(planes);

        final inputImageFormat = InputImageFormatValue.fromRawValue(
          image.format.raw as int,
        );
        if (inputImageFormat == null) {
          developer.log(
            'EmotionService: Invalid input image format',
            name: 'EmotionService',
          );
          return null;
        }

        return InputImage.fromBytes(
          bytes: bytes,
          metadata: InputImageMetadata(
            size: Size(image.width.toDouble(), image.height.toDouble()),
            rotation: rotation,
            format: inputImageFormat,
            bytesPerRow: planes[0].bytesPerRow,
          ),
        );
      }

      // For iOS: BGRA8888 format
      if (image.format.group == ImageFormatGroup.bgra8888) {
        final bytes = image.planes[0].bytes;
        return InputImage.fromBytes(
          bytes: bytes,
          metadata: InputImageMetadata(
            size: Size(image.width.toDouble(), image.height.toDouble()),
            rotation: rotation,
            format: InputImageFormat.bgra8888,
            bytesPerRow: image.planes[0].bytesPerRow,
          ),
        );
      }

      developer.log(
        'EmotionService: Unsupported format group: ${image.format.group}',
        name: 'EmotionService',
      );
      return null;
    } catch (e, stack) {
      developer.log(
        'EmotionService: Error in _convertCameraImageToInputImage: $e\n$stack',
        name: 'EmotionService',
      );
      return null;
    }
  }

  /// Concatenate all YUV planes into a single byte buffer.
  Uint8List _concatenatePlanes(List<Plane> planes) {
    int totalBytes = 0;
    for (final plane in planes) {
      totalBytes += plane.bytes.length;
    }
    final result = Uint8List(totalBytes);
    int offset = 0;
    for (final plane in planes) {
      result.setRange(offset, offset + plane.bytes.length, plane.bytes);
      offset += plane.bytes.length;
    }
    return result;
  }

  /// Convert a [CameraImage] (YUV420 or BGRA8888) to an [img.Image].
  img.Image? _convertCameraImageToImage(CameraImage cameraImage) {
    try {
      if (cameraImage.format.group == ImageFormatGroup.yuv420) {
        return _convertYUV420ToImage(cameraImage);
      } else if (cameraImage.format.group == ImageFormatGroup.bgra8888) {
        return _convertBGRA8888ToImage(cameraImage);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Convert YUV420 camera image to [img.Image].
  img.Image _convertYUV420ToImage(CameraImage image) {
    final int width = image.width;
    final int height = image.height;
    final yPlane = image.planes[0];
    final uPlane = image.planes[1];
    final vPlane = image.planes[2];

    final result = img.Image(width: width, height: height);

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final int yIndex = y * yPlane.bytesPerRow + x;
        final int uvIndex = (y ~/ 2) * uPlane.bytesPerRow + (x ~/ 2);

        final int yValue = yPlane.bytes[yIndex];
        final int uValue = uPlane.bytes[uvIndex];
        final int vValue = vPlane.bytes[uvIndex];

        // YUV to RGB conversion
        int r = (yValue + 1.370705 * (vValue - 128)).round().clamp(0, 255);
        int g = (yValue - 0.337633 * (uValue - 128) - 0.698001 * (vValue - 128))
            .round()
            .clamp(0, 255);
        int b = (yValue + 1.732446 * (uValue - 128)).round().clamp(0, 255);

        result.setPixelRgb(x, y, r, g, b);
      }
    }
    return result;
  }

  /// Convert BGRA8888 camera image to [img.Image].
  img.Image _convertBGRA8888ToImage(CameraImage image) {
    final int width = image.width;
    final int height = image.height;
    final bytes = image.planes[0].bytes;
    final bytesPerRow = image.planes[0].bytesPerRow;
    final result = img.Image(width: width, height: height);

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final int index = y * bytesPerRow + x * 4;
        final b = bytes[index];
        final g = bytes[index + 1];
        final r = bytes[index + 2];
        result.setPixelRgb(x, y, r, g, b);
      }
    }
    return result;
  }

  /// Crop the face region from the full image using the bounding box.
  img.Image? _cropFace(
    img.Image fullImage,
    Rect boundingBox,
    int originalWidth,
    int originalHeight,
  ) {
    // The bounding box from ML Kit is based on the original image dimensions
    int x = boundingBox.left.round().clamp(0, fullImage.width - 1);
    int y = boundingBox.top.round().clamp(0, fullImage.height - 1);
    int w = boundingBox.width.round();
    int h = boundingBox.height.round();

    // Ensure we don't go out of bounds
    if (x + w > fullImage.width) w = fullImage.width - x;
    if (y + h > fullImage.height) h = fullImage.height - y;
    if (w <= 0 || h <= 0) return null;

    return img.copyCrop(fullImage, x: x, y: y, width: w, height: h);
  }

  /// Preprocess the face image to a 48x48 grayscale float32 tensor [1, 48, 48, 1].
  /// Returns a flat list that TFLite interpreter can process.
  List<List<List<List<double>>>> _preprocessImage(img.Image faceImage) {
    // Resize to 48x48
    final resized = img.copyResize(
      faceImage,
      width: _inputSize,
      height: _inputSize,
    );

    // Convert to grayscale and normalize to [0, 1]
    // Shape: [1, 48, 48, 1]
    final input = List.generate(
      1,
      (_) => List.generate(
        _inputSize,
        (y) => List.generate(_inputSize, (x) {
          // Get pixel and extract RGB values
          final pixel = resized.getPixel(x, y);
          // Extract RGB components - pixel has r, g, b as int properties
          final r = pixel.r.toDouble();
          final g = pixel.g.toDouble();
          final b = pixel.b.toDouble();
          // Convert to grayscale using luminosity method
          final gray = (0.299 * r + 0.587 * g + 0.114 * b);
          return [gray / 255.0]; // Normalize to [0, 1], shape per pixel: [1]
        }),
      ),
    );
    return input;
  }

  /// Apply softmax to convert logits to probabilities.
  List<double> _softmax(List<double> logits) {
    final maxLogit = logits.reduce(max);
    final exps = logits.map((l) => exp(l - maxLogit)).toList();
    final sumExps = exps.reduce((a, b) => a + b);
    return exps.map((e) => e / sumExps).toList();
  }

  /// Process a captured image file and return an [EmotionResult] if a face is detected.
  ///
  /// This is the preferred method for single-shot capture analysis.
  /// Takes the file path from [CameraController.takePicture()].
  Future<EmotionResult?> processImageFile(String filePath) async {
    if (!_isInitialized) {
      developer.log(
        'EmotionService: processImageFile called before initialization',
        name: 'EmotionService',
      );
      return null;
    }

    try {
      // Step 1: Create InputImage from file path for face detection
      final inputImage = InputImage.fromFilePath(filePath);

      final List<Face> faces;
      try {
        faces = await _faceDetector!.processImage(inputImage);
      } catch (faceError) {
        developer.log(
          'EmotionService: Face detection threw: $faceError',
          name: 'EmotionService',
        );
        return null;
      }

      if (faces.isEmpty) {
        developer.log(
          'EmotionService: No faces found in captured image',
          name: 'EmotionService',
        );
        return null;
      }

      developer.log(
        'EmotionService: ${faces.length} face(s) detected in file',
        name: 'EmotionService',
      );

      // Step 2: Load the image file as img.Image for cropping
      final fileBytes = await File(filePath).readAsBytes();
      final fullImage = img.decodeImage(fileBytes);
      if (fullImage == null) {
        developer.log(
          'EmotionService: Failed to decode image file',
          name: 'EmotionService',
        );
        return null;
      }

      // Step 3: Crop the face region
      final face = faces.first;
      final faceImage = _cropFace(
        fullImage,
        face.boundingBox,
        fullImage.width,
        fullImage.height,
      );
      if (faceImage == null) {
        developer.log(
          'EmotionService: Failed to crop face region (bbox: ${face.boundingBox})',
          name: 'EmotionService',
        );
        return null;
      }

      // Step 4: Preprocess to 48x48 grayscale float32 [1, 48, 48, 1]
      final input = _preprocessImage(faceImage);

      // Step 5: Run inference
      final output = List.generate(1, (_) => List.filled(_labels.length, 0.0));
      try {
        _interpreter!.run(input, output);
      } catch (inferenceError, inferenceStack) {
        developer.log(
          'EmotionService: TFLite inference failed: $inferenceError\n$inferenceStack',
          name: 'EmotionService',
        );
        return null;
      }

      // Step 6: Get probabilities
      final List<double> probabilities = output[0].cast<double>();

      // Step 7: Apply softmax
      final normalizedProbs = _softmax(probabilities);

      // Step 8: Find best emotion
      int maxIndex = 0;
      double maxProb = normalizedProbs[0];
      for (int i = 1; i < normalizedProbs.length; i++) {
        if (normalizedProbs[i] > maxProb) {
          maxProb = normalizedProbs[i];
          maxIndex = i;
        }
      }

      if (maxIndex >= _labels.length) {
        developer.log(
          'EmotionService: maxIndex $maxIndex out of bounds',
          name: 'EmotionService',
        );
        return null;
      }

      developer.log(
        'EmotionService: Detected ${_labels[maxIndex]} (${(maxProb * 100).toStringAsFixed(1)}%) from file',
        name: 'EmotionService',
      );

      return EmotionResult(
        label: _labels[maxIndex],
        confidence: maxProb,
        probabilities: normalizedProbs,
      );
    } catch (e, stack) {
      developer.log(
        'EmotionService: processImageFile error: $e\n$stack',
        name: 'EmotionService',
      );
      return null;
    }
  }

  /// Clean up resources.
  void dispose() {
    _interpreter?.close();
    _faceDetector?.close();
    _isInitialized = false;
  }
}
