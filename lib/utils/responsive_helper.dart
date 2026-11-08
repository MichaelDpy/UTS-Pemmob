import 'package:flutter/material.dart';

/// Helper class untuk responsive design dengan breakpoints standar.
/// Menyediakan utility methods untuk adaptive layouts berdasarkan screen size.
class ResponsiveHelper {
  // ─── Breakpoints ───────────────────────────────────────────────
  
  /// Mobile: width < 600px
  static const double mobileBreakpoint = 600;
  
  /// Tablet: 600px <= width < 1024px
  static const double tabletBreakpoint = 1024;
  
  /// Desktop: width >= 1024px
  static const double desktopBreakpoint = 1024;

  // ─── Device Type Detection ─────────────────────────────────────

  /// Apakah device saat ini mobile (width < 600px)
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  /// Apakah device saat ini tablet (600px <= width < 1024px)
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  /// Apakah device saat ini desktop (width >= 1024px)
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopBreakpoint;
  }

  /// Apakah device saat ini portrait orientation
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  /// Apakah device saat ini landscape orientation
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  // ─── Responsive Values ─────────────────────────────────────────

  /// Mengembalikan nilai yang berbeda berdasarkan device type.
  /// [mobile] untuk mobile, [tablet] untuk tablet, [desktop] untuk desktop.
  static T responsive<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context)) {
      return desktop ?? tablet ?? mobile;
    } else if (isTablet(context)) {
      return tablet ?? mobile;
    } else {
      return mobile;
    }
  }

  // ─── Padding & Spacing ─────────────────────────────────────────

  /// Padding horizontal yang responsive
  static double horizontalPadding(BuildContext context) {
    return responsive(
      context: context,
      mobile: 16.0,
      tablet: 32.0,
      desktop: 64.0,
    );
  }

  /// Padding vertikal yang responsive
  static double verticalPadding(BuildContext context) {
    return responsive(
      context: context,
      mobile: 16.0,
      tablet: 24.0,
      desktop: 32.0,
    );
  }

  /// Card padding yang responsive
  static double cardPadding(BuildContext context) {
    return responsive(
      context: context,
      mobile: 16.0,
      tablet: 20.0,
      desktop: 24.0,
    );
  }

  /// Spacing antar elemen yang responsive
  static double spacing(BuildContext context) {
    return responsive(
      context: context,
      mobile: 12.0,
      tablet: 16.0,
      desktop: 20.0,
    );
  }

  // ─── Font Sizes ────────────────────────────────────────────────

  /// Heading font size yang responsive
  static double headingFontSize(BuildContext context) {
    return responsive(
      context: context,
      mobile: 24.0,
      tablet: 28.0,
      desktop: 32.0,
    );
  }

  /// Title font size yang responsive
  static double titleFontSize(BuildContext context) {
    return responsive(
      context: context,
      mobile: 18.0,
      tablet: 20.0,
      desktop: 22.0,
    );
  }

  /// Body font size yang responsive
  static double bodyFontSize(BuildContext context) {
    return responsive(
      context: context,
      mobile: 14.0,
      tablet: 15.0,
      desktop: 16.0,
    );
  }

  // ─── Layout Helpers ────────────────────────────────────────────

  /// Max width untuk content (mencegah terlalu lebar di desktop)
  static double maxContentWidth(BuildContext context) {
    return responsive(
      context: context,
      mobile: double.infinity,
      tablet: 800.0,
      desktop: 1200.0,
    );
  }

  /// Content width percentage dari screen width
  static double contentWidthPercentage(BuildContext context) {
    return responsive(
      context: context,
      mobile: 1.0,  // 100% for mobile
      tablet: 0.85, // 85% for tablet
      desktop: 0.7, // 70% for desktop
    );
  }

  /// Grid cross axis count (berapa kolom di grid)
  static int gridCrossAxisCount(BuildContext context) {
    return responsive(
      context: context,
      mobile: 1,
      tablet: 2,
      desktop: 3,
    );
  }

  /// Quiz card max width
  static double quizCardMaxWidth(BuildContext context) {
    return responsive(
      context: context,
      mobile: double.infinity,
      tablet: 600.0,
      desktop: 700.0,
    );
  }

  // ─── Icon Sizes ────────────────────────────────────────────────

  /// Icon size yang responsive
  static double iconSize(BuildContext context) {
    return responsive(
      context: context,
      mobile: 24.0,
      tablet: 28.0,
      desktop: 32.0,
    );
  }

  /// Large icon size yang responsive
  static double largeIconSize(BuildContext context) {
    return responsive(
      context: context,
      mobile: 48.0,
      tablet: 56.0,
      desktop: 64.0,
    );
  }

  // ─── Button Sizes ──────────────────────────────────────────────

  /// Button height yang responsive
  static double buttonHeight(BuildContext context) {
    return responsive(
      context: context,
      mobile: 50.0,
      tablet: 54.0,
      desktop: 58.0,
    );
  }

  /// Button padding yang responsive
  static EdgeInsets buttonPadding(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: responsive(
        context: context,
        mobile: 24.0,
        tablet: 32.0,
        desktop: 40.0,
      ),
      vertical: responsive(
        context: context,
        mobile: 14.0,
        tablet: 16.0,
        desktop: 18.0,
      ),
    );
  }

  // ─── Utility Methods ───────────────────────────────────────────

  /// Get screen width
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Get screen height
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Center content dengan max width
  static Widget centerWithMaxWidth({
    required BuildContext context,
    required Widget child,
    double? maxWidth,
  }) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? maxContentWidth(context),
        ),
        child: child,
      ),
    );
  }

  /// Wrap dengan responsive padding
  static Widget withResponsivePadding({
    required BuildContext context,
    required Widget child,
    bool horizontal = true,
    bool vertical = true,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontal ? horizontalPadding(context) : 0,
        vertical: vertical ? verticalPadding(context) : 0,
      ),
      child: child,
    );
  }
}

/// Extension untuk memudahkan akses responsive helper dari BuildContext
extension ResponsiveExtension on BuildContext {
  /// Shortcut untuk cek apakah mobile
  bool get isMobile => ResponsiveHelper.isMobile(this);
  
  /// Shortcut untuk cek apakah tablet
  bool get isTablet => ResponsiveHelper.isTablet(this);
  
  /// Shortcut untuk cek apakah desktop
  bool get isDesktop => ResponsiveHelper.isDesktop(this);
  
  /// Shortcut untuk cek apakah portrait
  bool get isPortrait => ResponsiveHelper.isPortrait(this);
  
  /// Shortcut untuk cek apakah landscape
  bool get isLandscape => ResponsiveHelper.isLandscape(this);
  
  /// Shortcut untuk responsive value
  T responsive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    return ResponsiveHelper.responsive(
      context: this,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }
}
