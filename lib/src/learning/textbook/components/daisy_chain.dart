import 'package:flutter/material.dart';
import 'dart:math';
import 'vector_graphic.dart';
import 'letter_drop_target.dart';
import '../utils/responsive_helper.dart';

class DaisyChainRow extends StatefulWidget {
  final String icon;
  final List<String> letters; // '?' represents the blank/target letter
  final String targetLetter;
  final ValueChanged<bool>? onStatusChanged;

  const DaisyChainRow({
    Key? key,
    required this.icon,
    required this.letters,
    required this.targetLetter,
    this.onStatusChanged,
  }) : super(key: key);

  @override
  State<DaisyChainRow> createState() => _DaisyChainRowState();
}

class _DaisyChainRowState extends State<DaisyChainRow> {
  bool _isFilled = false;

  @override
  Widget build(BuildContext context) {
    final scale = ResponsiveHelper.componentScale(context);
    
    return Container(
      margin: EdgeInsets.only(bottom: 32 * scale),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Icon on the left
              SizedBox(
                width: 90 * scale,
                child: VectorGraphic(
                  assetName: widget.icon, 
                  size: 72 * scale
                ),
              ),
              SizedBox(width: 32 * scale),

              // 2. Chained Daisies
              Expanded(
                child: Wrap(
                  spacing: 16 * scale,
                  runSpacing: 16 * scale,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: widget.letters.map((letter) {
                    if (letter == '?') {
                      if (_isFilled) {
                        return DaisyShape(
                          letter: widget.targetLetter, 
                          isTarget: true,
                          isAnimate: true,
                        );
                      }
                      return LetterDropTarget(
                        correctLetter: widget.targetLetter,
                        onDropResult: (success, letterStr) {
                          if (success) {
                            setState(() => _isFilled = true);
                            if (widget.onStatusChanged != null) {
                              widget.onStatusChanged!(true);
                            }
                          }
                        },
                      );
                    }
                    return DaisyShape(letter: letter);
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class DaisyShape extends StatelessWidget {
  final String letter;
  final bool isTarget;
  final bool isAnimate;

  const DaisyShape({
    Key? key,
    required this.letter,
    this.isTarget = false,
    this.isAnimate = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scale = ResponsiveHelper.componentScale(context);
    final size = 64.0 * scale;

    Widget daisy = SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Draw subtle flower petals
          CustomPaint(
            size: Size(size, size),
            painter: DaisyPainter(
              isTarget: isTarget,
              scale: scale,
            ),
          ),
          // Center content
          Container(
            width: 38 * scale,
            height: 38 * scale,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isTarget 
                  ? [Colors.yellow.shade200, Colors.orange.shade300]
                  : [Colors.white, Colors.grey.shade50],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.blueGrey.withOpacity(0.2), 
                width: 1.5
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12 * scale,
                  offset: Offset(0, 4 * scale),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              letter,
              style: TextStyle(
                fontSize: ResponsiveHelper.responsiveFontSize(context, 20),
                fontWeight: FontWeight.bold,
                fontFamily: 'FredokaOne',
                color: isTarget ? Colors.orange.shade900 : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );

    if (isAnimate) {
      return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 300),
        curve: Curves.elasticOut,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: child,
          );
        },
        child: daisy,
      );
    }

    return daisy;
  }
}

class DaisyPainter extends CustomPainter {
  final bool isTarget;
  final double scale;
  
  DaisyPainter({
    this.isTarget = false,
    required this.scale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    final borderPaint = Paint()
      ..color = isTarget 
          ? Colors.orange.withOpacity(0.4) 
          : Colors.blueGrey.withOpacity(0.2)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final petalRadius = size.width * 0.28;

    // Draw 6 petals
    for (int i = 0; i < 6; i++) {
      final angle = (i * pi) / 3;
      final offset = Offset(
        center.dx + cos(angle) * (size.width * 0.22),
        center.dy + sin(angle) * (size.height * 0.22),
      );
      
      canvas.drawCircle(offset, petalRadius, paint);
      canvas.drawCircle(offset, petalRadius, borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
