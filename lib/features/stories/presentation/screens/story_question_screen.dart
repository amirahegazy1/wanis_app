import 'package:flutter/material.dart';

class StoryQuestionScreen extends StatelessWidget {
  const StoryQuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            const SizedBox(height: 24),
            _buildStoryIllustration(),
            const SizedBox(height: 48),
            _buildQuestionContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Nav Back Button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE2E8F0)),
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Color(0xFF2D3748),
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Progress Bar
          Expanded(
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(4),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: const LinearProgressIndicator(
                  value: 0.5, // Example progress for Question frame
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5D9CEC)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryIllustration() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        height: 200, // Reduced height compared to player to fit question UI
        decoration: BoxDecoration(
          color: const Color(0xFFF0F4F8),
          borderRadius: BorderRadius.circular(24),
        ),
        clipBehavior: Clip.antiAlias,
        child: const Center(
          child: Text(
            '🧸 🛋️ 🚪',
            style: TextStyle(fontSize: 60),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionContent() {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white, // In Figma there's an overlay but we'll build it natively
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // Using a positioned card that resembles the question frame 
            Positioned(
              top: 0,
              left: 24,
              right: 24,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Close button top right (left in RTL app context but standard dialog)
                    Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF7FAFC),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close, color: Color(0xFFA0AEC0), size: 20),
                        ),
                      ),
                    ),
                    
                    // Question Icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEBF8FF),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Text('🤔', style: TextStyle(fontSize: 40)),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    const Text(
                      'كيف يشعر عمر الآن؟',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'اختر الشعور المناسب للصورة',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFA0AEC0),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Emotion Choices
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildEmotionChoice(
                          emoji: '😡',
                          label: 'غاضب',
                          bgColor: const Color(0xFFFFF5F5),
                          borderColor: const Color(0xFFFC8181),
                          textColor: const Color(0xFFE53E3E),
                          onTap: () {
                            // Trigger Try Again Feedback
                          },
                        ),
                        _buildEmotionChoice(
                          emoji: '😢',
                          label: 'حزين',
                          bgColor: const Color(0xFFEBF8FF),
                          borderColor: const Color(0xFF5D9CEC),
                          textColor: const Color(0xFF2B6CB0),
                          onTap: () {
                            // Trigger Right Answer Feedback
                          },
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Pagination dots placeholder
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: index == 0 ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: index == 0 ? const Color(0xFFF4A261) : const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmotionChoice({
    required String emoji,
    required String label,
    required Color bgColor,
    required Color borderColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        height: 180,
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor, width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 64),
            ),
            const SizedBox(height: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
