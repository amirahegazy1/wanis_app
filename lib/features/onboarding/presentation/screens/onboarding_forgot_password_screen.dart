import 'package:flutter/material.dart';

import 'onboarding_otp_screen.dart';
import 'onboarding_shared.dart';

/// Figma-faithful forgot password screen (node `8:141`).
class OnboardingForgotPasswordScreen extends StatelessWidget {
  const OnboardingForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingFrame(
      child: Stack(
        children: [
          const Positioned(top: 0, left: 0, right: 0, child: OnboardingStatusBar()),
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 86, 24, 24),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: 81,
                  height: 81,
                  decoration: const BoxDecoration(color: Color(0xFFE8F4FF), shape: BoxShape.circle),
                  child: const Icon(Icons.lock_rounded, color: OnboardingColors.primaryBlue),
                ),
                const SizedBox(height: 14),
                const Text(
                  'نسيت كلمة المرور؟',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: OnboardingColors.dark,
                    fontSize: 46,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'لا تقلق! أدخل بريدك الإلكتروني بالأسفل\nوسنرسل لك تعليمات الاستعادة.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: OnboardingColors.muted, fontSize: 16, height: 1.6),
                ),
                const SizedBox(height: 26),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'البريد الإلكتروني',
                    style: TextStyle(
                      color: OnboardingColors.dark,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const OnboardingInput(hint: 'example@mail.com'),
                const SizedBox(height: 34),
                OnboardingPrimaryButton(
                  label: 'إرسال الرابط',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const OnboardingOtpScreen()),
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
