import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../services/auth_service.dart';
import 'onboarding_shared.dart';

/// Forgot password screen (Figma node `8:141`) wired to Firebase Auth.
class OnboardingForgotPasswordScreen extends StatefulWidget {
  const OnboardingForgotPasswordScreen({super.key});

  @override
  State<OnboardingForgotPasswordScreen> createState() =>
      _OnboardingForgotPasswordScreenState();
}

class _OnboardingForgotPasswordScreenState
    extends State<OnboardingForgotPasswordScreen> {
  final _authService = AuthService();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  String? _message;
  bool _isError = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        _message = 'يرجى إدخال البريد الإلكتروني';
        _isError = true;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      await _authService.sendPasswordResetEmail(email);
      if (!mounted) return;
      setState(() {
        _message = 'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني';
        _isError = false;
      });
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      String errorMsg;
      switch (e.code) {
        case 'user-not-found':
          errorMsg = 'لا يوجد حساب بهذا البريد الإلكتروني';
          break;
        case 'invalid-email':
          errorMsg = 'البريد الإلكتروني غير صالح';
          break;
        default:
          errorMsg = 'حدث خطأ (${e.code}). يرجى المحاولة لاحقاً';
      }
      setState(() {
        _message = errorMsg;
        _isError = true;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _message = 'حدث خطأ غير متوقع. يرجى المحاولة لاحقاً';
        _isError = true;
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingFrame(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(
            children: [
              // Back button
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_rounded, size: 20),
                ),
              ),
              const SizedBox(height: 16),
              // Lock icon circle
              Container(
                width: 81,
                height: 81,
                decoration: const BoxDecoration(
                  color: OnboardingColors.lightBlue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lock_outline_rounded,
                    color: OnboardingColors.primaryBlue, size: 28),
              ),
              const SizedBox(height: 16),
              Text(
                'نسيت كلمة المرور؟',
                textAlign: TextAlign.center,
                style: readexPro(
                  color: OnboardingColors.dark,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'لا تقلق! أدخل بريدك الإلكتروني بالأسفل\nوسنرسل لك تعليمات الاستعادة.',
                textAlign: TextAlign.center,
                style: readexPro(
                  color: OnboardingColors.muted,
                  fontSize: 16,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 26),
              const OnboardingLabel('البريد الإلكتروني'),
              const SizedBox(height: 12),
              OnboardingInput(
                hint: 'example@mail.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              if (_message != null) ...[
                const SizedBox(height: 12),
                Text(
                  _message!,
                  textAlign: TextAlign.center,
                  style: readexPro(
                    color: _isError ? Colors.red.shade700 : Colors.green.shade700,
                    fontSize: 14,
                  ),
                ),
              ],
              const SizedBox(height: 34),
              OnboardingPrimaryButton(
                label: 'إرسال الرابط',
                isLoading: _isLoading,
                onTap: _sendResetEmail,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
