import 'package:flutter/material.dart';

import 'onboarding_new_password_screen.dart';
import 'onboarding_shared.dart';

/// Figma-faithful OTP verification screen (node `8:185`).
class OnboardingOtpScreen extends StatelessWidget {
  const OnboardingOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingFrame(
      child: Stack(
        children: [
          const Positioned(top: 0, left: 0, right: 0, child: OnboardingStatusBar()),
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 86, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'تحقق من بريدك 📩',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: OnboardingColors.dark,
                    fontSize: 42,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'أرسلنا رمزاً مكوناً من 4 أرقام إلى\nexample@mail.com',
                  textAlign: TextAlign.right,
                  style: TextStyle(color: OnboardingColors.muted, fontSize: 16, height: 1.4),
                ),
                const SizedBox(height: 22),
                const _OtpBoxes(),
                const SizedBox(height: 22),
                const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'إعادة الإرسال في '),
                      TextSpan(
                        text: '00:45',
                        style: TextStyle(color: OnboardingColors.dark, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: OnboardingColors.muted, fontSize: 16),
                ),
                const SizedBox(height: 34),
                OnboardingPrimaryButton(
                  label: 'تحقق من الرمز',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const OnboardingNewPasswordScreen()),
                    );
                  },
                ),
                const SizedBox(height: 40),
                _OtpKeyboardPlaceholder(),
              ],
            ),
          ),
          const OnboardingHomeIndicator(),
        ],
      ),
    );
  }
}

class _OtpBoxes extends StatelessWidget {
  const _OtpBoxes();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(4, (index) {
        return Expanded(
          child: Container(
            margin: EdgeInsetsDirectional.only(start: index == 0 ? 0 : 12),
            height: 75,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: index == 3 ? OnboardingColors.primaryBlue : OnboardingColors.border,
                width: index == 3 ? 2 : 1,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              index == 3 ? '|' : '',
              style: const TextStyle(color: OnboardingColors.primaryBlue, fontSize: 28),
            ),
          ),
        );
      }),
    );
  }
}

class _OtpKeyboardPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFE6E9EE),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: List.generate(4, (row) {
          if (row == 3) {
            return Row(
              children: [
                const Expanded(child: SizedBox()),
                _key('0'),
                _key('⌫'),
              ],
            );
          }
          final start = row * 3 + 1;
          return Row(
            children: [_key('$start'), _key('${start + 1}'), _key('${start + 2}')],
          );
        }),
      ),
    );
  }

  Widget _key(String text) {
    return Expanded(
      child: Container(
        height: 46,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFCDD2DB)),
        ),
        alignment: Alignment.center,
        child: Text(text, style: const TextStyle(fontSize: 28, color: Colors.black87)),
      ),
    );
  }
}
