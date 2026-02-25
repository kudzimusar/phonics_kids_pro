import 'package:flutter/material.dart';
import 'dart:math' as math;

class ColorCodeActivity extends StatefulWidget {
  final List<Map<String, String>> items; // e.g. [{'word': 'gym', 'answer': 'red'}, ...]

  const ColorCodeActivity({Key? key, required this.items}) : super(key: key);

  @override
  State<ColorCodeActivity> createState() => _ColorCodeActivityState();
}

class _ColorCodeActivityState extends State<ColorCodeActivity> {
  // Store current color state for each item. 0 = white, 1 = red, 2 = black
  late List<int> _colorStates;

  @override
  void initState() {
    super.initState();
    _colorStates = List.generate(widget.items.length, (_) => 0);
  }

  void _cycleColor(int index) {
    setState(() {
      _colorStates[index] = (_colorStates[index] + 1) % 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.0, // Square shape for ladybug
        crossAxisSpacing: 32,
        mainAxisSpacing: 32,
      ),
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        final item = widget.items[index];
        final word = item['word']!;
        
        Color fillColor = Colors.white;
        Color textColor = Colors.blueGrey.shade900;
        
        if (_colorStates[index] == 1) {
          fillColor = Colors.red.shade400; // Soft G
          textColor = Colors.white;
        } else if (_colorStates[index] == 2) {
          fillColor = Colors.black87; // Hard G
          textColor = Colors.white;
        }

        return GestureDetector(
          onTap: () => _cycleColor(index),
          child: CustomPaint(
            painter: LadybugPainter(fillColor: fillColor, strokeColor: Colors.blueGrey.shade900),
            child: Container(
              alignment: Alignment.center,
              child: Transform.rotate(
                angle: -0.15, // Slight tilt for the text matching the PDF
                child: Text(
                  word,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'FredokaOne',
                    color: textColor,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class LadybugPainter extends CustomPainter {
  final Color fillColor;
  final Color strokeColor;

  LadybugPainter({required this.fillColor, required this.strokeColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paintFill = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final paintStroke = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2.5;

    // Head
    final headRect = Rect.fromCircle(center: Offset(center.dx, center.dy - radius * 0.9), radius: radius * 0.4);
    canvas.drawArc(headRect, math.pi, math.pi, true, paintStroke);
    canvas.drawArc(headRect, math.pi, math.pi, true, paintFill);

    // Antennae
    canvas.drawLine(Offset(center.dx - radius * 0.2, center.dy - radius * 1.3), Offset(center.dx - radius * 0.3, center.dy - radius * 1.6), paintStroke);
    canvas.drawCircle(Offset(center.dx - radius * 0.3, center.dy - radius * 1.6), 4, Paint()..color = strokeColor);
    canvas.drawLine(Offset(center.dx + radius * 0.2, center.dy - radius * 1.3), Offset(center.dx + radius * 0.3, center.dy - radius * 1.6), paintStroke);
    canvas.drawCircle(Offset(center.dx + radius * 0.3, center.dy - radius * 1.6), 4, Paint()..color = strokeColor);

    // Legs
    for (int i = 0; i < 3; i++) {
      double yOffset = center.dy - radius * 0.3 + (i * radius * 0.5);
      // Left leg
      canvas.drawLine(Offset(center.dx - radius + 4, yOffset), Offset(center.dx - radius - 20, yOffset + 10), paintStroke);
      canvas.drawCircle(Offset(center.dx - radius - 20, yOffset + 10), 4, Paint()..color = strokeColor);
      // Right leg
      canvas.drawLine(Offset(center.dx + radius - 4, yOffset), Offset(center.dx + radius + 20, yOffset + 10), paintStroke);
      canvas.drawCircle(Offset(center.dx + radius + 20, yOffset + 10), 4, Paint()..color = strokeColor);
    }

    // Body Outline
    canvas.drawCircle(center, radius, paintFill);
    canvas.drawCircle(center, radius, paintStroke);

    // Inverted V wing split
    final path = Path();
    path.moveTo(center.dx, center.dy - radius);
    path.lineTo(center.dx - radius * 0.6, center.dy + radius * 0.8);
    path.moveTo(center.dx, center.dy - radius);
    path.lineTo(center.dx + radius * 0.6, center.dy + radius * 0.8);
    canvas.drawPath(path, paintStroke);

    // Wing dots
    final dotPaint = Paint()..color = strokeColor..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(center.dx - radius * 0.5, center.dy - radius * 0.3), 6, dotPaint);
    canvas.drawCircle(Offset(center.dx - radius * 0.7, center.dy + radius * 0.2), 6, dotPaint);
    canvas.drawCircle(Offset(center.dx - radius * 0.3, center.dy + radius * 0.5), 6, dotPaint);
    
    canvas.drawCircle(Offset(center.dx + radius * 0.5, center.dy - radius * 0.3), 6, dotPaint);
    canvas.drawCircle(Offset(center.dx + radius * 0.7, center.dy + radius * 0.2), 6, dotPaint);
    canvas.drawCircle(Offset(center.dx + radius * 0.3, center.dy + radius * 0.5), 6, dotPaint);
  }

  @override
  bool shouldRepaint(covariant LadybugPainter oldDelegate) {
    return oldDelegate.fillColor != fillColor || oldDelegate.strokeColor != strokeColor;
  }
}
