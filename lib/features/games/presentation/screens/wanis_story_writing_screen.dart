import 'package:flutter/material.dart';

import '../../services/therapeutic_story_service.dart';

class WanisStoryWritingScreen extends StatefulWidget {
  /// The emotion detected by the camera screen (e.g. "Happiness", "Sadness").
  final String detectedEmotion;

  const WanisStoryWritingScreen({
    super.key,
    required this.detectedEmotion,
  });

  @override
  State<WanisStoryWritingScreen> createState() =>
      _WanisStoryWritingScreenState();
}

class _WanisStoryWritingScreenState extends State<WanisStoryWritingScreen>
    with SingleTickerProviderStateMixin {
  final LocalTherapeuticStoryService _storyService =
      LocalTherapeuticStoryService();

  TherapeuticStory? _story;
  bool _isLoading = true;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _loadStory();
  }

  Future<void> _loadStory() async {
    final story = await _storyService.generateStory(widget.detectedEmotion);
    if (mounted) {
      setState(() {
        _story = story;
        _isLoading = false;
      });
      _fadeController.forward();
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Color _getEmotionColor() {
    switch (widget.detectedEmotion) {
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
        return const Color(0xFF5D9CEC);
    }
  }

  @override
  Widget build(BuildContext context) {
    final emotionColor = _getEmotionColor();
    final emotionInfo =
        LocalTherapeuticStoryService.getEmotionArabic(widget.detectedEmotion);

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: SafeArea(
        child: _isLoading ? _buildLoadingView(emotionInfo) : _buildStoryView(emotionColor, emotionInfo),
      ),
    );
  }

  Widget _buildLoadingView(({String name, String emoji}) emotionInfo) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated writing icon
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(seconds: 2),
            builder: (context, value, child) {
              return Transform.rotate(
                angle: value * 0.1,
                child: Text(
                  '✍️',
                  style: TextStyle(fontSize: 64 + (value * 8)),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            'ونيس بيألف قصة عن شعور "${emotionInfo.name}" ${emotionInfo.emoji}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'استنى ثواني يا بطل...',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFFA0AEC0),
            ),
          ),
          const SizedBox(height: 32),
          const CircularProgressIndicator(
            color: Color(0xFF5D9CEC),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryView(
      Color emotionColor, ({String name, String emoji}) emotionInfo) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Back button row
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_rounded,
                      color: Color(0xFF2D3748)),
                  onPressed: () => Navigator.pop(context),
                ),
                const Spacer(),
                // Emotion badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: emotionColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: emotionColor.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    '${emotionInfo.name} ${emotionInfo.emoji}',
                    style: TextStyle(
                      color: emotionColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Story Title Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    emotionColor.withOpacity(0.8),
                    emotionColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: emotionColor.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    _story!.emoji,
                    style: const TextStyle(fontSize: 48),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _story!.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Story Body
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                _story!.body,
                style: const TextStyle(
                  fontSize: 17,
                  height: 1.8,
                  color: Color(0xFF2D3748),
                ),
                textAlign: TextAlign.right,
              ),
            ),
            const SizedBox(height: 20),

            // Moral Lesson Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF5E6),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFF6AD55).withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  const Text('💡', style: TextStyle(fontSize: 32)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'الدرس المستفاد',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFDD6B20),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _story!.moralLesson,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF744210),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                // Read Another Story
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _isLoading = true;
                        });
                        _fadeController.reset();
                        _loadStory();
                      },
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text(
                        'قصة تانية',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: emotionColor,
                        side: BorderSide(color: emotionColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Go Back
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.camera_alt_rounded),
                      label: const Text(
                        'رجوع للكاميرا',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: emotionColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
