import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'mimicry_sessions_screen.dart';

/// Shows the result after completing a mimicry activity.
class MimicryResultScreen extends StatelessWidget {
  final double score;
  final String activityName;
  final int levelId;
  final double requiredScore;

  const MimicryResultScreen({
    super.key,
    required this.score,
    required this.activityName,
    required this.levelId,
    required this.requiredScore,
  });

  static const _blue = Color(0xFF4A90E2);
  static const _darkBlue = Color(0xFF005DA7);
  static const _green = Color(0xFF22C55E);

  static TextStyle _cairo({double sz = 16, FontWeight fw = FontWeight.w400, Color c = Colors.white}) =>
      GoogleFonts.cairo(fontSize: sz, fontWeight: fw, color: c);

  @override
  Widget build(BuildContext context) {
    final success = score >= requiredScore;
    final bgColor = success ? _green : _darkBlue;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(success ? '🎉' : '💪', style: const TextStyle(fontSize: 80)),
                  const SizedBox(height: 20),
                  Text(
                    success ? 'أحسنت!' : 'حاول تاني!',
                    style: _cairo(sz: 36, fw: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(activityName, style: _cairo(sz: 18, c: Colors.white.withValues(alpha: 0.8))),
                  const SizedBox(height: 32),

                  // Score circle
                  Container(
                    width: 140, height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.15),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 3),
                    ),
                    child: Center(
                      child: Text(
                        '${score.toStringAsFixed(0)}%',
                        style: _cairo(sz: 42, fw: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    success ? 'النشاط الجاي اتفتح! 🔓' : 'محتاج ${requiredScore.toStringAsFixed(0)}% عشان تعدي',
                    style: _cairo(sz: 16, c: Colors.white.withValues(alpha: 0.8)),
                  ),
                  const SizedBox(height: 40),

                  // Back to sessions button
                  GestureDetector(
                    onTap: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const MimicrySessionsScreen()),
                      (route) => route.isFirst,
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), offset: const Offset(0, 6), blurRadius: 12)],
                      ),
                      child: Center(
                        child: Text('العودة للأنشطة', style: _cairo(sz: 18, fw: FontWeight.w700, c: _blue)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
