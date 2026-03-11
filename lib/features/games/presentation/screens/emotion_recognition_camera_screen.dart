import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../services/emotion_service.dart';
import '../../services/therapeutic_story_service.dart';
import 'wanis_story_writing_screen.dart';

class EmotionRecognitionCameraScreen extends StatefulWidget {
  const EmotionRecognitionCameraScreen({super.key});

  @override
  State<EmotionRecognitionCameraScreen> createState() =>
      _EmotionRecognitionCameraScreenState();
}

class _EmotionRecognitionCameraScreenState
    extends State<EmotionRecognitionCameraScreen> with WidgetsBindingObserver {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  CameraDescription? _selectedCamera;

  final EmotionService _emotionService = EmotionService();

  String _currentEmotionLabel = '';
  String _currentEmotionArabic = 'جاري التحليل...';
  String _currentEmotionEmoji = '🔍';
  double _currentConfidence = 0.0;
  bool _isInitializing = true;
  bool _hasError = false;
  String _errorMessage = '';
  bool _isCameraReady = false;

  // Throttle inference to avoid overloading
  DateTime _lastInferenceTime = DateTime.now();
  static const Duration _inferenceInterval = Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeAll();
  }

  Future<void> _initializeAll() async {
    try {
      // Initialize emotion service
      await _emotionService.initialize();

      // Get available cameras
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        setState(() {
          _hasError = true;
          _errorMessage = 'لا توجد كاميرا متاحة على هذا الجهاز';
          _isInitializing = false;
        });
        return;
      }

      // Prefer front camera for face detection
      _selectedCamera = _cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras.first,
      );

      await _initializeCamera();
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'حدث خطأ أثناء تشغيل الكاميرا: $e';
          _isInitializing = false;
        });
      }
    }
  }

  Future<void> _initializeCamera() async {
    _cameraController?.dispose();

    _cameraController = CameraController(
      _selectedCamera!,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    try {
      await _cameraController!.initialize();
      if (!mounted) return;

      setState(() {
        _isCameraReady = true;
        _isInitializing = false;
      });

      // Start the image stream for real-time analysis
      _cameraController!.startImageStream(_onCameraFrame);
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'حدث خطأ أثناء تشغيل الكاميرا: $e';
          _isInitializing = false;
        });
      }
    }
  }

  void _onCameraFrame(CameraImage image) {
    // Throttle inference
    final now = DateTime.now();
    if (now.difference(_lastInferenceTime) < _inferenceInterval) return;
    _lastInferenceTime = now;

    _emotionService.processFrame(image, _selectedCamera!).then((result) {
      if (result != null && mounted) {
        final arabic =
            LocalTherapeuticStoryService.getEmotionArabic(result.label);
        setState(() {
          _currentEmotionLabel = result.label;
          _currentEmotionArabic = arabic.name;
          _currentEmotionEmoji = arabic.emoji;
          _currentConfidence = result.confidence;
        });
      }
    });
  }

  void _onWriteStoryPressed() {
    if (_currentEmotionLabel.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('انتظر حتى يتم التعرف على مشاعرك أولاً!'),
          backgroundColor: Color(0xFFE53E3E),
        ),
      );
      return;
    }

    // Stop the camera stream before navigating
    _cameraController?.stopImageStream();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WanisStoryWritingScreen(
          detectedEmotion: _currentEmotionLabel,
        ),
      ),
    ).then((_) {
      // Resume the camera stream when coming back
      if (_cameraController != null &&
          _cameraController!.value.isInitialized &&
          !_cameraController!.value.isStreamingImages) {
        _cameraController!.startImageStream(_onCameraFrame);
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      _cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    _emotionService.dispose();
    super.dispose();
  }

  Color _getEmotionColor() {
    switch (_currentEmotionLabel) {
      case 'Happiness':
        return const Color(0xFF48C774);
      case 'Sadness':
        return const Color(0xFF5D9CEC);
      case 'Anger':
        return const Color(0xFFE53E3E);
      case 'Fear':
        return const Color(0xFF9B59B6);
      case 'Surprise':
        return const Color(0xFFF39C12);
      case 'Disgust':
        return const Color(0xFF27AE60);
      case 'Contempt':
        return const Color(0xFF95A5A6);
      case 'Neutral':
        return const Color(0xFF636E72);
      default:
        return const Color(0xFF48C774);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A5568),
      body: SafeArea(
        child: Stack(
          children: [
            // Camera Preview
            if (_isCameraReady && _cameraController != null)
              Positioned.fill(
                child: ClipRRect(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _cameraController!.value.previewSize!.height,
                      height: _cameraController!.value.previewSize!.width,
                      child: CameraPreview(_cameraController!),
                    ),
                  ),
                ),
              ),

            // Loading or Error overlay
            if (_isInitializing || _hasError)
              Positioned.fill(
                child: Container(
                  color: const Color(0xFF4A5568),
                  child: Center(
                    child: _hasError
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.error_outline,
                                  color: Colors.white, size: 64),
                              const SizedBox(height: 16),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 32),
                                child: Text(
                                  _errorMessage,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          )
                        : const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(color: Colors.white),
                              SizedBox(height: 16),
                              Text(
                                'جاري تشغيل الكاميرا الذكية...',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                  ),
                ),
              ),

            // Close Button
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon:
                      const Icon(Icons.close, color: Colors.white, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),

            // Top Info Card
            Positioned(
              top: 32,
              left: 24,
              right: 24,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'كاميرا ونيس الذكية',
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xFFA0AEC0),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'وريني وشك الحلو يا بطل! 📸',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            // Face Guide Overlay (dashed oval border)
            if (_isCameraReady)
              Center(
                child: Container(
                  width: 260,
                  height: 340,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(130),
                    border: Border.all(
                      color: _currentEmotionLabel.isEmpty
                          ? Colors.white.withValues(alpha: 0.5)
                          : _getEmotionColor().withValues(alpha: 0.8),
                      width: 3,
                    ),
                  ),
                ),
              ),

            // Bottom Actions
            Positioned(
              bottom: 48,
              left: 24,
              right: 24,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Confidence indicator
                  if (_currentEmotionLabel.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        'الثقة: ${(_currentConfidence * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 13,
                        ),
                      ),
                    ),

                  // Emotion Chip
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 10),
                    decoration: BoxDecoration(
                      color: _currentEmotionLabel.isEmpty
                          ? Colors.white.withValues(alpha: 0.2)
                          : _getEmotionColor(),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: (_currentEmotionLabel.isEmpty
                                  ? Colors.black
                                  : _getEmotionColor())
                              .withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      _currentEmotionLabel.isEmpty
                          ? '$_currentEmotionArabic $_currentEmotionEmoji'
                          : '$_currentEmotionArabic $_currentEmotionEmoji',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _onWriteStoryPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5D9CEC),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 8,
                        shadowColor:
                            const Color(0xFF5D9CEC).withValues(alpha: 0.4),
                      ),
                      child: const Text(
                        'خلي ونيس يكتب قصتك ✍️',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
