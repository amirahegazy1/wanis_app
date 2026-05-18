import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Parental gate that requires solving a simple math problem
/// before granting access to parent-only sections.
///
/// Design reference: Figma node `5:806`.
///
/// Usage:
/// ```dart
/// final passed = await Navigator.push<bool>(
///   context,
///   MaterialPageRoute(builder: (_) => const MathGateScreen()),
/// );
/// if (passed == true) { /* navigate to parent area */ }
/// ```
class MathGateScreen extends StatefulWidget {
  const MathGateScreen({super.key});

  @override
  State<MathGateScreen> createState() => _MathGateScreenState();
}

class _MathGateScreenState extends State<MathGateScreen> {
  // ── Design Tokens ─────────────────────────────────────────────

  static const _primaryBlue = Color(0xFF4A90E2);
  static const _darkBlue = Color(0xFF005DA7);
  static const _darkText = Color(0xFF191C21);
  static const _subtitleColor = Color(0xFF475569);
  static const _headerBorder = Color(0xFFF3F4F6);
  static const _selectedBg = Color(0xFFDBEAFE);
  static const _selectedBorder = Color(0xFF4A90E2);
  static const _unselectedBorder = Color(0xFFE2E8F0);

  // ── State ─────────────────────────────────────────────────────

  late int _a;
  late int _b;
  late int _correctAnswer;
  late List<int> _options;
  int? _selectedOption;
  bool _showError = false;

  @override
  void initState() {
    super.initState();
    _generateQuestion();
  }

  void _generateQuestion() {
    final rng = Random();
    _a = rng.nextInt(9) + 1; // 1–9
    _b = rng.nextInt(9) + 1; // 1–9
    _correctAnswer = _a * _b;

    // Generate 3 wrong answers (unique, different from correct)
    final wrongSet = <int>{};
    while (wrongSet.length < 3) {
      final wrong = _correctAnswer + rng.nextInt(21) - 10; // ±10
      if (wrong != _correctAnswer && wrong > 0) {
        wrongSet.add(wrong);
      }
    }

    _options = [_correctAnswer, ...wrongSet]..shuffle(rng);
    _selectedOption = null;
    _showError = false;
  }

  void _onConfirm() {
    if (_selectedOption == null) return;

    if (_selectedOption == _correctAnswer) {
      Navigator.pop(context, true);
    } else {
      setState(() {
        _showError = true;
        _generateQuestion();
      });
    }
  }

  // ── Cairo typography ──────────────────────────────────────────

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
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Column(
                    children: [
                      // ── Lock icon ───────────────────────────────
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: _primaryBlue.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.lock_rounded,
                            size: 36,
                            color: _primaryBlue,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ── Title ───────────────────────────────────
                      Text(
                        'للكبار فقط',
                        style: _cairo(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: _darkText,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'أجب عن السؤال للمتابعة',
                        style: _cairo(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: _subtitleColor,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // ── Question card ───────────────────────────
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _unselectedBorder,
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
                        child: Text(
                          '؟ $_a × $_b',
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.ltr,
                          style: _cairo(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: _primaryBlue,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ── Error message ───────────────────────────
                      if (_showError)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            'إجابة خاطئة، حاول مرة أخرى',
                            style: _cairo(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFEF4444),
                            ),
                          ),
                        ),

                      // ── Options grid ────────────────────────────
                      GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 2.2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: _options.map((opt) => _buildOption(opt)).toList(),
                      ),
                      const SizedBox(height: 32),

                      // ── Confirm button ──────────────────────────
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: FilledButton(
                          onPressed: _selectedOption != null ? _onConfirm : null,
                          style: FilledButton.styleFrom(
                            backgroundColor: _primaryBlue,
                            disabledBackgroundColor: _primaryBlue.withValues(alpha: 0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.verified_rounded, size: 20, color: Colors.white),
                              const SizedBox(width: 8),
                              Text(
                                'تأكيد',
                                style: _cairo(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ── Disclaimer ──────────────────────────────
                      Text(
                        'هذه الخطوة تضمن أن الأطفال لا يقومون بتغيير\nالإعدادات الحساسة',
                        textAlign: TextAlign.center,
                        style: _cairo(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: _subtitleColor,
                        ),
                      ),
                    ],
                  ),
                ),
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
        border: Border(
          bottom: BorderSide(color: _headerBorder, width: 1),
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
            onTap: () => Navigator.pop(context, false),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_forward_rounded,
                  size: 20,
                  color: _subtitleColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Option Tile ───────────────────────────────────────────────

  Widget _buildOption(int value) {
    final isSelected = _selectedOption == value;
    return GestureDetector(
      onTap: () => setState(() {
        _selectedOption = value;
        _showError = false;
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? _selectedBg : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? _selectedBorder : _unselectedBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                '$value',
                style: _cairo(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? _darkBlue : _darkText,
                ),
              ),
            ),
            if (isSelected)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: _primaryBlue,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.check, size: 14, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
