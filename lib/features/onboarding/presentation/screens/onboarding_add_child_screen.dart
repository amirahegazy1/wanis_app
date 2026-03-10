import 'package:flutter/material.dart';

import '../../../parent/presentation/screens/parent_shell_screen.dart';
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
          const Positioned(top: 0, left: 0, right: 0, child: OnboardingStatusBar()),
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 62, 24, 24),
            child: Column(
              children: [
                const Icon(Icons.bubble_chart_rounded, color: OnboardingColors.primaryBlue, size: 30),
                const Text(
                  'ونيس',
                  style: TextStyle(
                    color: OnboardingColors.primaryBlue,
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
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
                const Text(
                  'مرحباً بك في ونيس',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: OnboardingColors.dark,
                    fontSize: 44,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'رفيق طفلك لتعلم المشاعر وتطوير المهارات',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: OnboardingColors.muted, fontSize: 16),
                ),
                const SizedBox(height: 28),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'من هو بطلنا اليوم؟',
                    style: TextStyle(
                      color: OnboardingColors.dark,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const OnboardingInput(hint: 'اكتب اسم الطفل هنا...'),
                const SizedBox(height: 24),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'اختر شخصية:',
                    style: TextStyle(
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
                      MaterialPageRoute(builder: (_) => const ParentShellScreen()),
                      (_) => false,
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
