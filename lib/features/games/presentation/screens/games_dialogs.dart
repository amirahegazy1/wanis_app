import 'package:flutter/material.dart';

class SortingGameWinDialog extends StatelessWidget {
  final VoidCallback onNextGame;
  final VoidCallback onReturnToMenu;

  const SortingGameWinDialog({
    super.key,
    required this.onNextGame,
    required this.onReturnToMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '🏆',
              style: TextStyle(fontSize: 80),
            ),
            const SizedBox(height: 16),
            const Text(
              'مذهل يا بطل! 🌟',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'لقد أنهيت فرز الألوان بنجاح',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFA0AEC0),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF5EB),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text(
                '+50 نقطة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF4A261),
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onNextGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5D9CEC),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'اللعبة التالية 🎮',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: onReturnToMenu,
              child: const Text(
                'العودة للقائمة',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFA0AEC0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MatchingFeelingsWinDialog extends StatelessWidget {
  final VoidCallback onNextGame;
  final VoidCallback onReturnToMenu;

  const MatchingFeelingsWinDialog({
    super.key,
    required this.onNextGame,
    required this.onReturnToMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 120,
              width: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Text('💖', style: TextStyle(fontSize: 60)),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: const Text('🎭', style: TextStyle(fontSize: 40)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'خبير المشاعر! 🤩',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'أنت تفهم لغة الوجوه جيداً',
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
                color: const Color(0xFFFFF5EB),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text(
                '+50 نقطة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF4A261),
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onNextGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5D9CEC),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'اللعبة التالية 🎮',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: onReturnToMenu,
              child: const Text(
                'العودة للقائمة',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFA0AEC0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MatchingFeelingsTryAgainDialog extends StatelessWidget {
  final VoidCallback onRetry;

  const MatchingFeelingsTryAgainDialog({
    super.key,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '🤔',
              style: TextStyle(fontSize: 80),
            ),
            const SizedBox(height: 16),
            const Text(
              'ممم.. ليست هذه!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'جرب توصيل وجه آخر.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFA0AEC0),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF4A261), // Orange from design matching try again
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: const Text(
                  'حاول مجدداً',
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

class MemoryGameWinDialog extends StatelessWidget {
  final VoidCallback onNextGame;
  final VoidCallback onReturnToMenu;

  const MemoryGameWinDialog({
    super.key,
    required this.onNextGame,
    required this.onReturnToMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '🧠',
              style: TextStyle(fontSize: 80),
            ),
            const SizedBox(height: 16),
            const Text(
              'ذاكرة قوية! 🌟',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'لقد تذكرت جميع الصور بنجاح',
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
                color: const Color(0xFFE6FFFA),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text(
                '+50 نقطة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF38B2AC),
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onNextGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5D9CEC),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'اللعبة التالية 🎮',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: onReturnToMenu,
              child: const Text(
                'العودة للقائمة',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFA0AEC0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


