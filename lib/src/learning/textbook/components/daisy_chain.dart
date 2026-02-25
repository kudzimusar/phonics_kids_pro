import 'package:flutter/material.dart';
import 'dart:math';
import 'vector_graphic.dart';
import 'letter_drop_target.dart';

class DaisyChainRow extends StatefulWidget {
  final String icon;
  final List<String> letters; // '?' represents the blank/target letter
  final String targetLetter;

  const DaisyChainRow({
    Key? key,
    required this.icon,
    required this.letters,
    required this.targetLetter,
  }) : super(key: key);

  @override
  State<DaisyChainRow> createState() => _DaisyChainRowState();
}

class _DaisyChainRowState extends State<DaisyChainRow> {
  bool _isFilled = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Icon on the left
          SizedBox(
            width: 80,
            child: VectorGraphic(assetName: widget.icon, size: 64),
          ),
          const SizedBox(width: 32),

          // 2. Chained Daisies
          Expanded(
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: widget.letters.map((letter) {
                if (letter == '?') {
                  if (_isFilled) {
                    return DaisyShape(letter: widget.targetLetter, isTarget: true);
                  }
                  return LetterDropTarget(
                    correctLetter: widget.targetLetter,
                    onDropResult: (success, letterStr) {
                      if (success) {
                        setState(() => _isFilled = true);
                      }
                    },
                  );
                }
                return DaisyShape(letter: letter);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class DaisyShape extends StatelessWidget {
  final String letter;
  final bool isTarget;

  const DaisyShape({
    Key? key,
    required this.letter,
    this.isTarget = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Draw subtle flower petals
          CustomPaint(
            size: const Size(64, 64),
            painter: DaisyPainter(isTarget: isTarget),
          ),
          // Center content
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isTarget ? Colors.yellow.shade100 : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blueGrey.shade800, width: 2),
            ),
            alignment: Alignment.center,
            child: Text(
              letter,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'FredokaOne',
                color: isTarget ? Colors.orange.shade800 : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DaisyPainter extends CustomPainter {
  final bool isTarget;
  DaisyPainter({this.isTarget = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    final borderPaint = Paint()
      ..color = isTarget ? Colors.orange.shade300 : Colors.blueGrey.shade800
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final petalRadius = size.width * 0.25;

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
