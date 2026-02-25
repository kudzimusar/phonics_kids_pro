import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PhonicsBox extends StatelessWidget {
  final String text;
  final BoxType type;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final bool isDashed;

  const PhonicsBox({
    Key? key,
    required this.text,
    this.type = BoxType.standard,
    this.onTap,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.isDashed = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color bg = backgroundColor ?? Colors.white;
    Color border = borderColor ?? Colors.grey.shade300;
    Color contentColor = textColor ?? Colors.black87;
    double width = 80;
    double height = 80;
    double fontSize = 48;

    if (type == BoxType.small) {
      width = 60;
      height = 60;
      fontSize = 32;
    } else if (type == BoxType.vowel) {
      bg = backgroundColor ?? Colors.blue.shade50;
      border = borderColor ?? Colors.blue.shade300;
      contentColor = textColor ?? Colors.blue.shade800;
    } else if (type == BoxType.consonant) {
      bg = backgroundColor ?? Colors.red.shade50;
      border = borderColor ?? Colors.red.shade300;
      contentColor = textColor ?? Colors.red.shade800;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: isDashed 
              ? null // Flutter doesn't have native dashed border without a package, so we simulate it or just use solid for now, or use custom painter.
              : Border.all(color: border, width: 3),
          boxShadow: isDashed ? [] : [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: GoogleFonts.comicNeue(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            color: contentColor,
          ),
        ),
      ),
    );
  }
}

enum BoxType {
  standard,
  small,
  vowel,
  consonant,
}
