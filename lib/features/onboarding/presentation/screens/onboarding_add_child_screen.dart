import 'package:flutter/material.dart';

import 'onboarding_account_success_screen.dart';
import 'onboarding_shared.dart';

/// Figma-faithful add-child onboarding screen (node `4:59`).
class OnboardingAddChildScreen extends StatefulWidget {
  const OnboardingAddChildScreen({super.key});

  @override
  State<OnboardingAddChildScreen> createState() => _OnboardingAddChildScreenState();
}

class _OnboardingAddChildScreenState extends State<OnboardingAddChildScreen> {
  int _selectedAvatar = 1;

  @override
  Widget build(BuildContext context) {
    return OnboardingFrame(
      child: Stack(
        children: [
          
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 62, 24, 24),
            child: Column(
              children: [
                // Header – Figma: small icons + "ونيس" 20px Bold
                const Icon(Icons.bubble_chart_rounded, color: OnboardingColors.primaryBlue, size: 30),
                Text(
                  'ونيس',
                  style: readexPro(
                    color: OnboardingColors.primaryBlue,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
                // Hero illustration placeholder
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9F3FF),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFD8E8FC), width: 6),
                  ),
                  alignment: Alignment.center,
                  child: const Text('🙂', style: TextStyle(fontSize: 74)),
                ),
                const SizedBox(height: 20),
                // Welcome text – Figma: 28px Bold
                Text(
                  'مرحباً بك في ونيس',
                  textAlign: TextAlign.center,
                  style: readexPro(
                    color: OnboardingColors.dark,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'رفيق طفلك لتعلم المشاعر وتطوير المهارات',
                  textAlign: TextAlign.center,
                  style: readexPro(color: OnboardingColors.muted, fontSize: 16),
                ),
                const SizedBox(height: 28),
                // "من هو بطلنا اليوم؟" – Figma: 16px Bold
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'من هو بطلنا اليوم؟',
                    style: readexPro(
                      color: OnboardingColors.dark,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const OnboardingInput(hint: 'اكتب اسم الطفل هنا...'),
                const SizedBox(height: 24),
                // "اختر شخصية:" – Figma: 16px Bold
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'اختر شخصية:',
                    style: readexPro(
                      color: OnboardingColors.dark,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _AvatarOption(
                      emoji: '👩‍🦱',
                      color: const Color(0xFFFED7D7),
                      selected: _selectedAvatar == 0,
                      onTap: () => setState(() => _selectedAvatar = 0),
                    ),
                    const SizedBox(width: 16),
                    _AvatarOption(
                      emoji: '👦',
                      color: const Color(0xFFBEE3F8),
                      selected: _selectedAvatar == 1,
                      onTap: () => setState(() => _selectedAvatar = 1),
                    ),
                    const SizedBox(width: 16),
                    _AvatarOption(
                      emoji: '🦁',
                      color: const Color(0xFFC6F6D5),
                      selected: _selectedAvatar == 2,
                      onTap: () => setState(() => _selectedAvatar = 2),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                OnboardingPrimaryButton(
                  label: 'ابدأ الرحلة 🚀',
                  color: OnboardingColors.accentOrange,
                  onTap: () {
                    // TODO: Save child name & avatar via BLoC/repository
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const OnboardingAccountSuccessScreen()),
                      (_) => false,
                    );
                  },
                ),
              ],
            ),
          ),
          
        ],
      ),
    );
  }
}

class _AvatarOption extends StatelessWidget {
  const _AvatarOption({
    required this.emoji,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String emoji;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: selected ? 68 : 60,
            height: selected ? 68 : 60,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: selected ? Border.all(color: OnboardingColors.primaryBlue, width: 3) : null,
            ),
            alignment: Alignment.center,
            child: Text(emoji, style: const TextStyle(fontSize: 24)),
          ),
          if (selected)
            const Positioned(
              right: -2,
              bottom: -2,
              child: CircleAvatar(
                radius: 10,
                backgroundColor: OnboardingColors.success,
                child: Icon(Icons.check_rounded, color: Colors.white, size: 14),
              ),
            ),
        ],
      ),
    );
  }
}
