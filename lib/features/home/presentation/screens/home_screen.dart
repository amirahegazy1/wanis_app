import 'package:flutter/material.dart';

import '../../../games/presentation/screens/games_menu_screen.dart';
import '../../../relaxation/presentation/screens/relaxation_corner_screen.dart';
import '../../../stories/presentation/screens/stories_list_screen.dart';
import '../../../coloring/presentation/screens/coloring_menu_screen.dart';
import '../../../emotion_tracking/presentation/screens/daily_emotion_tracking_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomNavHeight = 80.0 + 24.0 + MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomNavHeight),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 12),
              Flexible(
                flex: 3,
                child: _buildHeroCard(context),
              ),
              const SizedBox(height: 16),
              _buildActivityLibraryTitle(),
              const SizedBox(height: 12),
              Flexible(
                flex: 4,
                child: _buildGridSection(context),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF5EB),
              border: Border.all(color: const Color(0xFFF4A261), width: 1.5),
              borderRadius: BorderRadius.circular(31),
            ),
            child: Row(
              children: [
                const Icon(Icons.star, color: Color(0xFFF4A261), size: 16),
                const SizedBox(width: 4),
                const Text(
                  '150',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                    fontFamily: 'Arial',
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Text(
                    'أهلاً زين 👋',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  Text(
                    'لنبدأ مغامرة اليوم!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFA0AEC0),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFEBF8FF),
                  border: Border.all(color: const Color(0xFF5D9CEC), width: 2),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Text(
                  '👦',
                  style: TextStyle(fontSize: 32),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const StoriesListScreen()),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF5D9CEC),
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Positioned(
                left: -40,
                bottom: -40,
                child: Opacity(
                  opacity: 0.1,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              const Positioned(
                top: 20,
                right: 80,
                child: Text('📖', style: TextStyle(fontSize: 80)),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Color(0xFF5D9CEC),
                    size: 28,
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'قصة: عمر واللعبة',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'تعلم كيف تطلب المساعدة بهدوء',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
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

  Widget _buildActivityLibraryTitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 26),
      child: Text(
        'مكتبة الأنشطة',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2D3748),
        ),
        textAlign: TextAlign.right,
      ),
    );
  }

  Widget _buildGridSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _buildActivityCard(
                    context,
                    title: 'ألعاب',
                    emoji: '🧩',
                    bgColor: const Color(0xFFFFF5EB),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GamesMenuScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildActivityCard(
                    context,
                    title: 'هدوء',
                    emoji: '🍃',
                    bgColor: const Color(0xFFE6FFFA),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RelaxationCornerScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _buildActivityCard(
                    context,
                    title: 'تلوين',
                    emoji: '🎨',
                    bgColor: const Color(0xFFEBF8FF),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ColoringMenuScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildActivityCard(
                    context,
                    title: 'مشاعر',
                    emoji: '😊',
                    bgColor: const Color(0xFFFDF2F8),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DailyEmotionTrackingScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(
    BuildContext context, {
    required String title,
    required String emoji,
    required Color bgColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 32),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
