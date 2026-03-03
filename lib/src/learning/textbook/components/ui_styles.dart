import 'package:flutter/material.dart';
import 'dart:ui';

class AppStyles {
  // Premium Soft Layered Shadow
  static const BoxShadow premiumShadow = BoxShadow(
    color: Color(0x0F000000), // Colors.black.withOpacity(0.06)
    blurRadius: 15,
    offset: Offset(0, 8),
  );

  // Glassmorphism Constants
  static final Color glassBackground = Colors.white.withOpacity(0.6);
  static const double glassBlurX = 12.0;
  static const double glassBlurY = 12.0;

  // Corner Radius
  static final BorderRadius standardRadius = BorderRadius.circular(24);
  static final BorderRadius largeRadius = BorderRadius.circular(32);

  // Border Style
  static final Border glassBorder = Border.all(
    color: Colors.white.withOpacity(0.4),
    width: 1.5,
  );

  // Text Styles
  static const TextStyle fredokaHeader = TextStyle(
    fontFamily: 'FredokaOne',
    fontWeight: FontWeight.normal,
    letterSpacing: 0.5,
  );

  static const TextStyle hintTitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.orange,
    fontFamily: 'FredokaOne',
  );

  static const TextStyle hintBodyStyle = TextStyle(
    fontSize: 14,
    color: Colors.blueGrey,
    fontWeight: FontWeight.w500,
  );
}
  // Instruction Styles
  static final Color instructionBackground = Colors.orange.shade50.withOpacity(0.6);
  static final Border instructionBorder = Border.all(
    color: Colors.orange.shade200.withOpacity(0.5),
    width: 2,
  );
}
