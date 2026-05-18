import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/mimicry_level.dart';
import '../../services/progress_service.dart';
import 'mimicry_activity_screen.dart';

/// Lists all 8 mimicry sessions for Level 1 (التقليد).
///
/// Each session card shows the activity emoji, title, instruction,
/// and the player's best score / unlocked status.
///
/// Design reference: Figma node `111:1811`.
class MimicrySessionsScreen extends StatefulWidget {
  const MimicrySessionsScreen({super.key});

  @override
  State<MimicrySessionsScreen> createState() => _MimicrySessionsScreenState();
}

class _MimicrySessionsScreenState extends State<MimicrySessionsScreen> {
  // ── Design Tokens ───────────────────────────────────────────────
  static const _primaryBlue = Color(0xFF4A90E2);
  static const _darkBlue = Color(0xFF005DA7);
  static const _bgColor = Color(0xFFF8F9FF);
  static const _darkText = Color(0xFF0F172A);
  static const _subtitleColor = Color(0xFF475569);
  static const _mutedText = Color(0xFF64748B);
  static const _greenBadge = Color(0xFF22C55E);
  static const _headerBorder = Color(0xFFF3F4F6);

  Map<int, double> _progress = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final progress = await MimicryProgressService.getProgress();
    if (mounted) {
      setState(() {
        _progress = progress;
        _loading = false;
      });
    }
  }

  bool _isUnlocked(MimicryLevel level) {
    if (level.id == 1) return true;
    final prevScore = _progress[level.id - 1] ?? 0;
    return prevScore >= level.requiredScore;
  }

  static TextStyle _cairo({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w400,
    Color color = Colors.black,
  }) {
    return GoogleFonts.cairo(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

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
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildSessionsList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────

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
            'ونيس',
            style: _cairo(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: _primaryBlue,
            ),
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

  // ── Sessions List ─────────────────────────────────────────────

  Widget _buildSessionsList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
      itemCount: MimicryLevels.all.length + 1, // +1 for the header card
      itemBuilder: (context, index) {
        if (index == 0) return _buildOverviewCard();

        final level = MimicryLevels.all[index - 1];
        final unlocked = _isUnlocked(level);
        final score = _progress[level.id];
        final completed = (score ?? 0) >= level.requiredScore;

        return _buildSessionCard(
          level: level,
          unlocked: unlocked,
          completed: completed,
          score: score,
        );
      },
    );
  }

  // ── Overview Card ─────────────────────────────────────────────

  Widget _buildOverviewCard() {
    final completedCount = MimicryLevels.all.where((l) {
      return (_progress[l.id] ?? 0) >= l.requiredScore;
    }).length;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [_primaryBlue, _darkBlue],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _primaryBlue.withValues(alpha: 0.3),
            offset: const Offset(0, 8),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text('🪞', style: TextStyle(fontSize: 28)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'المستوى 1: التقليد',
                      style: _cairo(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                    Text(
                      'شاهد الحركة وقلّدها!',
                      style: _cairo(fontSize: 14, color: Colors.white.withValues(alpha: 0.8)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(9999),
            child: LinearProgressIndicator(
              value: completedCount / MimicryLevels.all.length,
              minHeight: 8,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFC107)),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'أكملت $completedCount من ${MimicryLevels.all.length} أنشطة',
            style: _cairo(fontSize: 13, color: Colors.white.withValues(alpha: 0.8)),
          ),
        ],
      ),
    );
  }

  // ── Session Card ──────────────────────────────────────────────

  Widget _buildSessionCard({
    required MimicryLevel level,
    required bool unlocked,
    required bool completed,
    double? score,
  }) {
    return GestureDetector(
      onTap: unlocked
          ? () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MimicryActivityScreen(level: level),
                ),
              );
              _loadProgress();
            }
          : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: unlocked ? Colors.white : const Color(0xFFF2F3FB).withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: completed
                ? _greenBadge.withValues(alpha: 0.4)
                : unlocked
                    ? _primaryBlue.withValues(alpha: 0.15)
                    : const Color(0xFFE2E8F0),
            width: completed ? 2 : 1,
          ),
          boxShadow: unlocked
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    offset: const Offset(0, 4),
                    blurRadius: 12,
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            // ── Emoji icon ────────────────────────────────────
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: unlocked
                        ? _primaryBlue.withValues(alpha: 0.08)
                        : const Color(0xFFF2F3FB),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      unlocked ? level.emoji : '🔒',
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                if (completed)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: _greenBadge,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),

            // ── Text column ─────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'النشاط ${level.id}',
                    style: _cairo(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: unlocked ? _subtitleColor : _mutedText,
                    ),
                  ),
                  Text(
                    level.title,
                    style: _cairo(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: unlocked ? _darkText : _mutedText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    unlocked ? level.instruction : 'أكمل النشاط السابق أولاً',
                    style: _cairo(fontSize: 13, color: _mutedText),
                  ),
                  if (score != null) ...[
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(9999),
                      child: LinearProgressIndicator(
                        value: score / 100,
                        minHeight: 6,
                        backgroundColor: const Color(0xFFE2E8F0),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          score >= level.requiredScore
                              ? _greenBadge
                              : const Color(0xFFF59E0B),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'أفضل نتيجة: ${score.toStringAsFixed(0)}%',
                      style: _cairo(fontSize: 11, color: _mutedText),
                    ),
                  ],
                ],
              ),
            ),

            // ── Arrow / lock ────────────────────────────────
            Icon(
              unlocked ? Icons.chevron_left : Icons.lock_outline,
              color: unlocked
                  ? _primaryBlue.withValues(alpha: 0.6)
                  : _mutedText,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
