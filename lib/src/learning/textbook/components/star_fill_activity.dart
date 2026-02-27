import 'package:flutter/material.dart';
import 'dart:math';

/// A27: Shooting Stars — fixed-direction star + ribbon tail
/// Star is always on the LEFT, sweeping ribbon tail goes to the RIGHT.
/// Matches the physical textbook layout exactly.
class StarFillActivity extends StatefulWidget {
  final List<Map<String, dynamic>> entries;

  const StarFillActivity({Key? key, required this.entries}) : super(key: key);

  @override
  State<StarFillActivity> createState() => _StarFillActivityState();
}

class _StarFillActivityState extends State<StarFillActivity> {
  final Map<int, TextEditingController> _controllers = {};
  final Map<int, bool> _correct = {};

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.entries.length; i++) {
      _controllers[i] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _checkAnswer(int index) {
    final entry = widget.entries[index];
    final answer = entry['answer'] as String;
    final input = _controllers[index]!.text.trim().toLowerCase();
    setState(() {
      _correct[index] = input == answer.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(widget.entries.length, (index) {
        final entry = widget.entries[index];
        final partial = entry['partial'] as String;
        final isCorrect = _correct[index] == true;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: SizedBox(
            height: 130,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // The painted star + ribbon tail
                Positioned.fill(
                  child: CustomPaint(
                    painter: ShootingStarPainter(isCorrect: isCorrect),
                  ),
                ),
                // Content overlay: partial text inside the star on the left
                // Input box inside the ribbon on the right
                Positioned.fill(
                  child: Row(
                    children: [
                      // Star zone: partial text
                      SizedBox(
                        width: 110,
                        child: Center(
                          child: Text(
                            partial,
                            style: TextStyle(
                              fontFamily: 'SassoonPrimary',
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                              color: isCorrect ? Colors.green.shade800 : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      // Ribbon zone: text input for the answer
                      Expanded(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 24.0, bottom: 8.0),
                            child: SizedBox(
                              width: 120,
                              child: TextField(
                                controller: _controllers[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'SassoonPrimary',
                                  fontSize: 38,
                                  fontWeight: FontWeight.bold,
                                  color: isCorrect ? Colors.green.shade700 : Colors.blue.shade700,
                                ),
                                decoration: InputDecoration(
                                  hintText: '___',
                                  hintStyle: TextStyle(
                                    color: Colors.blueGrey.shade300,
                                    fontSize: 32,
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: isCorrect ? Colors.green : Colors.blueGrey.shade300,
                                      width: 3,
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue, width: 3),
                                  ),
                                  counterText: '',
                                ),
                                maxLength: 4,
                                onChanged: (_) => _checkAnswer(index),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

/// Paints: [★]——/comet ribbon——>[✦ spike]
/// Star on the LEFT, ribbon sweeps to the RIGHT.
class ShootingStarPainter extends CustomPainter {
  final bool isCorrect;

  const ShootingStarPainter({this.isCorrect = false});

  @override
  void paint(Canvas canvas, Size size) {
    final fillColor = isCorrect ? Colors.green.shade100 : Colors.white;
    final borderColor = isCorrect ? Colors.green.shade400 : Colors.black87;

    final paint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    // ---- Draw the ribbon tail (sweeps from star to right with arrow spikes) ----
    // Star center is at cx=100, cy=size.height/2
    final double cy = size.height / 2;
    final double starCX = 90.0;
    final double tailStart = starCX + 10;   // where tail begins (right edge of star)
    final double tailEnd = size.width - 20; // where tail ends
    final double topY = cy - 28;
    final double botY = cy + 28;

    final tailPath = Path();
    // Top curve from star rightward
    tailPath.moveTo(tailStart, cy - 20);
    tailPath.quadraticBezierTo(size.width * 0.4, topY, tailEnd - 30, topY + 4);
    // Right spike cluster
    tailPath.lineTo(tailEnd, cy - 16);
    tailPath.lineTo(tailEnd - 20, cy);
    tailPath.lineTo(tailEnd, cy + 16);
    // Bottom curve back left to star
    tailPath.quadraticBezierTo(size.width * 0.4, botY, tailStart, cy + 20);
    tailPath.close();

    canvas.drawPath(tailPath, paint);
    canvas.drawPath(tailPath, borderPaint);

    // ---- Draw the 5-point star on the left ----
    final double cx = starCX;
    final double outerRadius = 52.0;
    final double innerRadius = 22.0;
    const int points = 5;
    const double startAngle = -pi / 2; // Top-pointing
    final double angleStep = (pi * 2) / points;

    final starPath = Path();
    for (int i = 0; i < points; i++) {
      final outerAngle = startAngle + i * angleStep;
      final innerAngle = outerAngle + angleStep / 2;

      final ox = cx + cos(outerAngle) * outerRadius;
      final oy = cy + sin(outerAngle) * outerRadius;
      final ix = cx + cos(innerAngle) * innerRadius;
      final iy = cy + sin(innerAngle) * innerRadius;

      if (i == 0) {
        starPath.moveTo(ox, oy);
      } else {
        starPath.lineTo(ox, oy);
      }
      starPath.lineTo(ix, iy);
    }
    starPath.close();

    canvas.drawPath(starPath, paint);
    canvas.drawPath(starPath, borderPaint);
  }

  @override
  bool shouldRepaint(covariant ShootingStarPainter oldDelegate) =>
      oldDelegate.isCorrect != isCorrect;
}
