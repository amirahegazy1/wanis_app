import 'dart:io';
import 'dart:developer' as developer;

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

  // Screen states
  bool _isInitializing = true;
  bool _hasError = false;
  String _errorMessage = '';
  bool _isCameraReady = false;

  // Capture & analysis states
  bool _isAnalyzing = false;
  bool _isFrozen = false;
  String? _capturedImagePath;
  EmotionResult? _analysisResult;
  String _analysisStatusText = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeAll();
  }

  Future<void> _initializeAll() async {
    try {
      // Initialize emotion service (loads model + face detector)
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
      developer.log('CameraScreen: Init error: $e', name: 'EmotionCamera');
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
    );

    try {
      await _cameraController!.initialize();
      if (!mounted) return;

      setState(() {
        _isCameraReady = true;
        _isInitializing = false;
      });
    } catch (e) {
      developer.log('CameraScreen: Camera init error: $e', name: 'EmotionCamera');
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'حدث خطأ أثناء تشغيل الكاميرا: $e';
          _isInitializing = false;
        });
      }
    }
  }

  /// Called when the user presses the main action button.
  /// Captures a photo, freezes preview, analyzes, shows result, then navigates.
  Future<void> _onCaptureAndAnalyze() async {
    if (_isAnalyzing || !_isCameraReady || _cameraController == null) return;

    setState(() {
      _isAnalyzing = true;
      _isFrozen = false;
      _analysisResult = null;
      _analysisStatusText = 'جاري التقاط الصورة... 📸';
    });

    try {
      // Step 1: Capture photo
      final XFile photo = await _cameraController!.takePicture();
      developer.log('CameraScreen: Photo captured: ${photo.path}', name: 'EmotionCamera');

      setState(() {
        _capturedImagePath = photo.path;
        _isFrozen = true;
        _analysisStatusText = 'جاري تحليل مشاعرك... 🔍';
      });

      // Step 2: Analyze the captured image
      final result = await _emotionService.processImageFile(photo.path);

      if (!mounted) return;

      if (result != null) {
        final arabic = LocalTherapeuticStoryService.getEmotionArabic(result.label);

        setState(() {
          _analysisResult = result;
          _analysisStatusText = 'تم التعرف على شعورك! ${arabic.emoji}';
        });

        // Brief pause to show the result before navigating
        await Future.delayed(const Duration(milliseconds: 1200));

        if (!mounted) return;

        // Step 3: Navigate to story screen
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WanisStoryWritingScreen(
              detectedEmotion: result.label,
            ),
          ),
        );

        // When coming back, reset to live preview
        if (mounted) _resetToLivePreview();
      } else {
        // No face detected
        setState(() {
          _analysisStatusText = 'مش شايف وشك! حط وشك جوا الدايرة وجرب تاني 😊';
          _isAnalyzing = false;
        });

        // Auto-reset after a delay
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) _resetToLivePreview();
      }
    } catch (e, stack) {
      developer.log('CameraScreen: Capture/analyze error: $e\n$stack', name: 'EmotionCamera');
      if (mounted) {
        setState(() {
          _analysisStatusText = 'حصل خطأ، جرب تاني!';
          _isAnalyzing = false;
        });

        await Future.delayed(const Duration(seconds: 2));
        if (mounted) _resetToLivePreview();
      }
    }
  }

  /// Resets the screen back to live camera preview.
  void _resetToLivePreview() {
    setState(() {
      _isFrozen = false;
      _isAnalyzing = false;
      _capturedImagePath = null;
      _analysisResult = null;
      _analysisStatusText = '';
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

  Color _getEmotionColor(String label) {
    switch (label) {
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
            // Camera Preview or Frozen Image
            if (_isFrozen && _capturedImagePath != null)
              Positioned.fill(
                child: Image.file(
                  File(_capturedImagePath!),
                  fit: BoxFit.cover,
                ),
              )
            else if (_isCameraReady && _cameraController != null)
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

            // Analyzing overlay
            if (_isAnalyzing)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.4),
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
                    const Text(
                      'كاميرا ونيس الذكية',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFA0AEC0),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isAnalyzing
                          ? _analysisStatusText
                          : 'وريني وشك الحلو يا بطل! 📸',
                      style: const TextStyle(
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

            // Face Guide Overlay (oval border)
            if (_isCameraReady && !_isFrozen)
              Center(
                child: Container(
                  width: 260,
                  height: 340,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(130),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.5),
                      width: 3,
                    ),
                  ),
                ),
              ),

            // Analysis result overlay (when frozen with result)
            if (_isFrozen && _analysisResult != null)
              Center(
                child: _buildResultBadge(),
              ),

            // Analyzing spinner overlay
            if (_isAnalyzing && _analysisResult == null)
              const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'جاري التحليل...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

            // Bottom Action
            Positioned(
              bottom: 48,
              left: 24,
              right: 24,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: (_isCameraReady && !_isAnalyzing)
                          ? _onCaptureAndAnalyze
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5D9CEC),
                        disabledBackgroundColor:
                            const Color(0xFF5D9CEC).withValues(alpha: 0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 8,
                        shadowColor:
                            const Color(0xFF5D9CEC).withValues(alpha: 0.4),
                      ),
                      child: _isAnalyzing
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
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

  /// Builds a floating badge showing the detected emotion over the frozen image.
  Widget _buildResultBadge() {
    final result = _analysisResult!;
    final arabic = LocalTherapeuticStoryService.getEmotionArabic(result.label);
    final color = _getEmotionColor(result.label);

    return AnimatedScale(
      scale: 1.0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.elasticOut,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              arabic.emoji,
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 8),
            Text(
              arabic.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'الثقة: ${(result.confidence * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
