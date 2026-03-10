import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import 'features/onboarding/presentation/screens/onboarding_splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const WanisApp());
}

class WanisApp extends StatelessWidget {
  const WanisApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTextTheme = GoogleFonts.readexProTextTheme(
      Theme.of(context).textTheme,
    );

    return MaterialApp(
      title: 'ونيس',
      debugShowCheckedModeBanner: false,

      // ── Arabic / RTL configuration ──
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5D9CEC),
        ),
        textTheme: baseTextTheme,
        fontFamily: GoogleFonts.readexPro().fontFamily,
        useMaterial3: true,
      ),
      home: const OnboardingSplashScreen(),
    );
  }
}
