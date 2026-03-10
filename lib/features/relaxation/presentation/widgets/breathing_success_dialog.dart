import 'package:flutter/material.dart';

class BreathingSuccessDialog extends StatelessWidget {
  const BreathingSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top icon
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: Color(0xFFF0FFF4),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Text(
                '🧘',
                style: TextStyle(fontSize: 60),
              ),
            ),
            const SizedBox(height: 24),
            // Title
            const Text(
              'أنت هادئ الآن..',
              style: TextStyle(
                fontSize: 24, // Adjusted for typical dialogue sizes
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C7A7B),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // Subtitle
            const Text(
              'تنفسك أصبح أعمق وأفضل',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF718096),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Badge tag
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE6FFFA),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text(
                'استرخاء تام✨',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF38B2AC),
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Primary button
            GestureDetector(
              onTap: () {
                // Pop the dialog
                Navigator.pop(context);
                // Pop the breathing screen to return to the Relaxation corner menu
                Navigator.pop(context);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF38B2AC),
                  borderRadius: BorderRadius.circular(38),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'العودة 🍃',
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
    );
  }
}
