import 'package:flutter/material.dart';

/// FingerTraceCanvas — a transparent drawing layer that lets users
/// "trace" letters or blends using their finger or mouse.
/// 
/// Usage:
/// Wrap any text with this widget and the user can draw paths over it.
/// The drawn paths are rendered as a semi-transparent ink color over the text.
class FingerTraceCanvas extends StatefulWidget {
  /// The child widget to draw over (e.g., a large faded letter or diphthong)
  final Widget child;

  /// Ink color for the tracing strokes
  final Color inkColor;

  /// Stroke width for tracing
  final double strokeWidth;

  /// If true, shows a "Clear" button to reset the trace
  final bool showClearButton;

  const FingerTraceCanvas({
    Key? key,
    required this.child,
    this.inkColor = const Color(0xFF1565C0), // Deep blue by default
    this.strokeWidth = 14.0,
    this.showClearButton = true,
  }) : super(key: key);

  @override
  State<FingerTraceCanvas> createState() => _FingerTraceCanvasState();
}

class _FingerTraceCanvasState extends State<FingerTraceCanvas> {
  // Each path is a list of points (one finger drag = one sublist)
  final List<List<Offset>> _strokes = [];
  List<Offset> _currentStroke = [];

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _currentStroke = [details.localPosition];
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _currentStroke.add(details.localPosition);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_currentStroke.isNotEmpty) {
      setState(() {
        _strokes.add(List.from(_currentStroke));
        _currentStroke = [];
      });
    }
  }

  void _clear() {
    setState(() {
      _strokes.clear();
      _currentStroke = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Child (the faded letter or word to trace over)
        widget.child,

        // Drawing layer
        Positioned.fill(
          child: GestureDetector(
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
            child: CustomPaint(
              painter: _StrokePainter(
                strokes: _strokes,
                currentStroke: _currentStroke,
                color: widget.inkColor,
                strokeWidth: widget.strokeWidth,
              ),
            ),
          ),
        ),

        // Clear button
        if (widget.showClearButton && _strokes.isNotEmpty)
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: _clear,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.shade400.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '✕ clear',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _StrokePainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final List<Offset> currentStroke;
  final Color color;
  final double strokeWidth;

  const _StrokePainter({
    required this.strokes,
    required this.currentStroke,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.6)
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    // Draw completed strokes
    for (final stroke in strokes) {
      _drawStroke(canvas, stroke, paint);
    }

    // Draw current stroke in progress
    if (currentStroke.isNotEmpty) {
      paint.color = color.withOpacity(0.8);
      _drawStroke(canvas, currentStroke, paint);
    }
  }

  void _drawStroke(Canvas canvas, List<Offset> points, Paint paint) {
    if (points.isEmpty) return;
    if (points.length == 1) {
      canvas.drawCircle(points.first, paint.strokeWidth / 2, paint);
      return;
    }
    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      // Smooth curves between points using quadratic bezier
      if (i + 1 < points.length) {
        final midX = (points[i].dx + points[i + 1].dx) / 2;
        final midY = (points[i].dy + points[i + 1].dy) / 2;
        path.quadraticBezierTo(points[i].dx, points[i].dy, midX, midY);
      } else {
        path.lineTo(points[i].dx, points[i].dy);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _StrokePainter old) => true;
}
