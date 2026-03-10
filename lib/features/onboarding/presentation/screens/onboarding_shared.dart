import 'package:flutter/material.dart';

/// Shared colour tokens used by onboarding screens translated from Figma.
class OnboardingColors {
  const OnboardingColors._();

  static const background = Color(0xFFF1F3F6);
  static const dark = Color(0xFF2D3748);
  static const muted = Color(0xFFA0AEC0);
  static const border = Color(0xFFE2E8F0);
  static const primaryBlue = Color(0xFF5D9CEC);
  static const accentOrange = Color(0xFFF4A261);
  static const success = Color(0xFF48C774);
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

/// Fake iOS style status row used in Figma onboarding mocks.
class OnboardingStatusBar extends StatelessWidget {
  const OnboardingStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
      child: Row(
        children: const [
          Text(
            '07 : 00',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Spacer(),
          Icon(Icons.signal_cellular_alt_rounded, size: 15),
          SizedBox(width: 4),
          Icon(Icons.wifi_rounded, size: 15),
          SizedBox(width: 4),
          Icon(Icons.battery_full_rounded, size: 17),
        ],
      ),
    );
  }
}

/// Bottom home indicator bar shown on mockup screens.
class OnboardingHomeIndicator extends StatelessWidget {
  const OnboardingHomeIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 140,
        height: 5,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(8),
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
        style: const TextStyle(color: OnboardingColors.dark, fontSize: 16),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: OnboardingColors.muted, fontSize: 16),
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
              ? Padding(padding: const EdgeInsets.only(left: 12), child: prefix)
              : null,
          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
          suffixIcon: suffix != null
              ? Padding(padding: const EdgeInsets.only(right: 12), child: suffix)
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
  });

  final String label;
  final VoidCallback onTap;
  final Color color;
  final bool isLoading;

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
            borderRadius: BorderRadius.circular(56),
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
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}
