import 'package:flutter/material.dart';

import 'onboarding_password_reset_success_screen.dart';
import 'onboarding_shared.dart';

/// Figma-faithful new password screen (node `8:209`).
class OnboardingNewPasswordScreen extends StatelessWidget {
  const OnboardingNewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingFrame(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Back button
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_forward_rounded, size: 20),
              ),
            ),
                const SizedBox(height: 22),
                // Title – Figma: 28px Bold
                Text(
                  'كلمة مرور جديدة 🔒',
                  textAlign: TextAlign.right,
                  style: readexPro(
                    color: OnboardingColors.dark,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'يجب أن تكون الكلمة الجديدة مختلفة عن السابقة',
                  textAlign: TextAlign.right,
                  style: readexPro(color: OnboardingColors.muted, fontSize: 16),
                ),
                const SizedBox(height: 26),
                const OnboardingLabel('كلمة المرور الجديدة'),
                const SizedBox(height: 12),
                OnboardingInput(
                  hint: '•••••••••',
                  obscureText: true,
                  suffix: const Icon(Icons.visibility_off_outlined,
                      color: OnboardingColors.muted, size: 22),
                ),
                const SizedBox(height: 24),
                const OnboardingLabel('تأكيد كلمة المرور'),
                const SizedBox(height: 12),
                const OnboardingInput(hint: '•••••••••', obscureText: true),
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
          style: readexPro(
            color: ok ? OnboardingColors.dark : OnboardingColors.muted,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ok ? const Color(0xFF85E4A9) : const Color(0xFFD5DCE5),
          ),
        ),
      ],
    );
  }
}
