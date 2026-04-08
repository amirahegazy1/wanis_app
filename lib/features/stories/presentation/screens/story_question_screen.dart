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
            const SizedBox(height: 16),
            Flexible(
              flex: 3,
              child: _buildStoryIllustration(),
            ),
            const SizedBox(height: 16),
            Flexible(
              flex: 7,
              child: _buildQuestionContent(context),
            ),
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
                  value: 0.5,
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
        width: double.infinity,
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

  Widget _buildQuestionContent(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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

            const SizedBox(height: 24),

            LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = (constraints.maxWidth - 16) / 2;
                final cardHeight = cardWidth * 1.25;
                return Row(
                  children: [
                    Expanded(
                      child: _buildEmotionChoice(
                        emoji: '😡',
                        label: 'غاضب',
                        bgColor: const Color(0xFFFFF5F5),
                        borderColor: const Color(0xFFFC8181),
                        textColor: const Color(0xFFE53E3E),
                        height: cardHeight,
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildEmotionChoice(
                        emoji: '😢',
                        label: 'حزين',
                        bgColor: const Color(0xFFEBF8FF),
                        borderColor: const Color(0xFF5D9CEC),
                        textColor: const Color(0xFF2B6CB0),
                        height: cardHeight,
                        onTap: () {},
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 20),

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
            const SizedBox(height: 8),
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
    required double height,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
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
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 12),
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
