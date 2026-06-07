import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Shared colour tokens used by onboarding screens translated from Figma.
class OnboardingColors {
  const OnboardingColors._();

  static const background = Color(0xFFF1F3F6);
  static const dark = Color(0xFF2D3748);
  static const muted = Color(0xFFA0AEC0);
  static const border = Color(0xFFE2E8F0);
  static const borderDark = Color(0xFFCBD5E0);
  static const primaryBlue = Color(0xFF5D9CEC);
  static const accentOrange = Color(0xFFF4A261);
  static const success = Color(0xFF48C774);
  static const lightBlue = Color(0xFFEBF8FF);
  static const splashBlue = Color(0xFF6BB5F8);
}

/// Readex Pro text style helper – ensures font family consistency everywhere.
TextStyle readexPro({
  double fontSize = 16,
  FontWeight fontWeight = FontWeight.w400,
  Color color = OnboardingColors.dark,
  double? height,
  TextDecoration? decoration,
}) {
  return GoogleFonts.readexPro(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    height: height,
    decoration: decoration,
  );
}

/// Outer frame used by onboarding screens to keep consistent width and spacing.
class OnboardingFrame extends StatelessWidget {
  const OnboardingFrame({
    super.key,
    required this.child,
    this.backgroundColor = OnboardingColors.background,
  });

  final Widget child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: child,
          ),
        ),
      ),
    );
  }
}


/// Reusable onboarding text input with rounded 16px border.
///
/// Wraps a real [TextField] so that users can type. Keeps the same
/// visual style as the Figma mock (white fill, 56px height, 16px radius).
class OnboardingInput extends StatelessWidget {
  const OnboardingInput({
    super.key,
    required this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.suffix,
    this.prefix,
  });

  final String hint;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffix;
  final Widget? prefix;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        style: readexPro(color: OnboardingColors.dark, fontSize: 16),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: readexPro(color: OnboardingColors.muted, fontSize: 16),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: OnboardingColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: OnboardingColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: OnboardingColors.primaryBlue, width: 1.5),
          ),
          prefixIcon: prefix != null
              ? Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: prefix)
              : null,
          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
          suffixIcon: suffix != null
              ? Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: suffix)
              : null,
          suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        ),
      ),
    );
  }
}

/// Primary CTA used across onboarding.
class OnboardingPrimaryButton extends StatelessWidget {
  const OnboardingPrimaryButton({
    super.key,
    required this.label,
    required this.onTap,
    this.color = OnboardingColors.primaryBlue,
    this.isLoading = false,
    this.borderRadius = 56,
  });

  final String label;
  final VoidCallback onTap;
  final Color color;
  final bool isLoading;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton(
        onPressed: isLoading ? null : onTap,
        style: FilledButton.styleFrom(
          backgroundColor: color,
          disabledBackgroundColor: color.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Text(
                label,
                style: readexPro(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}

/// Divider with "أو" in the middle – used in login/signup.
class OnboardingDividerOr extends StatelessWidget {
  const OnboardingDividerOr({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: OnboardingColors.border)),
        const SizedBox(width: 14),
        Text('أو', style: readexPro(color: OnboardingColors.muted, fontSize: 14)),
        const SizedBox(width: 14),
        const Expanded(child: Divider(color: OnboardingColors.border)),
      ],
    );
  }
}

/// Social login button matching Figma style (full-width, outlined).
class OnboardingSocialButton extends StatelessWidget {
  const OnboardingSocialButton({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  final Widget icon;
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 8),
            Text(
              label,
              style: readexPro(
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

/// Reusable form field label.
class OnboardingLabel extends StatelessWidget {
  const OnboardingLabel(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.right,
      style: readexPro(
        color: OnboardingColors.dark,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

/// Success circle with check icon – used in success screens.
class OnboardingSuccessCircle extends StatelessWidget {
  const OnboardingSuccessCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 160,
      decoration: const BoxDecoration(
        color: Color(0x1A48C774),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Container(
        width: 120,
        height: 120,
        decoration: const BoxDecoration(
          color: OnboardingColors.success,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check_rounded, color: Colors.white, size: 62),
      ),
    );
  }
}
