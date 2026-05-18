import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Levels Screen (Figma node `119:130` / `30:1424`).
///
/// This is the main screen of the application, displayed after the user
/// creates an account and completes the survey. On subsequent logins
/// (when the user hasn't logged out), this screen is shown immediately.
class LevelsScreen extends StatelessWidget {
  const LevelsScreen({super.key});

  // ── Design tokens from Figma ────────────────────────────────────

  static const _primaryBlue = Color(0xFF4A90E2);
  static const _bgGradientStart = Color(0xFFF8F9FF);
  static const _headerBorderColor = Color(0xFFF1F5F9);
  static const _subtitleColor = Color(0xFF475569);
  static const _darkText = Color(0xFF0F172A);
  static const _lockedTextColor = Color(0xFF64748B);
  static const _lockedBorderColor = Color(0xFFE2E8F0);
  static const _greenBadge = Color(0xFF22C55E);

  // ── Cairo font helper ───────────────────────────────────────────

  static TextStyle _cairo({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w400,
    Color color = Colors.black,
    double? height,
  }) {
    return GoogleFonts.cairo(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgGradientStart,
      body: Stack(
        children: [
          // ── Watermark background (10% opacity rocket) ──────────
          Positioned.fill(
            child: Opacity(
              opacity: 0.10,
              child: Center(
                child: Icon(
                  Icons.rocket_launch_rounded,
                  size: 334,
                  color: _primaryBlue.withValues(alpha: 0.3),
                ),
              ),
            ),
          ),

          // ── Main content ──────────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                // ── Header ──────────────────────────────────────
                _buildHeader(context),

                // ── Scrollable body ─────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 32, 20, 48),
                    child: Column(
                      children: [
                        // Status Headline
                        _buildStatusHeadline(),
                        const SizedBox(height: 40),

                        // Levels Roadmap
                        _buildLevelsRoadmap(),

                        // Decorative illustration
                        const SizedBox(height: 40),
                        _buildDecorativeIllustration(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: _headerBorderColor, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 1),
            blurRadius: 1,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Arrow button (right side in RTL)
          GestureDetector(
            onTap: () {
              // Future navigation action
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_forward,
                  size: 16,
                  color: _lockedTextColor,
                ),
              ),
            ),
          ),
          // Title
          Text(
            'المستويات',
            style: _cairo(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _primaryBlue,
            ),
          ),
        ],
      ),
    );
  }

  // ── Status Headline ─────────────────────────────────────────────

  Widget _buildStatusHeadline() {
    return Column(
      children: [
        // "مرحباً يا بطل!"
        Text(
          'مرحباً يا بطل!',
          style: _cairo(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: _subtitleColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),

        // Current level badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 11),
          decoration: BoxDecoration(
            color: _primaryBlue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(9999),
            border: Border.all(
              color: _primaryBlue.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'المستوى الحالي: 1',
                style: _cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: _primaryBlue,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.stars_rounded,
                size: 17,
                color: _primaryBlue,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Levels Roadmap ──────────────────────────────────────────────

  Widget _buildLevelsRoadmap() {
    return Column(
      children: [
        // Level 1: Open
        _buildOpenLevel(),
        const SizedBox(height: 24),

        // Level 2: Locked
        _buildLockedLevel(
          levelNumber: 2,
          title: 'استخدام الأدوات',
          icon: Icons.build_outlined,
        ),
        const SizedBox(height: 24),

        // Level 3: Locked
        _buildLockedLevel(
          levelNumber: 3,
          title: 'تنفيذ الأوامر',
          icon: Icons.check_circle_outline,
        ),
        const SizedBox(height: 24),

        // Level 4: Locked
        _buildLockedLevel(
          levelNumber: 4,
          title: 'مهارات اجتماعية',
          icon: Icons.people_outline,
        ),
      ],
    );
  }

  // ── Level 1: Open ───────────────────────────────────────────────

  Widget _buildOpenLevel() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _primaryBlue.withValues(alpha: 0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: _primaryBlue.withValues(alpha: 0.12),
            offset: const Offset(0, 8),
            blurRadius: 15,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: Badge + arrow
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // "مفتوح" green badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: _greenBadge,
                  borderRadius: BorderRadius.circular(9999),
                  boxShadow: [
                    BoxShadow(
                      color: _greenBadge.withValues(alpha: 0.1),
                      spreadRadius: 4,
                      blurRadius: 0,
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      offset: const Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: Text(
                  'مفتوح',
                  style: _cairo(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Arrow icon
              Icon(
                Icons.chevron_left,
                size: 12,
                color: _primaryBlue.withValues(alpha: 0.8),
              ),
            ],
          ),

          // Right side: Text + icon
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'المستوى 1',
                    style: _cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: _primaryBlue.withValues(alpha: 0.8),
                    ),
                  ),
                  Text(
                    'التقليد',
                    style: _cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: _darkText,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              // Level icon container
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: _primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _primaryBlue.withValues(alpha: 0.05),
                    width: 1,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.sentiment_satisfied_alt,
                    size: 30,
                    color: _primaryBlue,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Locked Level ────────────────────────────────────────────────

  Widget _buildLockedLevel({
    required int levelNumber,
    required String title,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _lockedBorderColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Lock icon
          Icon(
            Icons.lock_outline,
            size: 20,
            color: _lockedTextColor,
          ),

          // Right side: Text + icon
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'المستوى $levelNumber',
                    style: _cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: _lockedTextColor,
                    ),
                  ),
                  Text(
                    title,
                    style: _cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: _lockedTextColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              // Level icon container
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _lockedBorderColor,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    size: 30,
                    color: _lockedTextColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Decorative illustration ─────────────────────────────────────

  Widget _buildDecorativeIllustration() {
    return Opacity(
      opacity: 0.10,
      child: SizedBox(
        width: 256,
        height: 128,
        child: Center(
          child: Icon(
            Icons.rocket_launch_rounded,
            size: 80,
            color: _primaryBlue,
          ),
        ),
      ),
    );
  }
}
