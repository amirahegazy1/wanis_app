import 'package:flutter/material.dart';

class AnswerFeedbackDialog extends StatelessWidget {
  final bool isSuccess;
  final String title;
  final String subtitle;
  final int points;
  final String buttonText;
  final VoidCallback onButtonPressed;

  const AnswerFeedbackDialog({
    super.key,
    required this.isSuccess,
    required this.title,
    required this.subtitle,
    required this.points,
    required this.buttonText,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = isSuccess ? const Color(0xFF48C774) : const Color(0xFFE53E3E);
    final iconBgColor = isSuccess ? const Color(0xFFE6FFFA) : const Color(0xFFFFF5F5); // Faded background colors based on figma nodes normally
    
    // In Figma: e.g. "إجابة رائعة! 🌟" 
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Big Emoji Context (Based on success/failure)
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                isSuccess ? '🌟' : '💡',
                style: const TextStyle(fontSize: 60),
              ),
            ),
            const SizedBox(height: 22),
            
            // Text Context
            Text(
              title,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 18,
                color: Color(0xFF2D3748),
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 16),
            
            // Points Bubble
            if (points > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6FFFA),
                  borderRadius: BorderRadius.circular(23),
                ),
                child: Text(
                  '+$points نجوم',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF48C774),
                  ),
                ),
              ),
              
            const SizedBox(height: 31),
            
            // Primary Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: onButtonPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5D9CEC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(46),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(
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
