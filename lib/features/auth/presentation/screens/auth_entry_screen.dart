import 'package:flutter/material.dart';

import '../../../home/presentation/screens/home_screen.dart';

/// Entry screen loaded after authentication.
///
/// Routes the authenticated user to the main [HomeScreen].
class AppEntryScreen extends StatelessWidget {
  const AppEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}
