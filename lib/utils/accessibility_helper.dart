import 'package:flutter/material.dart';

/// Helper untuk accessibility features.
/// Memastikan aplikasi dapat diakses oleh semua user.
class AccessibilityHelper {
  // ─── Semantic Labels ───────────────────────────────────────────

  /// Wrap widget dengan semantic label untuk screen readers
  static Widget semanticLabel({
    required Widget child,
    required String label,
    String? hint,
    bool excludeSemantics = false,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      excludeSemantics: excludeSemantics,
      child: child,
    );
  }

  /// Button dengan semantic label
  static Widget semanticButton({
    required Widget child,
    required String label,
    required VoidCallback onPressed,
    String? hint,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      button: true,
      enabled: true,
      child: child,
    );
  }

  // ─── Focus Management ──────────────────────────────────────────

  /// Create focus node dengan auto dispose
  static FocusNode createFocusNode() {
    return FocusNode();
  }

  /// Request focus safely
  static void requestFocus(BuildContext context, FocusNode node) {
    FocusScope.of(context).requestFocus(node);
  }

  /// Unfocus (hide keyboard)
  static void unfocus(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  // ─── Touch Target Sizes ────────────────────────────────────────

  /// Minimum touch target size (48x48 untuk accessibility)
  static const double minTouchTarget = 48.0;

  /// Wrap widget dengan minimum touch target
  static Widget touchTarget({
    required Widget child,
    double size = minTouchTarget,
  }) {
    return SizedBox(
      width: size,
      height: size,
      child: Center(child: child),
    );
  }

  // ─── Color Contrast ────────────────────────────────────────────

  /// Check if color combination has sufficient contrast
  /// WCAG AA requires 4.5:1 for normal text, 3:1 for large text
  static bool hasSufficientContrast(
    Color foreground,
    Color background, {
    bool isLargeText = false,
  }) {
    final contrast = calculateContrast(foreground, background);
    final minContrast = isLargeText ? 3.0 : 4.5;
    return contrast >= minContrast;
  }

  /// Calculate contrast ratio between two colors
  static double calculateContrast(Color color1, Color color2) {
    final lum1 = _calculateLuminance(color1);
    final lum2 = _calculateLuminance(color2);
    final lighter = lum1 > lum2 ? lum1 : lum2;
    final darker = lum1 > lum2 ? lum2 : lum1;
    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Calculate relative luminance of color
  static double _calculateLuminance(Color color) {
    final r = _linearize(color.red / 255.0);
    final g = _linearize(color.green / 255.0);
    final b = _linearize(color.blue / 255.0);
    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  static double _linearize(double value) {
    if (value <= 0.03928) {
      return value / 12.92;
    } else {
      return ((value + 0.055) / 1.055) * ((value + 0.055) / 1.055);
    }
  }

  // ─── Announcements ─────────────────────────────────────────────

  /// Announce message to screen reader
  static void announce(
    BuildContext context,
    String message, {
    TextDirection textDirection = TextDirection.ltr,
  }) {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 1),
        backgroundColor: Colors.transparent,
      ),
    );
  }

  // ─── Text Scaling ──────────────────────────────────────────────

  /// Get text scale factor dari system
  static double getTextScaleFactor(BuildContext context) {
    return MediaQuery.of(context).textScaleFactor;
  }

  /// Check if user menggunakan large text
  static bool isLargeText(BuildContext context) {
    return getTextScaleFactor(context) > 1.3;
  }

  // ─── High Contrast Mode ────────────────────────────────────────

  /// Check if device dalam high contrast mode
  static bool isHighContrastMode(BuildContext context) {
    return MediaQuery.of(context).highContrast;
  }

  // ─── Reduce Motion ─────────────────────────────────────────────

  /// Check if user prefer reduced motion
  static bool prefersReducedMotion(BuildContext context) {
    return MediaQuery.of(context).disableAnimations;
  }

  /// Get animation duration based on user preference
  static Duration getAnimationDuration(
    BuildContext context,
    Duration normalDuration,
  ) {
    return prefersReducedMotion(context)
        ? Duration.zero
        : normalDuration;
  }

  // ─── Screen Reader ─────────────────────────────────────────────

  /// Check if screen reader is active
  static bool isScreenReaderActive(BuildContext context) {
    return MediaQuery.of(context).accessibleNavigation;
  }

  // ─── Helper Widgets ────────────────────────────────────────────

  /// Exclude from semantics tree (untuk decorative elements)
  static Widget excludeSemantics(Widget child) {
    return ExcludeSemantics(child: child);
  }

  /// Merge semantics dari multiple children
  static Widget mergeSemantics({
    required Widget child,
  }) {
    return MergeSemantics(child: child);
  }
}

/// Extension untuk BuildContext accessibility shortcuts
extension AccessibilityExtension on BuildContext {
  /// Check if screen reader active
  bool get isScreenReaderActive => 
      AccessibilityHelper.isScreenReaderActive(this);
  
  /// Check if high contrast mode
  bool get isHighContrastMode => 
      AccessibilityHelper.isHighContrastMode(this);
  
  /// Check if reduced motion preferred
  bool get prefersReducedMotion => 
      AccessibilityHelper.prefersReducedMotion(this);
  
  /// Get text scale factor
  double get textScaleFactor => 
      AccessibilityHelper.getTextScaleFactor(this);
  
  /// Check if large text
  bool get isLargeText => 
      AccessibilityHelper.isLargeText(this);
  
  /// Unfocus (hide keyboard)
  void unfocus() => AccessibilityHelper.unfocus(this);
  
  /// Announce to screen reader
  void announce(String message) => 
      AccessibilityHelper.announce(this, message);
}
