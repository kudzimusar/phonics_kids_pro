import 'package:flutter/material.dart';
import 'dart:math';
import '../utils/responsive_helper.dart';

class StarFillActivity extends StatefulWidget {
  final List<Map<String, dynamic>> entries;

  const StarFillActivity({Key? key, required this.entries}) : super(key: key);

  @override
  State<StarFillActivity> createState() => _StarFillActivityState();
}

class _StarFillActivityState extends State<StarFillActivity> {
  final Map<int, TextEditingController> _controllers = {};

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

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveHelper.getResponsiveGridCount(
          context: context, 
          mobile: 1, 
          tablet: 2, 
          desktop: 2
        ),
        childAspectRatio: ResponsiveHelper.isMobile(context) ? 2.8 : 2.5,
        crossAxisSpacing: 32,
        mainAxisSpacing: 32,
      ),
      itemCount: widget.entries.length,
      itemBuilder: (context, index) {
        final entry = widget.entries[index];
        final partial = entry['partial'] as String;

        return SizedBox(
          height: 140,
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: ShootingStarPainter(),
                ),
              ),
              Positioned.fill(
                child: Row(
                  children: [
                    SizedBox(
                      width: 140, // Match the star width
                      child: Center(
                        child: Text(
                          partial,
                          style: const TextStyle(
                            fontFamily: 'SassoonPrimary',
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 50.0, left: 10.0, bottom: 20.0), // pad for spikes and fit curve
                          child: SizedBox(
                            width: 100,
                            child: TextField(
                              controller: _controllers[index],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'SassoonPrimary',
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blueGrey.shade300, width: 4),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blueAccent, width: 4),
                                ),
                              ),
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
        );
      },
    );
  }
}

class ShootingStarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final borderPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Draw tail
    final tailPath = Path();
    tailPath.moveTo(70, size.height * 0.25); // start near top of star
    tailPath.quadraticBezierTo(size.width * 0.5, 0, size.width - 20, 20); // Top curve
    // Spikes on the right
    tailPath.lineTo(size.width - 40, size.height * 0.35);
    tailPath.lineTo(size.width - 10, size.height * 0.5);
    tailPath.lineTo(size.width - 40, size.height * 0.65);
    tailPath.lineTo(size.width - 20, size.height - 20);
    
    // Bottom curve
    tailPath.quadraticBezierTo(size.width * 0.5, size.height, 70, size.height * 0.75);
    tailPath.close();

    canvas.drawPath(tailPath, paint);
    canvas.drawPath(tailPath, borderPaint);

    // Draw 5-point star
    final starPath = Path();
    final double cx = 70;
    final double cy = size.height / 2;
    final double outerRadius = 60;
    final double innerRadius = 26;
    final int points = 5;
    final double angle = (pi * 2) / points;

    starPath.moveTo(cx, cy - outerRadius);
    for (int i = 0; i < points; i++) {
      starPath.lineTo(cx + cos(_angle(i, angle)) * outerRadius,
          cy + sin(_angle(i, angle)) * outerRadius);
      starPath.lineTo(cx + cos(_angle(i, angle) + angle / 2) * innerRadius,
          cy + sin(_angle(i, angle) + angle / 2) * innerRadius);
    }
    starPath.close();

    canvas.drawPath(starPath, paint);
    canvas.drawPath(starPath, borderPaint);
  }

  double _angle(int index, double angle) {
    return -pi / 2 + index * angle;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
