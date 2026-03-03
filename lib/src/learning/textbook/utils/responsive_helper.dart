import 'package:flutter/material.dart';

class ResponsiveHelper {
  // Define breakpoints
  static const double mobileNarrow = 600.0;
  static const double tabletMedium = 1024.0;

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileNarrow;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= mobileNarrow &&
        MediaQuery.of(context).size.width < tabletMedium;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletMedium;
  }

  // Value getters based on screen size
  static double getScaleFactor(BuildContext context) {
    if (isMobile(context)) {
      return 0.7; // Reduce size of text/elements on mobile
    } else if (isTablet(context)) {
      return 0.9;
    } else {
      return 1.0;
    }
  }

  static double getResponsiveValue({
    required BuildContext context,
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    if (isMobile(context)) {
      return mobile;
    } else if (isTablet(context)) {
      return tablet;
    } else {
      return desktop;
    }
  }

  static int getResponsiveGridCount({
    required BuildContext context,
    required int mobile,
    required int tablet,
    required int desktop,
  }) {
    if (isMobile(context)) {
      return mobile;
    } else if (isTablet(context)) {
      return tablet;
    } else {
      return desktop;
    }
  }

  // Cross axis count calculation specifically for grids with constraints
  static int calculateGridCrossAxisCount(double availableWidth, double desiredItemWidth) {
    // Ensure we always have at least 1 column
    int count = (availableWidth / desiredItemWidth).floor();
    return count > 0 ? count : 1;
  }

  /// Returns a scaled font size based on screenWidth / 600 (capped for safety).
  static double responsiveFontSize(BuildContext context, double base) {
    double width = MediaQuery.of(context).size.width;
    double scale = width / 600;
    // Cap for safety: between 0.8 and 1.5
    scale = scale.clamp(0.8, 1.5);
    return base * scale;
  }

  /// Global multiplier to be used for padding and icon sizes.
  static double componentScale(BuildContext context) {
    if (isMobile(context)) {
      return 0.7; // Tiny mobile
    } else if (isTablet(context)) {
      return 1.0; // Tablet
    } else {
      return 1.2; // Desktop
    }
  }

  /// Returns true if screenHeight < 700px (helps detect landscape phones or older iPhones).
  static bool isShortScreen(BuildContext context) {
    return MediaQuery.of(context).size.height < 700;
  }
}
