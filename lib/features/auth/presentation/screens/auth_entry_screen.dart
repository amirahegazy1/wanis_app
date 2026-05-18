import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../home/presentation/screens/main_navigation_screen.dart';
import '../../../survey/presentation/screens/survey_screen.dart';
import '../../../../services/firestore_service.dart';

/// Entry screen loaded after authentication.
///
/// Routes the authenticated user conditionally to the [SurveyScreen] or [MainNavigationScreen].
class AppEntryScreen extends StatelessWidget {
  const AppEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text('Not authenticated')));
    }

    return FutureBuilder(
      future: FirestoreService().getParentUser(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        final parentUser = snapshot.data;
        
        if (parentUser != null && parentUser.hasCompletedSurvey) {
          return const MainNavigationScreen();
        }

        return const SurveyScreen();
      },
    );
  }
}
