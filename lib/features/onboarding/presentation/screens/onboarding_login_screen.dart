import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/screens/auth_entry_screen.dart';
import '../../../parent/presentation/providers/parent_providers.dart';
import 'onboarding_forgot_password_screen.dart';
import 'onboarding_shared.dart';
import 'onboarding_sign_up_screen.dart';

/// Figma-faithful login screen (node `8:54`) wired to Firebase auth.
///
/// On successful sign-in the entire navigation stack is replaced with
/// [AppEntryScreen] which bootstraps the parent profile and shows
/// [ParentShellScreen].
class OnboardingLoginScreen extends ConsumerStatefulWidget {
  const OnboardingLoginScreen({super.key});

  @override
  ConsumerState<OnboardingLoginScreen> createState() =>
      _OnboardingLoginScreenState();
}

class _OnboardingLoginScreenState extends ConsumerState<OnboardingLoginScreen> {
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

  Future<void> _signInWithEmail() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'يرجى إدخال البريد الإلكتروني وكلمة المرور');
      return;
    }
    await _runAuth(() => ref.read(authServiceProvider).signInWithEmail(
          email: email,
          password: password,
        ));
  }

  Future<void> _signInWithGoogle() async {
    await _runAuth(() => ref.read(authServiceProvider).signInWithGoogle());
  }

  Future<void> _signInWithApple() async {
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
          const Positioned(top: 0, left: 0, right: 0, child: OnboardingStatusBar()),
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 88, 24, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'مرحباً ولي الأمر 👋',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: OnboardingColors.dark,
                    fontSize: 42,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'سجل دخولك لمتابعة تقدم طفلك',
                  textAlign: TextAlign.right,
                  style: TextStyle(color: OnboardingColors.muted, fontSize: 16),
                ),
                const SizedBox(height: 28),
                const Text(
                  'البريد الإلكتروني',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: OnboardingColors.dark,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                OnboardingInput(
                  hint: 'example@mail.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 18),
                const Text(
                  'كلمة المرور',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: OnboardingColors.dark,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                OnboardingInput(
                  hint: '••••••••',
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  prefix: GestureDetector(
                    onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                    child: Text(
                      _obscurePassword ? 'Show' : 'Hide',
                      style: const TextStyle(
                        color: OnboardingColors.primaryBlue,
                        fontSize: 12,
                      ),
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
                  child: const Text(
                    'نسيت كلمة المرور؟',
                    textAlign: TextAlign.right,
                    style: TextStyle(
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
                    style: TextStyle(color: Colors.red.shade700, fontSize: 14),
                  ),
                ],
                const SizedBox(height: 30),
                OnboardingPrimaryButton(
                  label: 'تسجيل الدخول',
                  isLoading: _isLoading,
                  onTap: _signInWithEmail,
                ),
                const SizedBox(height: 28),
                const _DividerWithOr(),
                const SizedBox(height: 24),
                _SocialButton(
                  icon: 'G',
                  label: 'المتابعة عبر Google',
                  onTap: _isLoading ? null : _signInWithGoogle,
                ),
                if (_supportsAppleSignIn) ...[
                  const SizedBox(height: 16),
                  _SocialButton(
                    icon: '',
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
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(color: OnboardingColors.dark, fontSize: 14),
                        children: [
                          TextSpan(text: 'ليس لديك حساب؟ '),
                          TextSpan(
                            text: 'إنشاء حساب جديد',
                            style: TextStyle(
                              color: OnboardingColors.accentOrange,
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

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.icon, required this.label, this.onTap});

  final String icon;
  final String label;
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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Text(
              icon,
              style: const TextStyle(
                fontSize: 24,
                color: OnboardingColors.dark,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: OnboardingColors.dark,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
