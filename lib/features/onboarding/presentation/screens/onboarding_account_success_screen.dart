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
          const Positioned(top: 0, left: 0, right: 0, child: OnboardingStatusBar()),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _SuccessCircle(icon: Icons.check_rounded),
                  const SizedBox(height: 24),
                  const Text(
                    'تم بنجاح! 🎉',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: OnboardingColors.dark,
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'تم إنشاء حسابك بنجاح، أنت الآن\nجاهز لبدء الرحلة مع ونيس.',
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
          const OnboardingHomeIndicator(),
        ],
      ),
    );
  }
}

class _SuccessCircle extends StatelessWidget {
  const _SuccessCircle({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        color: const Color(0x1448C774),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Container(
        width: 120,
        height: 120,
        decoration: const BoxDecoration(color: OnboardingColors.success, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 62),
      ),
    );
  }
}
