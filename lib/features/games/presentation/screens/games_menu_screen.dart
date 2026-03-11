import 'package:flutter/material.dart';

import 'emotion_recognition_camera_screen.dart';
import 'matching_feelings_game_screen.dart';
import 'memory_game_screen.dart';
import 'sorting_game_screen.dart';

class GamesMenuScreen extends StatelessWidget {
  const GamesMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC), // General background color assumed from design
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3748)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'غرفة الألعاب 🧩',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          children: [
            _buildGameCard(
              context,
              title: 'فرز الأشكال والألوان',
              subtitle: 'ضع كل شكل في مكانه الصحيح',
              iconWidget: const _Game1Icon(), // Custom visual
              cardBgColor: Colors.white,
              iconBgColor: const Color(0xFFFFF5F5),
              playButtonColor: const Color(0xFFF6AD55),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SortingGameScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildGameCard(
              context,
              title: 'مطابقة المشاعر',
              subtitle: 'وصل الوجه بالشعور المناسب',
              iconWidget: const Text(
                '😊 ... 😡',
                style: TextStyle(fontSize: 20, letterSpacing: 2),
              ),
              cardBgColor: Colors.white,
              iconBgColor: const Color(0xFFEBF8FF),
              playButtonColor: const Color(0xFF63B3ED),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MatchingFeelingsGameScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildGameCard(
              context,
              title: 'لعبة الذاكرة',
              subtitle: 'تذكر أماكن الصور المتشابهة',
              iconWidget: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 30,
                    height: 40,
                    color: const Color(0x3348C774),
                    alignment: Alignment.center,
                    child: const Text('❓'),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 30,
                    height: 40,
                    color: const Color(0xFF48C774),
                    alignment: Alignment.center,
                    child: const Text('🐱'),
                  ),
                ],
              ),
              cardBgColor: Colors.white,
              iconBgColor: const Color(0xFFE6FFFA),
              playButtonColor: const Color(0xFF48C774),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MemoryGameScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildGameCard(
              context,
              title: 'قصص ونيس 🤖',
              subtitle: 'حول شعورك لحكاية! ✨',
              iconWidget: const Icon(Icons.camera_alt_rounded, size: 40, color: Color(0xFF9F7AEA)),
              cardBgColor: Colors.white,
              iconBgColor: const Color(0xFFFAF5FF),
              playButtonColor: const Color(0xFF9F7AEA),
              subtitleColor: const Color(0xFF9F7AEA),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EmotionRecognitionCameraScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required Widget iconWidget,
    required Color cardBgColor,
    required Color iconBgColor,
    required Color playButtonColor,
    Color? subtitleColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: iconWidget,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: subtitleColor ?? const Color(0xFFA0AEC0),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: playButtonColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 20,
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

class _Game1Icon extends StatelessWidget {
  const _Game1Icon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(width: 20, height: 20, decoration: const BoxDecoration(color: Color(0xFFFC8181), shape: BoxShape.circle)),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(width: 20, height: 20, decoration: BoxDecoration(color: const Color(0xFF48C774), borderRadius: BorderRadius.circular(4))),
          ),
          Positioned(
            left: 10,
            bottom: 0,
            child: Icon(Icons.change_history, size: 24, color: const Color(0xFF63B3ED)),
          ),
        ],
      ),
    );
  }
}
