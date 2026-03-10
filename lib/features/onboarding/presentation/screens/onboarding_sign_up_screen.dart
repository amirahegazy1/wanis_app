import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/screens/auth_entry_screen.dart';
import '../../../parent/presentation/providers/parent_providers.dart';
import 'onboarding_login_screen.dart';
import 'onboarding_shared.dart';

/// Figma-faithful sign-up screen (node `8:105`) wired to Firebase auth.
///
/// After successful account creation the entire stack is replaced with
/// [AppEntryScreen] which bootstraps the parent profile.
class OnboardingSignUpScreen extends ConsumerStatefulWidget {
  const OnboardingSignUpScreen({super.key});

  @override
  ConsumerState<OnboardingSignUpScreen> createState() =>
      _OnboardingSignUpScreenState();
}

class _OnboardingSignUpScreenState
    extends ConsumerState<OnboardingSignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _agreedToTerms = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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

    await _runAuth(() => ref.read(authServiceProvider).signUpWithEmail(
          email: email,
          password: password,
          name: name,
        ));
  }

  Future<void> _signUpWithGoogle() async {
    await _runAuth(() => ref.read(authServiceProvider).signInWithGoogle());
  }

  Future<void> _signUpWithApple() async {
    await _runAuth(() => ref.read(authServiceProvider).signInWithApple());
  }

  Future<void> _runAuth(Future<void> Function() action) async {
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
    } catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  bool get _supportsAppleSignIn {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS;
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingFrame(
      child: Stack(
        children: [
          const Positioned(
              top: 0, left: 0, right: 0, child: OnboardingStatusBar()),
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 86, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back_rounded,
                          color: OnboardingColors.dark),
                    ),
                    const Spacer(),
                    const Text(
                      'حساب جديد 🚀',
                      style: TextStyle(
                        color: OnboardingColors.dark,
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'انضم لعائلة ونيس وابدأ الرحلة',
                  textAlign: TextAlign.right,
                  style: TextStyle(color: OnboardingColors.muted, fontSize: 16),
                ),
                const SizedBox(height: 26),
                const _Label('الاسم الكامل'),
                const SizedBox(height: 12),
                OnboardingInput(
                  hint: 'اكتب اسمك هنا...',
                  controller: _nameController,
                ),
                const SizedBox(height: 18),
                const _Label('البريد الإلكتروني'),
                const SizedBox(height: 12),
                OnboardingInput(
                  hint: 'example@mail.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 18),
                const _Label('كلمة المرور'),
                const SizedBox(height: 12),
                OnboardingInput(
                  hint: '••••••••',
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  prefix: GestureDetector(
                    onTap: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                    child: Text(
                      _obscurePassword ? 'Show' : 'Hide',
                      style: const TextStyle(
                        color: OnboardingColors.primaryBlue,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                GestureDetector(
                  onTap: () =>
                      setState(() => _agreedToTerms = !_agreedToTerms),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text.rich(
                          const TextSpan(
                            children: [
                              TextSpan(text: 'أوافق على '),
                              TextSpan(
                                text: 'الشروط والأحكام',
                                style: TextStyle(
                                  color: OnboardingColors.primaryBlue,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                              color: OnboardingColors.dark, fontSize: 14),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        _agreedToTerms
                            ? Icons.check_box_rounded
                            : Icons.check_box_outline_blank_rounded,
                        color: OnboardingColors.primaryBlue,
                      ),
                    ],
                  ),
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red.shade700, fontSize: 14),
                  ),
                ],
                const SizedBox(height: 18),
                OnboardingPrimaryButton(
                  label: 'إنشاء الحساب',
                  color: OnboardingColors.accentOrange,
                  isLoading: _isLoading,
                  onTap: _signUp,
                ),
                const SizedBox(height: 30),
                const _DividerWithOr(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (_supportsAppleSignIn)
                      Expanded(
                        child: _SquareSocial(
                          icon: '',
                          onTap: _isLoading ? null : _signUpWithApple,
                        ),
                      ),
                    if (_supportsAppleSignIn) const SizedBox(width: 15),
                    Expanded(
                      child: _SquareSocial(
                        icon: 'G',
                        onTap: _isLoading ? null : _signUpWithGoogle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const OnboardingLoginScreen()),
                      );
                    },
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                            color: OnboardingColors.dark, fontSize: 14),
                        children: [
                          TextSpan(text: 'لديك حساب بالفعل؟ '),
                          TextSpan(
                            text: 'تسجيل الدخول',
                            style: TextStyle(
                              color: OnboardingColors.primaryBlue,
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
          const OnboardingHomeIndicator(),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.right,
      style: const TextStyle(
        color: OnboardingColors.dark,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _DividerWithOr extends StatelessWidget {
  const _DividerWithOr();
  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: Divider(color: OnboardingColors.border)),
        SizedBox(width: 14),
        Text('أو', style: TextStyle(color: OnboardingColors.muted)),
        SizedBox(width: 14),
        Expanded(child: Divider(color: OnboardingColors.border)),
      ],
    );
  }
}

class _SquareSocial extends StatelessWidget {
  const _SquareSocial({required this.icon, this.onTap});
  final String icon;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: OnboardingColors.border),
        ),
        alignment: Alignment.center,
        child: Text(icon,
            style: const TextStyle(
                fontSize: 28, color: OnboardingColors.dark)),
      ),
    );
  }
}
