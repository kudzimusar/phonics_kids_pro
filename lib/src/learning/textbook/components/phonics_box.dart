import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';

class PhonicsBox extends StatelessWidget {
  final String text;
  final BoxType type;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final bool isDashed;
  final double? sizeOverride;

  const PhonicsBox({
    Key? key,
    required this.text,
    this.type = BoxType.standard,
    this.onTap,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.isDashed = false,
    this.sizeOverride,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scale = ResponsiveHelper.componentScale(context);
    
    Color bg = backgroundColor ?? Colors.white;
    Color border = borderColor ?? Colors.blueGrey.withOpacity(0.2);
    Color contentColor = textColor ?? Colors.black87;
    
    double baseSize = sizeOverride ?? 80;
    double baseFontSize = 48;

    if (type == BoxType.small) {
      baseSize = 60;
      baseFontSize = 32;
    } else if (type == BoxType.vowel) {
      bg = backgroundColor ?? Colors.blue.shade50;
      border = borderColor ?? Colors.blue.withOpacity(0.3);
      contentColor = textColor ?? Colors.blue.shade800;
    } else if (type == BoxType.consonant) {
      bg = backgroundColor ?? Colors.red.shade50;
      border = borderColor ?? Colors.red.withOpacity(0.3);
      contentColor = textColor ?? Colors.red.shade800;
    }

    final boxSize = baseSize * scale;
    final fontSize = ResponsiveHelper.responsiveFontSize(context, baseFontSize);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: boxSize,
        height: boxSize,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16 * scale),
          border: Border.all(color: border, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10 * scale,
              offset: Offset(0, 4 * scale),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            fontFamily: 'FredokaOne',
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
