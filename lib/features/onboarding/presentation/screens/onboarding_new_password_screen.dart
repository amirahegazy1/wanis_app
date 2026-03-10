import 'package:flutter/material.dart';

import 'onboarding_password_reset_success_screen.dart';
import 'onboarding_shared.dart';

/// Figma-faithful new password screen (node `8:209`).
class OnboardingNewPasswordScreen extends StatelessWidget {
  const OnboardingNewPasswordScreen({super.key});

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
                const SizedBox(height: 22),
                const Text(
                  'كلمة مرور جديدة 🔒',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: OnboardingColors.dark,
                    fontSize: 44,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'يجب أن تكون الكلمة الجديدة مختلفة عن السابقة',
                  textAlign: TextAlign.right,
                  style: TextStyle(color: OnboardingColors.muted, fontSize: 16),
                ),
                const SizedBox(height: 26),
                const _Label('كلمة المرور الجديدة'),
                const SizedBox(height: 12),
                const OnboardingInput(
                  hint: '•••••••••',
                  prefix: Icon(Icons.visibility_off_outlined, color: OnboardingColors.muted),
                ),
                const SizedBox(height: 24),
                const _Label('تأكيد كلمة المرور'),
                const SizedBox(height: 12),
                const OnboardingInput(hint: '•••••••••'),
                const SizedBox(height: 14),
                const _Rule(ok: true, text: '8 حروف على الأقل'),
                const SizedBox(height: 8),
                const _Rule(ok: false, text: 'حرف كبير وحرف صغير'),
                const SizedBox(height: 34),
                OnboardingPrimaryButton(
                  label: 'تغيير كلمة المرور',
                  color: OnboardingColors.accentOrange,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const OnboardingPasswordResetSuccessScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const OnboardingHomeIndicator(),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.right,
      style: const TextStyle(
        color: OnboardingColors.dark,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _Rule extends StatelessWidget {
  const _Rule({required this.ok, required this.text});
  final bool ok;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          text,
          style: TextStyle(
            color: ok ? OnboardingColors.dark : OnboardingColors.muted,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 8),
        Icon(
          Icons.circle,
          size: 16,
          color: ok ? const Color(0xFF85E4A9) : const Color(0xFFD5DCE5),
        ),
      ],
    );
  }
}
