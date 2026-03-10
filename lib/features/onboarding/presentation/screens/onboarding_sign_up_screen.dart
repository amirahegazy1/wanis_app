import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../services/auth_service.dart';
import '../../../auth/presentation/screens/auth_entry_screen.dart';
import 'onboarding_login_screen.dart';
import 'onboarding_shared.dart';

/// Sign-up screen (Figma node `8:105`) wired to Firebase Auth.
class OnboardingSignUpScreen extends StatefulWidget {
  const OnboardingSignUpScreen({super.key});

  @override
  State<OnboardingSignUpScreen> createState() => _OnboardingSignUpScreenState();
}

class _OnboardingSignUpScreenState extends State<OnboardingSignUpScreen> {
  final _authService = AuthService();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _agreedToTerms = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ── Auth actions ────────────────────────────────────────────────

  Future<void> _signUp() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'يرجى ملء جميع الحقول');
      return;
    }
    if (!_agreedToTerms) {
      setState(() => _errorMessage = 'يرجى الموافقة على الشروط والأحكام');
      return;
    }
    await _runAuth(() => _authService.signUpWithEmail(
          email: email,
          password: password,
          displayName: name,
        ));
  }

  Future<void> _signUpWithGoogle() async {
    await _runAuth(() => _authService.signInWithGoogle());
  }

  Future<void> _signUpWithApple() async {
    await _runAuth(() => _authService.signInWithApple());
  }

  Future<void> _runAuth(Future<dynamic> Function() action) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      await action();
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
      case 'email-already-in-use':
        return 'هذا البريد الإلكتروني مستخدم بالفعل';
      case 'weak-password':
        return 'كلمة المرور ضعيفة. يرجى استخدام 6 أحرف على الأقل';
      case 'invalid-email':
        return 'البريد الإلكتروني غير صالح';
      case 'operation-not-allowed':
        return 'هذا النوع من التسجيل غير مفعّل حالياً';
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
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Back + Title row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_rounded, size: 20),
                  ),
                  Text(
                    'حساب جديد 🚀',
                    style: readexPro(
                      color: OnboardingColors.dark,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'انضم لعائلة ونيس وابدأ الرحلة',
                textAlign: TextAlign.right,
                style: readexPro(color: OnboardingColors.muted, fontSize: 16),
              ),
              const SizedBox(height: 28),
              const OnboardingLabel('الاسم الكامل'),
              const SizedBox(height: 12),
              OnboardingInput(hint: 'اكتب اسمك هنا...', controller: _nameController),
              const SizedBox(height: 18),
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
              const SizedBox(height: 18),
              // Terms checkbox
              GestureDetector(
                onTap: () => setState(() => _agreedToTerms = !_agreedToTerms),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'أوافق على ',
                            style: readexPro(color: OnboardingColors.dark, fontSize: 14),
                          ),
                          TextSpan(
                            text: 'الشروط والأحكام',
                            style: readexPro(
                              color: OnboardingColors.primaryBlue,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: _agreedToTerms
                              ? OnboardingColors.primaryBlue
                              : OnboardingColors.border,
                          width: 2,
                        ),
                        color: _agreedToTerms ? OnboardingColors.primaryBlue : Colors.white,
                      ),
                      child: _agreedToTerms
                          ? const Icon(Icons.check, size: 16, color: Colors.white)
                          : null,
                    ),
                  ],
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
              const SizedBox(height: 24),
              OnboardingPrimaryButton(
                label: 'إنشاء الحساب',
                color: OnboardingColors.accentOrange,
                borderRadius: 16,
                isLoading: _isLoading,
                onTap: _signUp,
              ),
              const SizedBox(height: 24),
              const OnboardingDividerOr(),
              const SizedBox(height: 18),
              // Social buttons – side by side (Figma layout)
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _isLoading ? null : _signUpWithGoogle,
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: OnboardingColors.border),
                        ),
                        alignment: Alignment.center,
                        child: const Text('G',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF4285F4),
                            )),
                      ),
                    ),
                  ),
                  if (_supportsAppleSignIn) ...[
                    const SizedBox(width: 15),
                    Expanded(
                      child: GestureDetector(
                        onTap: _isLoading ? null : _signUpWithApple,
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: OnboardingColors.border),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(Icons.apple, size: 28, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 18),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const OnboardingLoginScreen()),
                    );
                  },
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'لديك حساب بالفعل؟ ',
                          style: readexPro(color: OnboardingColors.dark, fontSize: 14),
                        ),
                        TextSpan(
                          text: 'تسجيل الدخول',
                          style: readexPro(
                            color: OnboardingColors.primaryBlue,
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
