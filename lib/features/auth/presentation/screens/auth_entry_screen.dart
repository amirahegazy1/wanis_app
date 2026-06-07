import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../levels/presentation/screens/levels_screen.dart';
import '../../../survey/presentation/screens/survey_screen.dart';
import '../../../onboarding/presentation/screens/onboarding_login_screen.dart';
import '../../../../services/firestore_service.dart';

/// Entry screen loaded after authentication.
///
/// Routes the authenticated user conditionally to the [SurveyScreen] or [LevelsScreen].
class AppEntryScreen extends StatefulWidget {
  const AppEntryScreen({super.key});

  @override
  State<AppEntryScreen> createState() => _AppEntryScreenState();
}

class _AppEntryScreenState extends State<AppEntryScreen> {
  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _goToLogin();
      return;
    }

    try {
      final parentUser = await FirestoreService().getParentUser(user.uid);
      if (!mounted) return;

      if (parentUser != null && parentUser.hasCompletedSurvey) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LevelsScreen()),
          (_) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const SurveyScreen()),
          (_) => false,
        );
      }
    } catch (e) {
      debugPrint('[AppEntry] Error loading user: $e');
      // If we get permission-denied or any Firestore error,
      // the auth token is likely invalid — sign out and go to login.
      await FirebaseAuth.instance.signOut();
      if (!mounted) return;
      _goToLogin();
    }
  }

  void _goToLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const OnboardingLoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
