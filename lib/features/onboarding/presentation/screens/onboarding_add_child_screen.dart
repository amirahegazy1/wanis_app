import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../services/firestore_service.dart';
import '../../../../models/parent_user.dart';
import '../../../../models/child_profile.dart';
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
  String _selectedAgeCategory = '3-5 سنوات';
  final _childNameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _childNameController.dispose();
    super.dispose();
  }

  Future<void> _startJourney() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);

    try {
      final firestoreService = FirestoreService();
      final childName = _childNameController.text.trim();

      // Create the ParentUser document in Firestore so that
      // AppEntryScreen can later find it and check hasCompletedSurvey.
      final parentUser = ParentUser(
        id: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? '',
      );
      await firestoreService.createParentUser(parentUser);

      // Create the ChildProfile with name & avatar from onboarding.
      final childProfile = ChildProfile(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: childName.isNotEmpty ? childName : 'طفلي',
        ageCategory: _selectedAgeCategory,
        avatarUrl: '$_selectedAvatar',
      );
      await firestoreService.addChildProfile(user.uid, childProfile);
    } catch (e) {
      debugPrint('Error creating parent user / child profile: $e');
    }

    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const OnboardingAccountSuccessScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingFrame(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
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
                OnboardingInput(
                  hint: 'اكتب اسم الطفل هنا...',
                  controller: _childNameController,
                ),
                const SizedBox(height: 24),
                // "الفئة العمرية:"
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'الفئة العمرية:',
                    style: readexPro(
                      color: OnboardingColors.dark,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _AgeCategoryOption(
                        label: '3-5 سنوات',
                        selected: _selectedAgeCategory == '3-5 سنوات',
                        onTap: () => setState(() => _selectedAgeCategory = '3-5 سنوات'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _AgeCategoryOption(
                        label: '6-8 سنوات',
                        selected: _selectedAgeCategory == '6-8 سنوات',
                        onTap: () => setState(() => _selectedAgeCategory = '6-8 سنوات'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _AgeCategoryOption(
                        label: '9-12 سنة',
                        selected: _selectedAgeCategory == '9-12 سنة',
                        onTap: () => setState(() => _selectedAgeCategory = '9-12 سنة'),
                      ),
                    ),
                  ],
                ),
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
                  isLoading: _isLoading,
                  onTap: _startJourney,
                ),
          ],
        ),
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

class _AgeCategoryOption extends StatelessWidget {
  const _AgeCategoryOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? OnboardingColors.primaryBlue.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? OnboardingColors.primaryBlue : const Color(0xFFE2E8F0),
            width: selected ? 2 : 1,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: readexPro(
            color: selected ? OnboardingColors.primaryBlue : OnboardingColors.muted,
            fontSize: 14,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
