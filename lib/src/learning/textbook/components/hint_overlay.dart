import 'package:flutter/material.dart';
import 'dart:ui';
import '../utils/responsive_helper.dart';
import 'vector_graphic.dart';
import 'ui_styles.dart';

class HintOverlay extends StatefulWidget {
  final VoidCallback onHintDismissed;
  final String hintText;

  const HintOverlay({
    Key? key,
    required this.onHintDismissed,
    required this.hintText,
  }) : super(key: key);

  @override
  State<HintOverlay> createState() => _HintOverlayState();
}

class _HintOverlayState extends State<HintOverlay> {
  bool _isExpanded = false;

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 110, // Sits above the future Bottom Nav Dock
      right: 24,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Curves.elasticOut,
            ),
            child: child,
          );
        },
        child: _isExpanded ? _buildExpandedHint() : _buildCollapsedHint(),
      ),
    );
  }

  Widget _buildCollapsedHint() {
    return GestureDetector(
      key: const ValueKey('collapsed'),
      onTap: _toggleExpansion,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: const [AppStyles.premiumShadow],
          border: Border.all(color: Colors.amber.shade300, width: 2),
        ),
        padding: const EdgeInsets.all(8),
        child: const VectorGraphic(
          assetName: 'fox',
          size: 40,
        ),
      ),
    );
  }

  Widget _buildExpandedHint() {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double maxWidth = ResponsiveHelper.isMobile(context) ? screenWidth * 0.8 : 320;

    return GestureDetector(
      key: const ValueKey('expanded'),
      onTap: _toggleExpansion,
      child: ClipRRect(
        borderRadius: AppStyles.standardRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: AppStyles.glassBlurX, sigmaY: AppStyles.glassBlurY),
          child: Container(
            width: maxWidth,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppStyles.glassBackground,
              borderRadius: AppStyles.standardRadius,
              border: AppStyles.glassBorder,
              boxShadow: const [AppStyles.premiumShadow],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Need a hint?",
                        style: AppStyles.hintTitleStyle,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.hintText,
                        style: AppStyles.hintBodyStyle,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Tap to close",
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.blueGrey.withOpacity(0.5),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const VectorGraphic(
                    assetName: 'fox',
                    size: 40,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
