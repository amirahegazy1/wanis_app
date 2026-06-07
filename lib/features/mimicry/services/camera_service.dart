import 'package:camera/camera.dart';

/// Manages the front camera for the AI pose analysis feature.
class CameraService {
  CameraController? controller;
  List<CameraDescription> cameras = [];

  /// The clockwise rotation (in degrees) that must be applied to the raw
  /// camera image so it appears upright on screen. Typical values:
  /// 90 (back camera), 270 (front camera), 0 (no rotation needed).
  int sensorOrientation = 0;

  Future<void> initialize() async {
    cameras = await availableCameras();
    if (cameras.isEmpty) return;

    CameraDescription frontCamera = cameras.firstWhere(
      (cam) => cam.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    sensorOrientation = frontCamera.sensorOrientation;

    controller = CameraController(
      frontCamera,
      ResolutionPreset.low,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    await controller!.initialize();
    await controller!.setExposureMode(ExposureMode.auto);
    await controller!.setFocusMode(FocusMode.auto);
  }

  void dispose() {
    controller?.dispose();
  }
}
