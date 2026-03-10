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
              // Header
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
              const SizedBox(height: 32),
              // Breathing Exercise Card
              _buildActivityCard(
                context,
                title: 'تمرين التنفس',
                subtitle: 'شهيق وزفير ببطء...',
                buttonText: 'ابدأ الآن',
                buttonColor: const Color(0xFFC6F6D5),
                buttonTextColor: const Color(0xFF276749),
                imageWidget: const Icon(Icons.air, size: 80, color: Color(0xFF68D391)), // Placeholder for the face/air icon
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BreathingExerciseScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              // Fidget Games Card
              _buildActivityCard(
                context,
                title: 'ألعاب التململ',
                subtitle: 'فقع الفقاعات للاسترخاء',
                buttonText: 'ابدأ الآن',
                buttonColor: const Color(0xFFFED7E2),
                buttonTextColor: const Color(0xFFB83280),
                imageWidget: const Icon(Icons.touch_app, size: 80, color: Color(0xFFF687B3)), // Placeholder for fidget icon
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FidgetGamingScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              // Natural Sounds Card
              _buildActivityCard(
                context,
                title: 'أصوات الطبيعة',
                subtitle: 'مطر، بحر، غابة...',
                buttonText: 'استماع',
                buttonColor: const Color(0xFFBEE3F8),
                buttonTextColor: const Color(0xFF2B6CB0),
                imageWidget: const Icon(Icons.headphones, size: 80, color: Color(0xFF63B3ED)), // Placeholder
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NaturalSoundsScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
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
        height: 160,
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
        child: Stack(
          children: [
            // Image / Graphic on the left side
            Positioned(
              left: 20,
              top: 40,
              child: imageWidget,
            ),
            // Text and Button on the right side
            Positioned(
              right: 20,
              top: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF22543D),
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF718096),
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
    );
  }
}
