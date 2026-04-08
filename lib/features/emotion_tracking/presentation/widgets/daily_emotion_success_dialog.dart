import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class DailyEmotionSuccessDialog extends StatelessWidget {
  const DailyEmotionSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(38),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Floating Hearts graphic placeholder
            SizedBox(
              height: 120,
              width: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                   Container(
                     width: 120,
                     height: 120,
                     decoration: const BoxDecoration(
                       shape: BoxShape.circle,
                       color: Color(0xFFFFF5EB), // Soft orange background as placeholder
                     ),
                   ),
                   const Positioned(
                     top: 10,
                     right: 15,
                     child: Text('💖', style: TextStyle(fontSize: 24)),
                   ),
                   const Positioned(
                     bottom: 25,
                     left: 10,
                     child: Text('💖', style: TextStyle(fontSize: 20)),
                   ),
                   const Icon(Icons.favorite, color: Color(0xFFF4A261), size: 50),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'شكراً لمشاركتنا 🤗',
              style: GoogleFonts.readexPro(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2D3748),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'تم حفظ حالتك المزاجية اليوم',
              style: GoogleFonts.readexPro(
                fontSize: 16,
                color: const Color(0xFFA0AEC0),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 9),
              decoration: BoxDecoration(
                color: const Color(0xFFE6FFFA),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Text(
                '+10 نقاط',
                style: GoogleFonts.readexPro(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF38B2AC),
                ),
              ),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: Material(
                color: const Color(0xFF5D9CEC),
                borderRadius: BorderRadius.circular(34),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  borderRadius: BorderRadius.circular(34),
                  child: Center(
                    child: Text(
                      'العودة للرئيسية 🏠',
                      style: GoogleFonts.readexPro(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
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
