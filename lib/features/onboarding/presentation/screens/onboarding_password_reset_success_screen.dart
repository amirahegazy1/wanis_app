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
          const Positioned(top: 0, left: 0, right: 0, child: OnboardingStatusBar()),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  _SuccessCircle(),
                  SizedBox(height: 24),
                  Text(
                    'تم تغيير كلمة المرور 🔐',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: OnboardingColors.dark,
                      fontSize: 42,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'رائع! يمكنك الآن استخدام كلمة المرور\nالجديدة لتسجيل الدخول.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: OnboardingColors.muted, fontSize: 16, height: 1.6),
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
          const OnboardingHomeIndicator(),
        ],
      ),
    );
  }
}

class _SuccessCircle extends StatelessWidget {
  const _SuccessCircle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 160,
      decoration: const BoxDecoration(
        color: Color(0x1448C774),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Container(
        width: 120,
        height: 120,
        decoration: const BoxDecoration(color: OnboardingColors.success, shape: BoxShape.circle),
        child: const Icon(Icons.check_rounded, color: Colors.white, size: 62),
      ),
    );
  }
}
