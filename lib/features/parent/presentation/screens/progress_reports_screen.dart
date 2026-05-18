import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../models/child_profile.dart';
import '../../../../services/firestore_service.dart';

/// Progress Reports screen — shows a visual summary of the child's
/// survey results across skill categories.
///
/// Design reference: Figma node `60:103` (child progress dashboard).
class ProgressReportsScreen extends StatefulWidget {
  const ProgressReportsScreen({super.key});

  @override
  State<ProgressReportsScreen> createState() => _ProgressReportsScreenState();
}

class _ProgressReportsScreenState extends State<ProgressReportsScreen> {
  // ── Design Tokens ─────────────────────────────────────────────

  static const _primaryBlue = Color(0xFF4A90E2);
  static const _darkText = Color(0xFF191C21);
  static const _subtitleColor = Color(0xFF475569);
  static const _mutedText = Color(0xFF64748B);
  static const _headerBorder = Color(0xFFF3F4F6);
  static const _bgColor = Color(0xFFF8F9FF);

  final _firestoreService = FirestoreService();
  ChildProfile? _child;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final children = await _firestoreService.getChildProfiles(user.uid);
      if (mounted) {
        setState(() {
          _child = children.isNotEmpty ? children.first : null;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

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

  // ── Skill categories with labels and colors ───────────────────

  static const _skills = <_SkillDef>[
    _SkillDef(
      keys: ['q1', 'q2'],
      label: 'الانتباه',
      icon: Icons.visibility_outlined,
      bgColor: Color(0xFFF0F7FF),
      borderColor: Color(0xFFDBEAFE),
      iconBgColor: Color(0xFFDBEAFE),
      iconColor: Color(0xFF3B82F6),
    ),
    _SkillDef(
      keys: ['q3', 'q6'],
      label: 'التقليد',
      icon: Icons.people_alt_outlined,
      bgColor: Color(0xFFF0FDF4),
      borderColor: Color(0xFFDCFCE7),
      iconBgColor: Color(0xFFDCFCE7),
      iconColor: Color(0xFF22C55E),
    ),
    _SkillDef(
      keys: ['q4', 'q5', 'q7', 'q8'],
      label: 'التواصل',
      icon: Icons.chat_bubble_outline_rounded,
      bgColor: Color(0xFFFAF5FF),
      borderColor: Color(0xFFF3E8FF),
      iconBgColor: Color(0xFFF3E8FF),
      iconColor: Color(0xFFA855F7),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _bgColor,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: _headerBorder, width: 1)),
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
          Text(
            'تقارير التقدم',
            style: _cairo(fontSize: 20, fontWeight: FontWeight.w700, color: _primaryBlue),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: const Center(
                child: Icon(Icons.arrow_forward_rounded, size: 20, color: _subtitleColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: _mutedText),
            const SizedBox(height: 12),
            Text('حدث خطأ في تحميل البيانات', style: _cairo(color: _mutedText)),
          ],
        ),
      );
    }

    if (_child == null || _child!.surveyResponses.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bar_chart_rounded, size: 64, color: _mutedText.withValues(alpha: 0.5)),
            const SizedBox(height: 12),
            Text(
              'لا توجد تقارير بعد',
              style: _cairo(color: _mutedText, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              'ستظهر التقارير بعد إكمال التقييم الأول',
              style: _cairo(color: _mutedText, fontSize: 14),
            ),
          ],
        ),
      );
    }

    final responses = _child!.surveyResponses;

    // Calculate overall score (max possible = responses.length * 3)
    final totalScore = responses.values.fold(0, (a, b) => a + b);
    final maxScore = responses.length * 3;
    final overallPercent = maxScore > 0 ? (totalScore / maxScore * 100).round() : 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Overall Badge ────────────────────────────────────
          _buildOverallBadge(overallPercent),
          const SizedBox(height: 24),

          // ── Skill Cards ─────────────────────────────────────
          ..._skills.map((skill) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildSkillCard(skill, responses),
              )),

          const SizedBox(height: 8),

          // ── Info Note ───────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F3FB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline_rounded, size: 18, color: _mutedText),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'هذا التقرير يعتمد على إجابات التقييم الأولي. سيتم تحديثه بعد إكمال الاختبار البعدي.',
                    style: _cairo(fontSize: 14, fontWeight: FontWeight.w400, color: _subtitleColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallBadge(int percent) {
    final Color badgeColor;
    final String label;

    if (percent >= 75) {
      badgeColor = const Color(0xFF22C55E);
      label = 'أداء ممتاز ✨';
    } else if (percent >= 50) {
      badgeColor = const Color(0xFF3B82F6);
      label = 'أداء جيد 👍';
    } else if (percent >= 25) {
      badgeColor = const Color(0xFFF59E0B);
      label = 'يحتاج تحسين';
    } else {
      badgeColor = const Color(0xFFEF4444);
      label = 'يحتاج دعم إضافي';
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: badgeColor.withValues(alpha: 0.25), width: 2),
        boxShadow: [
          BoxShadow(
            color: badgeColor.withValues(alpha: 0.08),
            offset: const Offset(0, 6),
            blurRadius: 16,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(9999),
              border: Border.all(color: badgeColor.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.trending_up_rounded, size: 18, color: badgeColor),
                const SizedBox(width: 8),
                Text(
                  'تحسن إجمالي: $percent%',
                  style: _cairo(fontSize: 18, fontWeight: FontWeight.w700, color: badgeColor),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: _cairo(fontSize: 16, fontWeight: FontWeight.w600, color: _subtitleColor),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillCard(_SkillDef skill, Map<String, int> responses) {
    // Average the relevant survey keys
    int total = 0;
    int count = 0;
    for (final key in skill.keys) {
      final val = responses[key];
      if (val != null) {
        total += val;
        count++;
      }
    }
    final percent = count > 0 ? (total / (count * 3) * 100).round() : 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: skill.bgColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: skill.borderColor, width: 1),
      ),
      child: Row(
        children: [
          // ── Icon ────────────────────────────────────────────
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: skill.iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(skill.icon, size: 22, color: skill.iconColor),
            ),
          ),
          const SizedBox(width: 16),

          // ── Text + progress ─────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      skill.label,
                      style: _cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _darkText,
                      ),
                    ),
                    Text(
                      '$percent%',
                      style: _cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: _darkText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(9999),
                  child: LinearProgressIndicator(
                    value: percent / 100,
                    minHeight: 8,
                    backgroundColor: const Color(0xFFE1E2E9),
                    valueColor: AlwaysStoppedAnimation<Color>(skill.iconColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Internal data class for skill category definition.
class _SkillDef {
  final List<String> keys;
  final String label;
  final IconData icon;
  final Color bgColor;
  final Color borderColor;
  final Color iconBgColor;
  final Color iconColor;

  const _SkillDef({
    required this.keys,
    required this.label,
    required this.icon,
    required this.bgColor,
    required this.borderColor,
    required this.iconBgColor,
    required this.iconColor,
  });
}
