import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/responsive_helper.dart';

class TextBlock extends StatelessWidget {
  final String text;
  final TextType type;
  final TextAlign textAlign;
  final Color? color;
  final double? fontSize;

  const TextBlock({
    Key? key,
    required this.text,
    this.type = TextType.body,
    this.textAlign = TextAlign.left,
    this.color,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle style;
    
    // Import helper if needed, but it's likely already in the path or will be.
    // Assuming ResponsiveHelper is in utils/responsive_helper.dart
    
    double getResponsiveSize(double base) => 
      fontSize ?? ResponsiveHelper.responsiveFontSize(context, base);

    switch (type) {
      case TextType.h1:
        style = GoogleFonts.fredoka(
          fontSize: getResponsiveSize(48),
          fontWeight: FontWeight.w700,
          color: color ?? Colors.black87,
        );
        break;
      case TextType.h2:
        style = GoogleFonts.fredoka(
          fontSize: getResponsiveSize(32),
          fontWeight: FontWeight.w600,
          color: color ?? Colors.indigo,
        );
        break;
      case TextType.instruction:
        style = GoogleFonts.fredoka(
          fontSize: getResponsiveSize(22),
          fontWeight: FontWeight.w500,
          color: color ?? Colors.deepOrange.shade700,
        );
        break;
      case TextType.rule:
        style = GoogleFonts.comicNeue(
          fontSize: getResponsiveSize(22),
          fontWeight: FontWeight.w700,
          color: color ?? Colors.blueGrey.shade800,
        ).copyWith(fontFamily: 'SassoonPrimary');
        break;
      case TextType.body:
      default:
        style = GoogleFonts.comicNeue(
          fontSize: getResponsiveSize(24),
          fontWeight: FontWeight.w600,
          color: color ?? Colors.black87,
        ).copyWith(fontFamily: 'SassoonPrimary');
        break;
    }

    return _wrapWithStyle(
      Text(
        text,
        style: style,
        textAlign: textAlign,
      ),
      context,
    );
  }

  Widget _wrapWithStyle(Widget child, BuildContext context) {
    if (type == TextType.instruction) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: color?.withOpacity(0.1) ?? Color(0xFFFFF7E6).withOpacity(0.6), // Subtle orange/cream
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color?.withOpacity(0.3) ?? Colors.orange.shade100.withOpacity(0.5),
            width: 2,
          ),
        ),
        child: child,
      );
    }
    return child;
  }
}


enum TextType {
  h1,
  h2,
  instruction,
  rule,
  body,
}
