import 'package:flutter/material.dart';

import 'wanis_story_writing_screen.dart';

class EmotionRecognitionCameraScreen extends StatefulWidget {
  const EmotionRecognitionCameraScreen({super.key});

  @override
  State<EmotionRecognitionCameraScreen> createState() => _EmotionRecognitionCameraScreenState();
}

class _EmotionRecognitionCameraScreenState extends State<EmotionRecognitionCameraScreen> {
  // Placeholder for current emotion detected
  String _currentEmotion = 'سعيد 😄';
  bool _isDetecting = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A5568), // Dark background from design
      body: SafeArea(
        child: Stack(
          children: [
            // Close Button
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 32),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            // Top Info Card
            Positioned(
              top: 32,
              left: 24,
              right: 24,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
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

            // Center Camera Guide (Placeholder)
            Center(
              child: Container(
                width: 280,
                height: 480,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(140),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 4,
                    style: BorderStyle.solid, // Flutter doesn't support dashed borders out of the box easily without package, using solid with opacity for now
                  ),
                ),
                child: Center(
                  // Mock face area with green circle
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                      border: Border.all(
                        color: const Color(0xFF48C774),
                        width: 2,
                      ),
                    ),
                    child: _isDetecting 
                        ? const Center(child: CircularProgressIndicator(color: Colors.white))
                        : null,
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
                  // Emotion Chip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF48C774),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      _currentEmotion,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
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
                      onPressed: () {
                        // Navigate to Story Writing
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WanisStoryWritingScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5D9CEC),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
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
