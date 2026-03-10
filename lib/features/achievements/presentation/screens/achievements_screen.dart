import 'package:flutter/material.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildTotalStarsCard(),
              const SizedBox(height: 32),
              _buildBadgesTitle(),
              const SizedBox(height: 16),
              _buildBadgesGrid(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 26, vertical: 16),
      child: Center(
        child: Text(
          'إنجازاتي 🏆',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
      ),
    );
  }

  Widget _buildTotalStarsCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF5EB),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFF4A261), width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'مجموع النجوم',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Text(
                      'نجمة',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '120',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF4A261),
                        fontFamily: 'Arial',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFFFFECCC), // A placeholder for the star icon background/image
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.star_rounded,
                color: Color(0xFFF4A261),
                size: 48,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgesTitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 26),
      child: Text(
        'الأوسمة',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2D3748),
        ),
        textAlign: TextAlign.right,
      ),
    );
  }

  Widget _buildBadgesGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildBadgeCard(
            emoji: '📖',
            title: 'بطل القصص',
            status: 'مكتمل ✅',
            bgColor: const Color(0xFFEBF8FF), // Light blue
            borderColor: const Color(0xFF5D9CEC),
          ),
          _buildBadgeCard(
            emoji: '🎨',
            title: 'فنان مبدع',
            status: 'مكتمل ✅',
            bgColor: const Color(0xFFFDF2F8), // Light pink
            borderColor: const Color(0xFFED64A6),
          ),
          _buildBadgeCardWithProgress(
            emoji: '🧘',
            title: 'ملك الهدوء',
            progress: 0.5,
            bgColor: const Color(0xFFE6FFFA), // Light teal
            borderColor: const Color(0xFF38B2AC),
          ),
          _buildBadgeCard(
            emoji: '🔒',
            title: 'مستكشف',
            status: 'أكمل 5 ألعاب',
            bgColor: const Color(0xFFF7FAFC), // Light gray
            borderColor: const Color(0xFFCBD5E0),
            isLocked: true,
            statusColor: const Color(0xFFA0AEC0),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeCard({
    required String emoji,
    required String title,
    required String status,
    required Color bgColor,
    required Color borderColor,
    bool isLocked = false,
    Color statusColor = const Color(0xFF48BB78), // Green by default for success
  }) {
    return Container(
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
              color: isLocked ? const Color(0xFFEDF2F7) : bgColor,
              shape: BoxShape.circle,
              border: isLocked ? null : Border.all(color: borderColor, width: 2),
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
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isLocked ? const Color(0xFFA0AEC0) : const Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            status,
            style: TextStyle(
              fontSize: 14,
              color: statusColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeCardWithProgress({
    required String emoji,
    required String title,
    required double progress,
    required Color bgColor,
    required Color borderColor,
  }) {
    return Container(
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
              border: Border.all(color: borderColor, width: 2),
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
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: const Color(0xFFEDF2F7),
                valueColor: AlwaysStoppedAnimation<Color>(borderColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
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
            _buildNavItem(icon: Icons.stars_outlined, label: 'إنجازاتي', isActive: true),
            _buildNavItem(
              icon: Icons.home_filled, 
              label: 'الرئيسية', 
              isActive: false,
              onTap: () {
                // Return to home screen
                Navigator.pop(context); // Assumes we navigated here from Home via push
              },
            ),
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
