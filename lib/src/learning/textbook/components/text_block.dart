import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextBlock extends StatelessWidget {
  final String text;
  final TextType type;
  final TextAlign textAlign;
  final Color? color;

  const TextBlock({
    Key? key,
    required this.text,
    this.type = TextType.body,
    this.textAlign = TextAlign.left,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle style;

    switch (type) {
      case TextType.h1:
        // Fredoka One is bouncy and friendly
        style = GoogleFonts.fredoka(
          fontSize: 48,
          fontWeight: FontWeight.w700,
          color: color ?? Colors.black87,
        );
        break;
      case TextType.h2:
        style = GoogleFonts.fredoka(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: color ?? Colors.indigo,
        );
        break;
      case TextType.instruction:
        style = GoogleFonts.fredoka(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: color ?? Colors.deepOrange.shade700,
        );
        break;
      case TextType.rule:
        style = GoogleFonts.comicNeue(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: color ?? Colors.blueGrey.shade800,
        );
        break;
      case TextType.body:
      default:
        // Comic Neue is a good alternative for Sassoon Primary (which is a paid font)
        // It's readable for kids learning to read
        style = GoogleFonts.comicNeue(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: color ?? Colors.black87,
        );
        break;
    }

    return Text(
      text,
      style: style,
      textAlign: textAlign,
    );
  }
}

enum TextType {
  h1,
  h2,
  instruction,
  rule,
  body,
}
