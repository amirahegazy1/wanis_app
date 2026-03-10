import 'package:flutter/material.dart';

import '../../../games/presentation/screens/games_menu_screen.dart';
import '../../../relaxation/presentation/screens/relaxation_corner_screen.dart';
import '../../../stories/presentation/screens/stories_list_screen.dart';
import '../../../coloring/presentation/screens/coloring_menu_screen.dart';
import '../../../emotion_tracking/presentation/screens/daily_emotion_tracking_screen.dart';
import '../../../achievements/presentation/screens/achievements_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Removed status bar / app bar as requested, and bottom nav is custom
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildHeroCard(context),
              const SizedBox(height: 32),
              _buildActivityLibraryTitle(),
              const SizedBox(height: 16),
              _buildGridSection(context),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      // This bottom nav structure follows the design visually
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Points badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF5EB),
              border: Border.all(color: const Color(0xFFF4A261), width: 1.5),
              borderRadius: BorderRadius.circular(31),
            ),
            child: Row(
              children: [
                const Icon(Icons.star, color: Color(0xFFF4A261), size: 16), // Using standard icon as placeholder for the star
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

          // User info
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Text(
                    'أهلاً زين 👋',
                    style: TextStyle(
                      fontSize: 24, // Adjusted size to fit better based on typical Readex Pro
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
              // Avatar
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
        height: 240,
        decoration: BoxDecoration(
          color: const Color(0xFF5D9CEC), // Primary blue
          borderRadius: BorderRadius.circular(20),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Mock background elements from figma
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
            // Book icon big center
            const Positioned(
              top: 40,
              right: 80,
              child: Text('📖', style: TextStyle(fontSize: 80)),
            ),
            // Play button
            Positioned(
              bottom: 20,
              left: 20,
              child: Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Color(0xFF5D9CEC),
                  size: 32,
                ),
              ),
            ),
            // Text Content
            Positioned(
              bottom: 30,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'قصة: عمر واللعبة',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Changed to white because figma color code seemed to be on a blue BG
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
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildActivityCard(
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
          _buildActivityCard(
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
          _buildActivityCard(
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
          _buildActivityCard(
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

  Widget _buildBottomNav(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24), // Avoid bottom edge, making it float
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(icon: Icons.person_outline, label: 'حسابي', isActive: false),
            _buildNavItem(
              icon: Icons.stars_outlined, 
              label: 'إنجازاتي', 
              isActive: false,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AchievementsScreen(),
                  ),
                );
              },
            ),
            _buildNavItem(icon: Icons.home_filled, label: 'الرئيسية', isActive: true),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon, 
    required String label, 
    required bool isActive,
    VoidCallback? onTap,
  }) {
    final color = isActive ? const Color(0xFFF4A261) : const Color(0xFFA0AEC0);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
