import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../services/auth_service.dart';
import '../../../auth/presentation/screens/auth_entry_screen.dart';
import 'onboarding_forgot_password_screen.dart';
import 'onboarding_shared.dart';
import 'onboarding_sign_up_screen.dart';

/// Login screen (Figma node `8:54`) wired to Firebase Auth.
class OnboardingLoginScreen extends StatefulWidget {
  const OnboardingLoginScreen({super.key});

  @override
  State<OnboardingLoginScreen> createState() => _OnboardingLoginScreenState();
}

class _OnboardingLoginScreenState extends State<OnboardingLoginScreen> {
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ── Auth actions ────────────────────────────────────────────────

  Future<void> _signInWithEmail() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'يرجى إدخال البريد الإلكتروني وكلمة المرور');
      return;
    }
    await _runAuth(() => _authService.signInWithEmail(
          email: email,
          password: password,
        ));
  }

  Future<void> _signInWithGoogle() async {
    await _runAuth(() => _authService.signInWithGoogle());
  }

  Future<void> _signInWithApple() async {
    await _runAuth(() => _authService.signInWithApple());
  }

  Future<void> _runAuth(Future<dynamic> Function() action) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final result = await action();
      // If the auth action returned null (e.g. user cancelled Google Sign-In),
      // don't navigate – just stop loading.
      if (result == null) {
        if (mounted) setState(() => _isLoading = false);
        return;
      }
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const AppEntryScreen()),
        (_) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = _mapFirebaseError(e.code));
    } catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = 'حدث خطأ غير متوقع. يرجى المحاولة لاحقاً');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'لا يوجد حساب بهذا البريد الإلكتروني';
      case 'wrong-password':
        return 'كلمة المرور غير صحيحة';
      case 'invalid-email':
        return 'البريد الإلكتروني غير صالح';
      case 'user-disabled':
        return 'تم تعطيل هذا الحساب';
      case 'too-many-requests':
        return 'محاولات كثيرة جداً. يرجى المحاولة لاحقاً';
      case 'invalid-credential':
        return 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
      default:
        return 'حدث خطأ ($code). يرجى المحاولة لاحقاً';
    }
  }

  bool get _supportsAppleSignIn {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS;
  }

  // ── UI ──────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return OnboardingFrame(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title – Figma: 32px Bold
              Text(
                'مرحباً ولي الأمر 👋',
                textAlign: TextAlign.right,
                style: readexPro(
                  color: OnboardingColors.dark,
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'سجل دخولك لمتابعة تقدم طفلك',
                textAlign: TextAlign.right,
                style: readexPro(color: OnboardingColors.muted, fontSize: 16),
              ),
              const SizedBox(height: 28),
              const OnboardingLabel('البريد الإلكتروني'),
              const SizedBox(height: 12),
              OnboardingInput(
                hint: 'example@mail.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 18),
              const OnboardingLabel('كلمة المرور'),
              const SizedBox(height: 12),
              OnboardingInput(
                hint: '••••••••',
                controller: _passwordController,
                obscureText: _obscurePassword,
                prefix: GestureDetector(
                  onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                  child: Icon(
                    _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: OnboardingColors.muted,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OnboardingForgotPasswordScreen()),
                  );
                },
                child: Text(
                  'نسيت كلمة المرور؟',
                  textAlign: TextAlign.right,
                  style: readexPro(
                    color: OnboardingColors.primaryBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: readexPro(color: Colors.red.shade700, fontSize: 14),
                ),
              ],
              const SizedBox(height: 30),
              OnboardingPrimaryButton(
                label: 'تسجيل الدخول',
                isLoading: _isLoading,
                onTap: _signInWithEmail,
              ),
              const SizedBox(height: 28),
              const OnboardingDividerOr(),
              const SizedBox(height: 24),
              OnboardingSocialButton(
                icon: const Text('G',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF4285F4))),
                label: 'المتابعة عبر Google',
                onTap: _isLoading ? null : _signInWithGoogle,
              ),
              if (_supportsAppleSignIn) ...[
                const SizedBox(height: 16),
                OnboardingSocialButton(
                  icon: const Icon(Icons.apple, size: 22, color: Colors.black),
                  label: 'المتابعة عبر Apple',
                  onTap: _isLoading ? null : _signInWithApple,
                ),
              ],
              const SizedBox(height: 18),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const OnboardingSignUpScreen()),
                    );
                  },
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'ليس لديك حساب؟ ',
                          style: readexPro(color: OnboardingColors.dark, fontSize: 14),
                        ),
                        TextSpan(
                          text: 'إنشاء حساب جديد',
                          style: readexPro(
                            color: OnboardingColors.accentOrange,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
