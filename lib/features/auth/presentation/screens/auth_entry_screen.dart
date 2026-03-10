import 'package:flutter/material.dart';

import '../../../home/presentation/screens/main_navigation_screen.dart';

/// Entry screen loaded after authentication.
///
/// Routes the authenticated user to the main [MainNavigationScreen].
class AppEntryScreen extends StatelessWidget {
  const AppEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainNavigationScreen();
  }
}
