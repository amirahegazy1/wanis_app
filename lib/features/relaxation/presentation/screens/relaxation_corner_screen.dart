import 'package:flutter/material.dart';

import 'breathing_exercise_screen.dart';
import 'fidget_gaming_screen.dart';
import 'natural_sounds_screen.dart';

class RelaxationCornerScreen extends StatelessWidget {
  const RelaxationCornerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF2D3748), size: 20),
                    ),
                  ),
                  const Text(
                    'ركن الهدوء 🍃',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF22543D),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: _buildActivityCard(
                  context,
                  title: 'تمرين التنفس',
                  subtitle: 'شهيق وزفير ببطء...',
                  buttonText: 'ابدأ الآن',
                  buttonColor: const Color(0xFFC6F6D5),
                  buttonTextColor: const Color(0xFF276749),
                  imageWidget: const Icon(Icons.air, size: 64, color: Color(0xFF68D391)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BreathingExerciseScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _buildActivityCard(
                  context,
                  title: 'ألعاب التململ',
                  subtitle: 'فقع الفقاعات للاسترخاء',
                  buttonText: 'ابدأ الآن',
                  buttonColor: const Color(0xFFFED7E2),
                  buttonTextColor: const Color(0xFFB83280),
                  imageWidget: const Icon(Icons.touch_app, size: 64, color: Color(0xFFF687B3)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FidgetGamingScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _buildActivityCard(
                  context,
                  title: 'أصوات الطبيعة',
                  subtitle: 'مطر، بحر، غابة...',
                  buttonText: 'استماع',
                  buttonColor: const Color(0xFFBEE3F8),
                  buttonTextColor: const Color(0xFF2B6CB0),
                  imageWidget: const Icon(Icons.headphones, size: 64, color: Color(0xFF63B3ED)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NaturalSoundsScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String buttonText,
    required Color buttonColor,
    required Color buttonTextColor,
    required Widget imageWidget,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              imageWidget,
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF22543D),
                      ),
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF718096),
                      ),
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: buttonColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        buttonText,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: buttonTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
