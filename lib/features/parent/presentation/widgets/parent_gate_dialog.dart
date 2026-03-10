import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wanis_app/features/parent/presentation/screens/parent_dashboard_screen.dart';

class ParentGateDialog extends StatefulWidget {
  const ParentGateDialog({super.key});

  @override
  State<ParentGateDialog> createState() => _ParentGateDialogState();
}

class _ParentGateDialogState extends State<ParentGateDialog> {
  String _input = '';
  final String _correctAnswer = '15'; // 3 x 5 = 15
  bool _hasError = false;

  void _onKeyPressed(String key) {
    setState(() {
      _hasError = false;
      if (key == 'delete') {
        if (_input.isNotEmpty) {
          _input = _input.substring(0, _input.length - 1);
        }
      } else {
        if (_input.length < 2) { // Allow max 2 digits for this specific problem
          _input += key;
          _checkAnswer();
        }
      }
    });
  }

  void _checkAnswer() {
    if (_input.length == 2) {
      if (_input == _correctAnswer) {
        Navigator.of(context).pop(); // Close dialog
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ParentDashboardScreen()),
        );
      } else {
        setState(() {
          _hasError = true;
          _input = ''; // Reset on error, or you can leave it and show red text
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 32), // Spacer
                Text(
                  'بوابة الآباء',
                  style: GoogleFonts.readexPro(
                    color: const Color(0xFF2D3748),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF7F9FC),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, color: Color(0xFFA0AEC0), size: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Question and Input
            Text(
              'للتحقق من هويتك، يرجى\nحل المسألة التالية:',
              style: GoogleFonts.readexPro(
                color: const Color(0xFF2D3748),
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _hasError ? const Color(0xFFFFEBEB) : const Color(0xFFF7F9FC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _hasError ? Colors.red : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Text(
                    _input.padRight(2, ' ').substring(0, 2),
                    style: GoogleFonts.plusJakartaSans(
                      color: _hasError ? Colors.red : const Color(0xFF5D9CEC),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 8,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '= 5 × 3',
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF2D3748),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Keypad
            _buildKeypad(),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildKeypadButton('1'),
            const SizedBox(width: 16),
            _buildKeypadButton('2'),
            const SizedBox(width: 16),
            _buildKeypadButton('3'),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildKeypadButton('4'),
            const SizedBox(width: 16),
            _buildKeypadButton('5'),
            const SizedBox(width: 16),
            _buildKeypadButton('6'),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildKeypadButton('7'),
            const SizedBox(width: 16),
            _buildKeypadButton('8'),
            const SizedBox(width: 16),
            _buildKeypadButton('9'),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 56), // spacer for alignment with 0
            const SizedBox(width: 16),
            _buildKeypadButton('0'),
            const SizedBox(width: 16),
            _buildKeypadButton('delete', isIcon: true, icon: Icons.backspace_outlined),
          ],
        ),
      ],
    );
  }

  Widget _buildKeypadButton(String value, {bool isIcon = false, IconData? icon}) {
    return GestureDetector(
      onTap: () => _onKeyPressed(value),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFFF7F9FC),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: isIcon
              ? Icon(icon, color: const Color(0xFF2D3748))
              : Text(
                  value,
                  style: GoogleFonts.readexPro(
                    color: const Color(0xFF2D3748),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
