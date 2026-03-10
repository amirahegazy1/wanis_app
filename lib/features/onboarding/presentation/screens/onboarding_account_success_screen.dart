import 'package:flutter/material.dart';

import '../../../auth/presentation/screens/auth_entry_screen.dart';
import 'onboarding_shared.dart';

/// Figma-faithful account creation success screen (node `8:165`).
class OnboardingAccountSuccessScreen extends StatelessWidget {
  const OnboardingAccountSuccessScreen({super.key});

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
                  // Title – Figma: 32px Bold
                  Text(
                    'تم بنجاح! 🎉',
                    textAlign: TextAlign.center,
                    style: readexPro(
                      color: OnboardingColors.dark,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'تم إنشاء حسابك بنجاح، أنت الآن\nجاهز لبدء الرحلة مع ونيس.',
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
              label: 'المتابعة',
              color: OnboardingColors.success,
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const AppEntryScreen()),
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
