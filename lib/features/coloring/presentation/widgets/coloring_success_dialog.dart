import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../home/presentation/screens/main_navigation_screen.dart';
import '../screens/coloring_menu_screen.dart';

class ColoringSuccessDialog extends StatelessWidget {
  const ColoringSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      elevation: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSuccessCard(),
          const SizedBox(height: 24),
          _buildPrimaryButton(context),
          const SizedBox(height: 16),
          _buildSecondaryButton(context),
        ],
      ),
    );
  }

  Widget _buildSuccessCard() {
    return CustomPaint(
      painter: DashedRoundedBorderPainter(
        color: const Color(0xFFF4A261),
        strokeWidth: 4,
        dashWidth: 10,
        dashSpace: 8,
        radius: 32,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          children: [
            // Placeholder for the easel icon
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: Color(0xFFFFF5EB),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  '🎨',
                  style: TextStyle(fontSize: 60),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'لوحة فنية رائعة! 😍',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'تم حفظ رسمتك في المعرض',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFA0AEC0),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE6FFFA), // Light cyan
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '+20 نقطة',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF38B2AC), // Teal
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrimaryButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF4A261), // Orange
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 0,
        ),
        onPressed: () {
          // Go back to home
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
            (route) => false,
          );
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'العودة للرئيسية',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 8),
            Text('🏠', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final navigator = Navigator.of(context);
        navigator.pop();
        navigator.pushReplacement(
          MaterialPageRoute(builder: (_) => const ColoringMenuScreen()),
        );
      },
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          'تلوين رسمة أخرى',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class DashedRoundedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double radius;

  DashedRoundedBorderPainter({
    required this.color,
    this.strokeWidth = 2,
    this.dashWidth = 8,
    this.dashSpace = 4,
    this.radius = 16,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );

    final Path path = Path()..addRRect(rrect);
    final PathMetrics pathMetrics = path.computeMetrics();

    for (PathMetric pathMetric in pathMetrics) {
      double distance = 0.0;
      bool draw = true;
      while (distance < pathMetric.length) {
        final double length = draw ? dashWidth : dashSpace;
        if (draw) {
          canvas.drawPath(
            pathMetric.extractPath(distance, distance + length),
            paint,
          );
        }
        distance += length;
        draw = !draw;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
