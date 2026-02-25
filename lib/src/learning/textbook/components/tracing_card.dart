import 'package:flutter/material.dart';
import 'vector_graphic.dart';

class TracingCard extends StatelessWidget {
  final String icon;
  final String partialWord;
  final String position; // 'beginning' or 'end'
  final List<String> tracingOptions;

  const TracingCard({
    Key? key,
    required this.icon,
    required this.partialWord,
    required this.position,
    required this.tracingOptions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade300, width: 2),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Vector Graphic
          VectorGraphic(assetName: icon, size: 60),
          const SizedBox(height: 16),
          
          // 2. The Main Content Box (contains partial word and choices)
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blueGrey.shade100, width: 2),
                color: Colors.blueGrey.shade50,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Top part: the word with the missing blank
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (position == 'beginning') _buildBlankSpace(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          partialWord,
                          style: const TextStyle(
                            fontSize: 32,
                            fontFamily: 'FredokaOne',
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      if (position == 'end') _buildBlankSpace(),
                    ],
                  ),
                  
                  // Divider line
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Divider(color: Colors.blueGrey.shade200, thickness: 2),
                  ),

                  // Bottom part: The tracing options stacked vertically
                  _buildTraceOption(tracingOptions[0]),
                  _buildTraceOption(tracingOptions[1]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlankSpace() {
    return Container(
      width: 40,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade400, width: 2, style: BorderStyle.none),
        borderRadius: BorderRadius.circular(8),
      ),
      child: CustomPaint(
        painter: DashedBorderPainter(),
      ),
    );
  }

  Widget _buildTraceOption(String letter) {
    // In the real app, this would be a specialized tracing canvas widget.
    // For now, it displays a dashed/dotted letter to simulate 'tracing' mode.
    return Text(
      letter,
      style: const TextStyle(
        fontSize: 48,
        fontFamily: 'SassoonPrimary', // Prefer SassoonPrimary for tracing
        color: Colors.grey,
        fontWeight: FontWeight.w300,
        decorationStyle: TextDecorationStyle.dashed,
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashWidth = 5.0;
    const dashSpace = 5.0;

    // Draw bottom dashed line to represent an empty slot
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height),
        Offset(startX + dashWidth, size.height),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
