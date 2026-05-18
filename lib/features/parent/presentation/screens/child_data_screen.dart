import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../models/child_profile.dart';
import '../../../../services/firestore_service.dart';

/// Displays the child's profile data fetched from Firestore.
///
/// Parents can view the child's name, age, avatar, and survey responses.
class ChildDataScreen extends StatefulWidget {
  const ChildDataScreen({super.key});

  @override
  State<ChildDataScreen> createState() => _ChildDataScreenState();
}

class _ChildDataScreenState extends State<ChildDataScreen> {
  // ── Design Tokens ─────────────────────────────────────────────

  static const _primaryBlue = Color(0xFF4A90E2);
  static const _darkBlue = Color(0xFF005DA7);
  static const _darkText = Color(0xFF191C21);
  static const _subtitleColor = Color(0xFF475569);
  static const _mutedText = Color(0xFF64748B);
  static const _headerBorder = Color(0xFFF3F4F6);
  static const _bgColor = Color(0xFFF8F9FF);
  static const _infoBg = Color(0xFFF2F3FB);

  final _firestoreService = FirestoreService();
  List<ChildProfile>? _children;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadChildren();
  }

  Future<void> _loadChildren() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final children = await _firestoreService.getChildProfiles(user.uid);
      if (mounted) {
        setState(() {
          _children = children;
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

  /// Map of survey question keys to Arabic labels.
  static const _surveyLabels = <String, String>{
    'q1': 'التواصل البصري',
    'q2': 'الاستجابة للاسم',
    'q3': 'التقليد',
    'q4': 'فهم التعليمات',
    'q5': 'التعبير عن المشاعر',
    'q6': 'اللعب التخيلي',
    'q7': 'التفاعل مع الأقران',
    'q8': 'استخدام الإشارة',
    'q9': 'الروتين والتغيير',
    'q10': 'الحساسية الحسية',
    'q11': 'المهارات الحركية',
    'q12': 'الاهتمامات المتكررة',
  };

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
            'بيانات الطفل',
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
            Icon(Icons.error_outline, size: 48, color: _mutedText),
            const SizedBox(height: 12),
            Text('حدث خطأ في تحميل البيانات', style: _cairo(color: _mutedText)),
          ],
        ),
      );
    }

    if (_children == null || _children!.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.child_care_rounded, size: 64, color: _mutedText.withValues(alpha: 0.5)),
            const SizedBox(height: 12),
            Text('لا توجد بيانات للطفل بعد', style: _cairo(color: _mutedText, fontSize: 16)),
          ],
        ),
      );
    }

    final child = _children!.first;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Profile Card ──────────────────────────────────
          _buildProfileCard(child),
          const SizedBox(height: 24),

          // ── Survey Responses ──────────────────────────────
          if (child.surveyResponses.isNotEmpty) ...[
            Text(
              'نتائج التقييم الأولي',
              style: _cairo(fontSize: 18, fontWeight: FontWeight.w700, color: _darkText),
            ),
            const SizedBox(height: 16),
            ...child.surveyResponses.entries.map(
              (entry) => _buildSurveyRow(entry.key, entry.value),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProfileCard(ChildProfile child) {
    // Map avatar index to emoji
    const avatarEmojis = ['👩‍🦱', '👦', '🦁'];
    final avatarIndex = int.tryParse(child.avatarUrl) ?? 1;
    final emoji = avatarEmojis[avatarIndex.clamp(0, 2)];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _primaryBlue.withValues(alpha: 0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: const Color(0xFFE9F3FF),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFD8E8FC), width: 4),
            ),
            alignment: Alignment.center,
            child: Text(emoji, style: const TextStyle(fontSize: 42)),
          ),
          const SizedBox(height: 16),

          // Name
          Text(
            child.name.isNotEmpty ? child.name : 'طفل ونيس',
            style: _cairo(fontSize: 22, fontWeight: FontWeight.w700, color: _darkText),
          ),
          const SizedBox(height: 16),

          // Info row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildInfoChip(Icons.cake_outlined, child.ageCategory),
              const SizedBox(width: 12),
              _buildInfoChip(
                Icons.assignment_outlined,
                '${child.surveyResponses.length} تقييم',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _infoBg,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: _darkBlue),
          const SizedBox(width: 6),
          Text(label, style: _cairo(fontSize: 13, fontWeight: FontWeight.w600, color: _darkBlue)),
        ],
      ),
    );
  }

  Widget _buildSurveyRow(String key, int value) {
    final label = _surveyLabels[key] ?? key;
    // Survey answers: 0 = أبداً, 1 = أحياناً, 2 = غالباً, 3 = دائماً
    const answerLabels = ['أبداً', 'أحياناً', 'غالباً', 'دائماً'];
    final answerText = value >= 0 && value < answerLabels.length
        ? answerLabels[value]
        : '$value';

    // Color by value
    final color = switch (value) {
      0 => const Color(0xFFEF4444),
      1 => const Color(0xFFF59E0B),
      2 => const Color(0xFF3B82F6),
      _ => const Color(0xFF22C55E),
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: _cairo(fontSize: 14, fontWeight: FontWeight.w600, color: _darkText),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(9999),
            ),
            child: Text(
              answerText,
              style: _cairo(fontSize: 13, fontWeight: FontWeight.w700, color: color),
            ),
          ),
        ],
      ),
    );
  }
}
