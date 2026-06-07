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

  /// Detects pose in a camera frame.
  ///
  /// [sensorOrientation] is the clockwise rotation (degrees) needed to orient
  /// the raw camera image upright (from [CameraDescription.sensorOrientation]).
  Future<List<List<double>>?> detectPose(
    CameraImage cameraImage, {
    int sensorOrientation = 0,
  }) async {
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
            sensorOrientation,
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
    int sensorOrientation,
  ) {
    try {
      // ── Step 1: YUV420 → RGB ──────────────────────────────────────
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

      // ── Step 2: Rotate to upright orientation ─────────────────────
      // On Android, the camera sensor is physically rotated relative to
      // the display.  Without this step MoveNet sees the person lying on
      // their side and produces meaningless keypoints.
      //
      // sensorOrientation is the clockwise rotation needed.
      // img.copyRotate rotates clockwise for positive angles.
      img.Image oriented = rgbImage;
      if (sensorOrientation == 90) {
        oriented = img.copyRotate(rgbImage, angle: 90);
      } else if (sensorOrientation == 180) {
        oriented = img.copyRotate(rgbImage, angle: 180);
      } else if (sensorOrientation == 270) {
        oriented = img.copyRotate(rgbImage, angle: 270);
      }

      // ── Step 3: Resize to model input (256 × 256) with letterbox ──
      // Preserve aspect ratio and pad the shorter dimension with black
      // pixels so the person is not distorted.
      final srcW = oriented.width;
      final srcH = oriented.height;
      final scale = inputSize / (srcW > srcH ? srcW : srcH);
      final scaledW = (srcW * scale).round().clamp(1, inputSize);
      final scaledH = (srcH * scale).round().clamp(1, inputSize);

      final scaled = img.copyResize(
        oriented,
        width: scaledW,
        height: scaledH,
        interpolation: img.Interpolation.average,
      );

      // Create black 256×256 canvas and paste the scaled image centred.
      final canvas = img.Image(width: inputSize, height: inputSize);
      img.fill(canvas, color: img.ColorRgb8(0, 0, 0));
      final offX = (inputSize - scaledW) ~/ 2;
      final offY = (inputSize - scaledH) ~/ 2;
      img.compositeImage(canvas, scaled, dstX: offX, dstY: offY);

      // ── Step 4: Flatten to int list for tflite ────────────────────
      final result = List<int>.filled(inputSize * inputSize * 3, 0);
      int idx = 0;
      for (int y = 0; y < inputSize; y++) {
        for (int x = 0; x < inputSize; x++) {
          final pixel = canvas.getPixel(x, y);
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
