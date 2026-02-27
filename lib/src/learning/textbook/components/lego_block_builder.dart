import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'vector_graphic.dart';

/// A38: Build the Word — authentic lego-brick blocks.
/// Each brick is drawn with CustomPainter (rectangle body + 2 stud bumps on top).
/// Given blocks have bold letters. The blank block is empty with a dashed border.
/// User taps the blank block → keyboard pops up → type the diphthong → check.
/// Images are shown large beside each row.
class LegoBlockBuilder extends StatefulWidget {
  final List<Map<String, dynamic>> groups;

  const LegoBlockBuilder({Key? key, required this.groups}) : super(key: key);

  @override
  State<LegoBlockBuilder> createState() => _LegoBlockBuilderState();
}

class _LegoBlockBuilderState extends State<LegoBlockBuilder> {
  late final List<TextEditingController> _controllers;
  late final List<bool?> _results;
  int? _focusedIndex;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.groups.length, (_) => TextEditingController());
    _results = List.generate(widget.groups.length, (_) => null);
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    super.dispose();
  }

  void _check(int i) {
    final answer = widget.groups[i]['answer'] as String;
    setState(() {
      _results[i] = _controllers[i].text.toLowerCase().trim() == answer.toLowerCase();
      _focusedIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: widget.groups.asMap().entries.map((entry) {
        final i = entry.key;
        final group = entry.value;
        final given = List<String>.from(group['given'] ?? []);
        final given2 = List<String>.from(group['given2'] ?? []);
        final imageId = group['imageId'] as String;
        final answer = group['answer'] as String;
        final result = _results[i];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left image — large, no container
              VectorGraphic(assetName: imageId, size: 76),
              const SizedBox(width: 20),

              // Brick row
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 6,
                children: [
                  // Pre blocks (given)
                  ...given.map((g) => _LegoBrick(
                    label: g,
                    width: _brickWidth(g),
                    color: const Color(0xFF37474F),
                    textColor: Colors.white,
                  )),

                  // Blank dashed brick
                  if (result == null)
                    _BlankLegoBrick(
                      width: _brickWidth(answer),
                      isFocused: _focusedIndex == i,
                      controller: _controllers[i],
                      onTap: () => setState(() => _focusedIndex = i),
                      onSubmitted: (_) => _check(i),
                      onChanged: (_) => setState(() {}),
                    )
                  else
                    _LegoBrick(
                      label: answer,
                      width: _brickWidth(answer),
                      color: result! ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
                      textColor: Colors.white,
                    ),

                  // Post blocks (given2)
                  ...given2.map((g) => _LegoBrick(
                    label: g,
                    width: _brickWidth(g),
                    color: const Color(0xFF37474F),
                    textColor: Colors.white,
                  )),
                ],
              ),

              const SizedBox(width: 16),

              // Check / result
              if (result == null && _controllers[i].text.isNotEmpty)
                GestureDetector(
                  onTap: () => _check(i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade700,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('✓', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                )
              else if (result != null)
                Icon(
                  result! ? Icons.check_circle : Icons.cancel,
                  color: result! ? Colors.green : Colors.red,
                  size: 32,
                )
              else
                const SizedBox(width: 52),
            ],
          ),
        );
      }).toList(),
    );
  }

  double _brickWidth(String text) => (text.length * 22.0 + 32).clamp(60.0, 120.0);
}

/// A single filled lego brick with 2 stud bumps on top.
class _LegoBrick extends StatelessWidget {
  final String label;
  final double width;
  final Color color;
  final Color textColor;

  const _LegoBrick({
    required this.label,
    required this.width,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BrickPainter(color: color),
      child: SizedBox(
        width: width,
        height: 72,
        child: Align(
          alignment: const Alignment(0, 0.4),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'SassoonPrimary',
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}

/// The blank lego brick with dashed outline. Contains a TextField.
class _BlankLegoBrick extends StatelessWidget {
  final double width;
  final bool isFocused;
  final TextEditingController controller;
  final VoidCallback onTap;
  final ValueChanged<String> onSubmitted;
  final ValueChanged<String> onChanged;

  const _BlankLegoBrick({
    required this.width,
    required this.isFocused,
    required this.controller,
    required this.onTap,
    required this.onSubmitted,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: _BrickPainter(
          color: Colors.transparent,
          strokeColor: const Color(0xFF546E7A),
          dashed: true,
        ),
        child: SizedBox(
          width: width,
          height: 72,
          child: Align(
            alignment: const Alignment(0, 0.4),
            child: SizedBox(
              width: width - 12,
              child: TextField(
                controller: controller,
                onTap: onTap,
                onSubmitted: onSubmitted,
                onChanged: onChanged,
                textAlign: TextAlign.center,
                maxLength: 4,
                autofocus: isFocused,
                decoration: const InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                  hintText: '?',
                  hintStyle: TextStyle(fontSize: 24, color: Color(0xFF90A4AE)),
                ),
                style: const TextStyle(
                  fontFamily: 'SassoonPrimary',
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF37474F),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// CustomPainter for the lego brick shape — body + 2 rounded stud bumps on top.
class _BrickPainter extends CustomPainter {
  final Color color;
  final Color strokeColor;
  final bool dashed;

  const _BrickPainter({
    this.color = const Color(0xFF37474F),
    this.strokeColor = Colors.transparent,
    this.dashed = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bodyPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = strokeColor == Colors.transparent ? color.withOpacity(0.6) : strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    const studH = 12.0;
    const studR = 9.0;
    const bodyTop = studH;

    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, bodyTop, size.width, size.height - bodyTop),
      const Radius.circular(6),
    );

    if (dashed) {
      // Draw dashed body border
      _drawDashedRRect(canvas, bodyRect, strokePaint);
    } else {
      canvas.drawRRect(bodyRect, bodyPaint);
      canvas.drawRRect(bodyRect, strokePaint..color = color.withOpacity(0.5));
    }

    // Draw 2 stud bumps
    final studPaint = Paint()
      ..color = color == Colors.transparent ? const Color(0xFF78909C) : color
      ..style = dashed ? PaintingStyle.stroke : PaintingStyle.fill
      ..strokeWidth = 2.5;

    final offset1 = Offset(size.width * 0.3, studH / 2);
    final offset2 = Offset(size.width * 0.7, studH / 2);

    if (dashed) {
      _drawDashedCircle(canvas, offset1, studR, strokePaint);
      _drawDashedCircle(canvas, offset2, studR, strokePaint);
    } else {
      canvas.drawCircle(offset1, studR, studPaint);
      canvas.drawCircle(offset2, studR, studPaint);
    }
  }

  void _drawDashedRRect(Canvas canvas, RRect rrect, Paint paint) {
    // Simplified: just draw the rect without dashes for now but with dotted look
    final p = Paint()
      ..color = paint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawRRect(rrect, p);
  }

  void _drawDashedCircle(Canvas canvas, Offset center, double radius, Paint paint) {
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(_BrickPainter old) =>
      old.color != color || old.dashed != dashed;
}
