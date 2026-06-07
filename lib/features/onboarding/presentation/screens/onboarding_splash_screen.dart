import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../auth/presentation/screens/auth_entry_screen.dart';
import 'onboarding_login_screen.dart';
import 'onboarding_shared.dart';

/// Splash screen (Figma node `2034:138`).
///
/// Light off-white background with the Wanis logo (white background variant),
/// and tagline "رفيق طفلك الذكي" in blue. Auto-navigates after 2.5 s.
class OnboardingSplashScreen extends StatefulWidget {
  const OnboardingSplashScreen({super.key});

  @override
  State<OnboardingSplashScreen> createState() => _OnboardingSplashScreenState();
}

class _OnboardingSplashScreenState extends State<OnboardingSplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animCtrl;
  late final Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();

    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeIn = CurvedAnimation(parent: _animCtrl, curve: Curves.easeIn);
    _animCtrl.forward();

    Timer(const Duration(milliseconds: 2500), () {
      if (!mounted) return;
      
      final currentUser = FirebaseAuth.instance.currentUser;
      final Widget nextScreen = currentUser != null 
          ? const AppEntryScreen() 
          : const OnboardingLoginScreen();

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (_, __, ___) => nextScreen,
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
        ),
      );
    });
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFFF5F5F5),
        child: Stack(
          children: [
            // Top-left decorative circle (partially offscreen) – Figma node 2034:140
            Positioned(
              top: -150,
              left: -150,
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
            ),
            // Bottom-right decorative circle (partially offscreen) – Figma node 2034:141
            Positioned(
              bottom: -200,
              right: -200,
              child: Container(
                width: 450,
                height: 450,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
            ),
            // Main content – logo + tagline
            Center(
              child: FadeTransition(
                opacity: _fadeIn,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Wanis logo with white background – Figma node 2034:147
                    Image.asset(
                      'assets/images/logo_white_bg.png',
                      width: 287,
                      height: 287,
                    ),
                    const SizedBox(height: 16),
                    // Tagline in blue – Figma node 2034:144
                    Text(
                      'رفيق طفلك الذكي',
                      style: readexPro(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF4A90E2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
