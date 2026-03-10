import 'package:flutter/material.dart';

import 'onboarding_login_screen.dart';
import 'onboarding_shared.dart';

/// Figma-faithful password reset success screen (node `8:238`).
class OnboardingPasswordResetSuccessScreen extends StatelessWidget {
  const OnboardingPasswordResetSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingFrame(
      child: Stack(
        children: [
          
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const OnboardingSuccessCircle(),
                  const SizedBox(height: 24),
                  // Title – Figma: 28px Bold
                  Text(
                    'تم تغيير كلمة المرور 🔐',
                    textAlign: TextAlign.center,
                    style: readexPro(
                      color: OnboardingColors.dark,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'رائع! يمكنك الآن استخدام كلمة المرور\nالجديدة لتسجيل الدخول.',
                    textAlign: TextAlign.center,
                    style: readexPro(
                      color: OnboardingColors.muted,
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 56,
            child: OnboardingPrimaryButton(
              label: 'تسجيل الدخول',
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const OnboardingLoginScreen()),
                  (_) => false,
                );
              },
            ),
          ),
          
        ],
      ),
    );
  }
}
