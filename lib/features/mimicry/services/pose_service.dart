import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:camera/camera.dart';
import 'dart:typed_data';
import 'dart:isolate';

/// Runs MoveNet Thunder pose estimation on camera frames.
///
/// Returns 17 keypoints, each [y, x, confidence].
class PoseService {
  Interpreter? _interpreter;
  bool isReady = false;
  static const int inputSize = 256;

  static const List<String> keypointNames = [
    'nose', 'left_eye', 'right_eye', 'left_ear', 'right_ear',
    'left_shoulder', 'right_shoulder', 'left_elbow', 'right_elbow',
    'left_wrist', 'right_wrist', 'left_hip', 'right_hip',
    'left_knee', 'right_knee', 'left_ankle', 'right_ankle',
  ];

  Future<void> initialize() async {
    try {
      final options = InterpreterOptions()..threads = 2;
      _interpreter = await Interpreter.fromAsset(
        'assets/models/movenet_thunder.tflite',
        options: options,
      );
      isReady = true;
    } catch (e) {
      // Silently handle — the UI will show a fallback
    }
  }

  Future<List<List<double>>?> detectPose(CameraImage cameraImage) async {
    if (!isReady || _interpreter == null) return null;

    try {
      final inputBytes = await Isolate.run(() =>
          _preprocessImageStatic(
            cameraImage.planes[0].bytes,
            cameraImage.planes[1].bytes,
            cameraImage.planes[2].bytes,
            cameraImage.width,
            cameraImage.height,
            cameraImage.planes[0].bytesPerRow,
            cameraImage.planes[1].bytesPerRow,
            cameraImage.planes[1].bytesPerPixel ?? 2,
          ));

      if (inputBytes == null) return null;

      final input = inputBytes.reshape([1, inputSize, inputSize, 3]);
      final output = List.generate(
        1, (_) => List.generate(
          1, (_) => List.generate(17, (_) => List.filled(3, 0.0)),
        ),
      );

      _interpreter!.run(input, output);

      return output[0][0]
          .map<List<double>>((kp) => [
                (kp as List)[0].toDouble(),
                kp[1].toDouble(),
                kp[2].toDouble(),
              ])
          .toList();
    } catch (e) {
      return null;
    }
  }

  static List<int>? _preprocessImageStatic(
    Uint8List yBytes,
    Uint8List uBytes,
    Uint8List vBytes,
    int width,
    int height,
    int yRowStride,
    int uRowStride,
    int uPixelStride,
  ) {
    try {
      final rgbImage = img.Image(width: width, height: height);

      for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
          final yVal = yBytes[y * yRowStride + x];
          final uvIndex = (y ~/ 2) * uRowStride + (x ~/ 2) * uPixelStride;
          final uVal = uBytes[uvIndex] - 128;
          final vVal = vBytes[uvIndex] - 128;

          final r = (yVal + 1.402 * vVal).clamp(0, 255).toInt();
          final g = (yVal - 0.344136 * uVal - 0.714136 * vVal)
              .clamp(0, 255)
              .toInt();
          final b = (yVal + 1.772 * uVal).clamp(0, 255).toInt();

          rgbImage.setPixelRgb(x, y, r, g, b);
        }
      }

      final resized = img.copyResize(
        rgbImage,
        width: inputSize,
        height: inputSize,
        interpolation: img.Interpolation.average,
      );

      final result = List<int>.filled(inputSize * inputSize * 3, 0);
      int idx = 0;
      for (int y = 0; y < inputSize; y++) {
        for (int x = 0; x < inputSize; x++) {
          final pixel = resized.getPixel(x, y);
          result[idx++] = pixel.r.toInt();
          result[idx++] = pixel.g.toInt();
          result[idx++] = pixel.b.toInt();
        }
      }
      return result;
    } catch (e) {
      return null;
    }
  }

  void dispose() {
    _interpreter?.close();
  }
}
