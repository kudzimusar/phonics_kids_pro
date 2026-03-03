import 'package:flutter/material.dart';
import 'dart:ui';
import '../utils/responsive_helper.dart';
import 'ui_styles.dart';

class PhonicFoxNarrator extends StatefulWidget {
  final String text;
  final FoxState state;

  const PhonicFoxNarrator({
    Key? key,
    required this.text,
    this.state = FoxState.idle,
  }) : super(key: key);

  @override
  State<PhonicFoxNarrator> createState() => _PhonicFoxNarratorState();
}

class _PhonicFoxNarratorState extends State<PhonicFoxNarrator> {
  @override
  Widget build(BuildContext context) {
    final bool isMobile = ResponsiveHelper.isMobile(context);
    String emoji = "🦊";
    if (widget.state == FoxState.openMouth) {
      emoji = "🦊😮";
    } else if (widget.state == FoxState.success) {
      emoji = "🦊✨";
    } else if (widget.state == FoxState.thinking) {
      emoji = "🦊🤔";
    }

    return ClipRRect(
      borderRadius: AppStyles.standardRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: AppStyles.glassBlurX, sigmaY: AppStyles.glassBlurY),
        child: Container(
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          decoration: BoxDecoration(
            color: AppStyles.glassBackground,
            borderRadius: AppStyles.standardRadius,
            border: AppStyles.glassBorder,
            boxShadow: const [AppStyles.premiumShadow],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFoxAvatar(emoji, isMobile),
              SizedBox(width: isMobile ? 12 : 16),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 12 : 16,
                    vertical: isMobile ? 8 : 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Text(
                    widget.text,
                    style: TextStyle(
                      fontSize: isMobile ? 16 : 18,
                      color: Colors.orange.shade900,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'FredokaOne',
                      height: 1.3,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFoxAvatar(String emoji, bool isMobile) {
    final double size = isMobile ? 48 : 64;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.orange.shade50.withOpacity(0.5),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.orange.shade100, width: 2),
          ),
          child: Center(
            child: Image.network(
              'https://img.icons8.com/fluency/96/fox.png',
              width: size * 0.8,
              height: size * 0.8,
              errorBuilder: (context, error, stackTrace) => Text(
                emoji,
                style: TextStyle(fontSize: size * 0.6),
              ),
            ),
          ),
        ),
        if (widget.state == FoxState.success)
          Positioned(
            top: -3,
            right: -3,
            child: Image.network(
              'https://img.icons8.com/fluency/48/sparkling.png',
              width: isMobile ? 18 : 24,
              height: isMobile ? 18 : 24,
              errorBuilder: (context, error, stackTrace) => Text("✨", style: TextStyle(fontSize: isMobile ? 12 : 16)),
            ),
          ),
      ],
    );
  }
}

enum FoxState {
  idle,
  openMouth,
  success,
  error,
  thinking
}
