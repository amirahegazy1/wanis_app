import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../onboarding/presentation/screens/onboarding_splash_screen.dart';
import '../../../parent/presentation/screens/math_gate_screen.dart';
import '../../../parent/presentation/screens/child_data_screen.dart';
import '../../../parent/presentation/screens/progress_reports_screen.dart';
import '../../../mimicry/presentation/screens/mimicry_sessions_screen.dart';

/// Levels Screen – the main screen of the Wanis application.
///
/// Displayed after account creation + survey, and on every subsequent
/// app launch while the user remains logged in.
///
/// Design reference: Figma nodes `119:130`, `121:178`.
class LevelsScreen extends StatelessWidget {
  const LevelsScreen({super.key});

  // ── Design Tokens ───────────────────────────────────────────────

  static const _primaryBlue = Color(0xFF4A90E2);
  static const _darkBlue = Color(0xFF005DA7);
  static const _bgColor = Color(0xFFF8F9FF);
  static const _headerBorderColor = Color(0xFFF3F4F6);
  static const _subtitleColor = Color(0xFF475569);
  static const _darkText = Color(0xFF0F172A);
  static const _mutedText = Color(0xFF64748B);
  static const _cardBorderColor = Color(0xFFE2E8F0);
  static const _greenBadge = Color(0xFF22C55E);
  static const _infoBg = Color(0xFFF2F3FB);

  // ── Cairo Typography ────────────────────────────────────────────

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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _bgColor,
        body: Stack(
          children: [
            // ── Watermark ─────────────────────────────────────────
            Positioned.fill(
              child: Opacity(
                opacity: 0.04,
                child: Center(
                  child: Icon(
                    Icons.rocket_launch_rounded,
                    size: 340,
                    color: _primaryBlue,
                  ),
                ),
              ),
            ),

            // ── Main Layout ───────────────────────────────────────
            SafeArea(
              child: Column(
                children: [
                  _buildHeader(context),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 28, 20, 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildStatusHeadline(),
                          const SizedBox(height: 32),
                          _buildLevelsRoadmap(context),
                          const SizedBox(height: 32),
                          _buildPostTestCard(),
                          const SizedBox(height: 24),
                          _buildInfoNote(),
                        ],
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
        children: [
          // ── App title (right-aligned in RTL) ───────────────────
          Text(
            'ونيس',
            style: _cairo(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: _primaryBlue,
            ),
          ),
          const Spacer(),

          // ── Parent dashboard button ────────────────────────────
          GestureDetector(
            onTap: () => _openParentPanel(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _primaryBlue.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.person_outline_rounded,
                  size: 22,
                  color: _primaryBlue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Status Headline ─────────────────────────────────────────────

  Widget _buildStatusHeadline() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'مرحباً يا بطل! 🌟',
          style: _cairo(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: _subtitleColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),

        // Current level badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
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
              const Icon(
                Icons.stars_rounded,
                size: 18,
                color: _primaryBlue,
              ),
              const SizedBox(width: 8),
              Text(
                'المستوى الحالي: 1',
                style: _cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _primaryBlue,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Levels Roadmap ──────────────────────────────────────────────

  Widget _buildLevelsRoadmap(BuildContext context) {
    return Column(
      children: [
        _buildOpenLevel(context),
        const SizedBox(height: 16),
        _buildLockedLevel(levelNumber: 2, title: 'استخدام الأدوات', icon: Icons.build_outlined),
        const SizedBox(height: 16),
        _buildLockedLevel(levelNumber: 3, title: 'تنفيذ الأوامر', icon: Icons.check_circle_outline),
        const SizedBox(height: 16),
        _buildLockedLevel(levelNumber: 4, title: 'مهارات اجتماعية', icon: Icons.people_outline),
      ],
    );
  }

  // ── Level 1: Open ───────────────────────────────────────────────

  Widget _buildOpenLevel(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MimicrySessionsScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _primaryBlue.withValues(alpha: 0.25),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: _primaryBlue.withValues(alpha: 0.10),
              offset: const Offset(0, 6),
              blurRadius: 16,
            ),
          ],
        ),
        child: Row(
          children: [
            // ── Level icon ────────────────────────────────────────
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: _primaryBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _primaryBlue.withValues(alpha: 0.08),
                  width: 1,
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.sentiment_satisfied_alt,
                  size: 28,
                  color: _primaryBlue,
                ),
              ),
            ),
            const SizedBox(width: 16),

            // ── Text ──────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'المستوى 1',
                    style: _cairo(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _primaryBlue.withValues(alpha: 0.8),
                    ),
                  ),
                  Text(
                    'التقليد',
                    style: _cairo(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: _darkText,
                    ),
                  ),
                ],
              ),
            ),

            // ── Badge + arrow ─────────────────────────────────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  decoration: BoxDecoration(
                    color: _greenBadge,
                    borderRadius: BorderRadius.circular(9999),
                    boxShadow: [
                      BoxShadow(
                        color: _greenBadge.withValues(alpha: 0.15),
                        spreadRadius: 3,
                        blurRadius: 0,
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
                const SizedBox(height: 10),
                Icon(
                  Icons.chevron_left,
                  size: 18,
                  color: _primaryBlue.withValues(alpha: 0.6),
                ),
              ],
            ),
          ],
        ),
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _infoBg.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _cardBorderColor, width: 1),
      ),
      child: Row(
        children: [
          // ── Level icon ──────────────────────────────────────────
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorderColor, width: 1),
            ),
            child: Center(
              child: Icon(icon, size: 28, color: _mutedText),
            ),
          ),
          const SizedBox(width: 16),

          // ── Text ────────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'المستوى $levelNumber',
                  style: _cairo(fontSize: 14, fontWeight: FontWeight.w600, color: _mutedText),
                ),
                Text(
                  title,
                  style: _cairo(fontSize: 17, fontWeight: FontWeight.w700, color: _mutedText),
                ),
              ],
            ),
          ),

          // ── Lock icon ───────────────────────────────────────────
          const Icon(Icons.lock_outline, size: 20, color: _mutedText),
        ],
      ),
    );
  }

  // ── Post-Test Card (from Figma 119:131) ─────────────────────────

  Widget _buildPostTestCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFC1C7D3).withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Lock illustration ────────────────────────────────────
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: _infoBg,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: Color(0xFFE1E2E9),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.lock_rounded,
                    size: 32,
                    color: _mutedText,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Title ───────────────────────────────────────────────
          Text(
            'الاختبار البعدي',
            style: _cairo(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _darkText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'سيتم فتح الاختبار بعد 21 يوم من الاستخدام',
            style: _cairo(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: _darkText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'المتبقي: 21 يوم',
            style: _cairo(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: _darkBlue,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // ── Progress bar ────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'التقدم الحالي',
                style: _cairo(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _subtitleColor,
                ),
              ),
              Text(
                'أكملت 0 من 21 يوم',
                style: _cairo(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: _darkBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(9999),
            child: const LinearProgressIndicator(
              value: 0.0,
              minHeight: 10,
              backgroundColor: Color(0xFFE1E2E9),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2976C7)),
            ),
          ),
          const SizedBox(height: 16),

          // ── Disabled button ─────────────────────────────────────
          Container(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFE1E2E9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_outline, size: 18, color: _mutedText),
                const SizedBox(width: 8),
                Text(
                  'الاختبار غير متاح حالياً',
                  style: _cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _mutedText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Info Note ───────────────────────────────────────────────────

  Widget _buildInfoNote() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _infoBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: _mutedText,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'يتم فتح الاختبار تلقائياً بعد إكمال مدة الاستخدام المطلوبة',
              style: _cairo(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: _subtitleColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Parent Panel Navigation (via Math Gate) ─────────────────────

  /// Opens the parent panel bottom sheet.
  /// The Math Gate is triggered when tapping a menu item inside the sheet,
  /// NOT when opening the sheet itself (to preserve a smooth UX).
  void _openParentPanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ParentPanelSheet(parentContext: context),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// Parent Panel Bottom Sheet
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _ParentPanelSheet extends StatelessWidget {
  const _ParentPanelSheet({required this.parentContext});

  /// The context from the screen behind the sheet, used for navigation
  /// after the sheet closes.
  final BuildContext parentContext;

  static const _primaryBlue = Color(0xFF4A90E2);
  static const _darkText = Color(0xFF0F172A);
  static const _mutedText = Color(0xFF64748B);
  static const _subtitleColor = Color(0xFF475569);

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
    final user = FirebaseAuth.instance.currentUser;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Drag handle ─────────────────────────────────
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // ── Title ───────────────────────────────────────
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: _primaryBlue.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.person_rounded,
                          size: 26,
                          color: _primaryBlue,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'لوحة الوالدين',
                            style: _cairo(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: _darkText,
                            ),
                          ),
                          if (user?.email != null)
                            Text(
                              user!.email!,
                              style: _cairo(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: _mutedText,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ── Menu items ──────────────────────────────────
                _buildMenuItem(
                  icon: Icons.child_care_rounded,
                  label: 'بيانات الطفل',
                  subtitle: 'عرض وتعديل معلومات الطفل',
                  onTap: () => _navigateWithGate(
                    context,
                    const ChildDataScreen(),
                  ),
                ),
                const SizedBox(height: 12),
                _buildMenuItem(
                  icon: Icons.bar_chart_rounded,
                  label: 'تقارير التقدم',
                  subtitle: 'متابعة تطور الطفل',
                  onTap: () => _navigateWithGate(
                    context,
                    const ProgressReportsScreen(),
                  ),
                ),
                const SizedBox(height: 20),

                // ── Divider ─────────────────────────────────────
                const Divider(color: Color(0xFFE2E8F0), height: 1),
                const SizedBox(height: 16),

                // ── Logout button ───────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: () => _logout(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFEF4444),
                      side: const BorderSide(
                        color: Color(0xFFFECACA),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      backgroundColor: const Color(0xFFFEF2F2),
                    ),
                    icon: const Icon(Icons.logout_rounded, size: 20),
                    label: Text(
                      'تسجيل الخروج',
                      style: _cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFEF4444),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFE2E8F0).withValues(alpha: 0.7),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _primaryBlue.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(icon, size: 22, color: _primaryBlue),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: _cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _darkText,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: _cairo(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: _subtitleColor,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_left,
                size: 20,
                color: _mutedText.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Math Gate → then navigate ─────────────────────────────────

  /// Close the sheet, show the Math Gate, then navigate to [destination]
  /// only if the user passes the gate.
  Future<void> _navigateWithGate(
    BuildContext sheetContext,
    Widget destination,
  ) async {
    Navigator.pop(sheetContext); // close the bottom sheet

    if (!parentContext.mounted) return;

    final passed = await Navigator.push<bool>(
      parentContext,
      MaterialPageRoute(builder: (_) => const MathGateScreen()),
    );

    if (passed != true) return;
    if (!parentContext.mounted) return;

    Navigator.push(
      parentContext,
      MaterialPageRoute(builder: (_) => destination),
    );
  }

  // ── Logout ────────────────────────────────────────────────────

  Future<void> _logout(BuildContext sheetContext) async {
    Navigator.pop(sheetContext); // close the sheet

    if (!parentContext.mounted) return;

    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: parentContext,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'تسجيل الخروج',
            style: _cairo(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: _darkText,
            ),
          ),
          content: Text(
            'هل أنت متأكد من تسجيل الخروج؟',
            style: _cairo(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: _subtitleColor,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(
                'إلغاء',
                style: _cairo(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: _mutedText,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(
                'تسجيل الخروج',
                style: _cairo(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFEF4444),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (shouldLogout != true) return;
    if (!parentContext.mounted) return;

    await FirebaseAuth.instance.signOut();

    if (!parentContext.mounted) return;
    Navigator.pushAndRemoveUntil(
      parentContext,
      MaterialPageRoute(builder: (_) => const OnboardingSplashScreen()),
      (_) => false,
    );
  }
}
