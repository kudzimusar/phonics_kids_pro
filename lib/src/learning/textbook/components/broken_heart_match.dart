import 'package:flutter/material.dart';
import 'dart:math' as math;

/// A37: Broken Hearts — authentic gray half-heart shapes with jagged break.
/// Left side = smooth left half-heart (contains diphthong).
/// Right side = smooth right half-heart (contains incomplete word).
/// Drawn connection lines connect matched pairs on the canvas.
///
/// User taps left then right to connect. Lines drawn via CustomPaint overlay.
class BrokenHeartMatch extends StatefulWidget {
  final List<String> leftSide;
  final List<Map<String, dynamic>> rightSide;

  const BrokenHeartMatch({
    Key? key,
    required this.leftSide,
    required this.rightSide,
  }) : super(key: key);

  @override
  State<BrokenHeartMatch> createState() => _BrokenHeartMatchState();
}

class _BrokenHeartMatchState extends State<BrokenHeartMatch> {
  String? _selectedLeft;
  final Map<String, String> _matches = {}; // rightPartial -> leftDiphthong
  final Map<String, bool> _correct = {};
  final Map<String, GlobalKey> _leftKeys = {};
  final Map<String, GlobalKey> _rightKeys = {};

  @override
  void initState() {
    super.initState();
    for (final d in widget.leftSide) {
      _leftKeys[d] = GlobalKey();
    }
    for (final r in widget.rightSide) {
      _rightKeys[r['partial'] as String] = GlobalKey();
    }
  }

  Offset? _getKeyOffset(GlobalKey key, {bool center = true}) {
    final ctx = key.currentContext;
    if (ctx == null) return null;
    final rb = ctx.findRenderObject() as RenderBox?;
    if (rb == null) return null;
    final pos = rb.localToGlobal(Offset.zero);
    if (center) return pos + Offset(rb.size.width / 2, rb.size.height / 2);
    return pos;
  }

  void _onTapLeft(String diphthong) {
    setState(() => _selectedLeft = _selectedLeft == diphthong ? null : diphthong);
  }

  void _onTapRight(Map<String, dynamic> item) {
    if (_selectedLeft == null) return;
    final partial = item['partial'] as String;
    final answer = item['answer'] as String;
    if (_matches.containsKey(partial)) return;
    setState(() {
      _matches.removeWhere((_, v) => v == _selectedLeft);
      _matches[partial] = _selectedLeft!;
      _correct[partial] = (_selectedLeft == answer);
      _selectedLeft = null;
    });
  }

  void _reset() => setState(() {
        _matches.clear();
        _correct.clear();
        _selectedLeft = null;
      });

  @override
  Widget build(BuildContext context) {
    final allCorrect = _matches.length == widget.rightSide.length &&
        _correct.values.every((v) => v);

    return Column(
      children: [
        if (allCorrect)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Text(
              '💙 All hearts matched!',
              style: TextStyle(fontFamily: 'SassoonPrimary', fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold),
            ),
          ),

        // Main layout: left column | center connector | right column
        // CustomPaint overlay for the drawn connection lines
        LayoutBuilder(
          builder: (ctx, constraints) {
            return CustomPaint(
              foregroundPainter: _HeartLinePainter(
                matches: _matches,
                leftKeys: _leftKeys,
                rightKeys: _rightKeys,
                correct: _correct,
                context: ctx,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // LEFT COLUMN — diphthong half-hearts
                  Expanded(
                    child: Column(
                      children: widget.leftSide.map((diph) {
                        final isSelected = _selectedLeft == diph;
                        final isUsed = _matches.values.contains(diph);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: GestureDetector(
                            key: _leftKeys[diph],
                            onTap: () => _onTapLeft(diph),
                            child: _LeftHalfHeart(
                              text: diph,
                              isSelected: isSelected,
                              isUsed: isUsed,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  // RIGHT COLUMN — incomplete word half-hearts
                  Expanded(
                    child: Column(
                      children: widget.rightSide.map((item) {
                        final partial = item['partial'] as String;
                        final isMatched = _matches.containsKey(partial);
                        final isCorrect = _correct[partial] ?? false;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: GestureDetector(
                            key: _rightKeys[partial],
                            onTap: () => _onTapRight(item),
                            child: _RightHalfHeart(
                              text: isMatched && isCorrect
                                  ? item['word'] as String
                                  : partial,
                              isMatched: isMatched,
                              isCorrect: isCorrect,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          },
        ),

        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: _reset,
          icon: const Icon(Icons.refresh, color: Colors.blueGrey),
          label: const Text('Reset', style: TextStyle(fontFamily: 'SassoonPrimary', fontSize: 18, color: Colors.blueGrey)),
        ),
      ],
    );
  }
}

/// Paints diagonal connection lines between matched left/right hearts.
class _HeartLinePainter extends CustomPainter {
  final Map<String, String> matches;
  final Map<String, GlobalKey> leftKeys;
  final Map<String, GlobalKey> rightKeys;
  final Map<String, bool> correct;
  final BuildContext context;

  _HeartLinePainter({
    required this.matches,
    required this.leftKeys,
    required this.rightKeys,
    required this.correct,
    required this.context,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final ro = (context.findRenderObject() as RenderBox?);
    if (ro == null) return;

    for (final entry in matches.entries) {
      final partial = entry.key;
      final diph = entry.value;
      final leftKey = leftKeys[diph];
      final rightKey = rightKeys[partial];
      if (leftKey == null || rightKey == null) continue;

      final leftCtx = leftKey.currentContext;
      final rightCtx = rightKey.currentContext;
      if (leftCtx == null || rightCtx == null) continue;

      final leftRb = leftCtx.findRenderObject() as RenderBox?;
      final rightRb = rightCtx.findRenderObject() as RenderBox?;
      if (leftRb == null || rightRb == null) continue;

      final leftGlobal = leftRb.localToGlobal(Offset(leftRb.size.width, leftRb.size.height / 2));
      final rightGlobal = rightRb.localToGlobal(Offset(0, rightRb.size.height / 2));
      final localLeft = ro.globalToLocal(leftGlobal);
      final localRight = ro.globalToLocal(rightGlobal);

      paint.color = correct[partial] == true ? Colors.green : Colors.black87;
      canvas.drawLine(localLeft, localRight, paint);
    }
  }

  @override
  bool shouldRepaint(_HeartLinePainter old) => true;
}

/// Left half of a broken heart — smooth circular left, jagged right edge.
class _LeftHalfHeart extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isUsed;

  const _LeftHalfHeart({required this.text, this.isSelected = false, this.isUsed = false});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(130, 130),
      painter: _LeftHeartPainter(
        isSelected: isSelected,
        isUsed: isUsed,
      ),
      child: SizedBox(
        width: 130,
        height: 130,
        child: Align(
          alignment: const Alignment(-0.35, 0.1),
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'SassoonPrimary',
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : (isUsed ? Colors.white70 : Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

/// Right half of a broken heart — jagged left edge, smooth circular right.
class _RightHalfHeart extends StatelessWidget {
  final String text;
  final bool isMatched;
  final bool isCorrect;

  const _RightHalfHeart({required this.text, this.isMatched = false, this.isCorrect = false});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(130, 130),
      painter: _RightHeartPainter(
        isMatched: isMatched,
        isCorrect: isCorrect,
      ),
      child: SizedBox(
        width: 130,
        height: 130,
        child: Align(
          alignment: const Alignment(0.3, 0.1),
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'SassoonPrimary',
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

/// Paints the left half of a broken heart (smooth left, jagged right edge).
class _LeftHeartPainter extends CustomPainter {
  final bool isSelected;
  final bool isUsed;
  const _LeftHeartPainter({this.isSelected = false, this.isUsed = false});

  @override
  void paint(Canvas canvas, Size size) {
    final color = isSelected
        ? const Color(0xFF546E7A)
        : isUsed
            ? const Color(0xFF607D8B)
            : const Color(0xFF78909C);
    final paint = Paint()..color = color..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    // Full heart path (left half only — clip to left)
    final path = Path();

    // Heart top-left bump center: (w*0.35, h*0.28)
    // Heart top-right bump center: (w*0.70, h*0.28) — but we only take left half

    // Draw left half heart shape:
    // Start at center bottom tip
    path.moveTo(w * 0.5, h * 0.88);
    // Curve up left side
    path.cubicTo(
      w * 0.1, h * 0.65,
      -w * 0.1, h * 0.45,
      w * 0.15, h * 0.22,
    );
    // Top-left bump
    path.cubicTo(
      w * 0.22, h * 0.05,
      w * 0.45, h * 0.05,
      w * 0.5, h * 0.28,
    );

    // Now the jagged break edge going down from (w*0.5, h*0.28) to (w*0.5, h*0.88)
    path.lineTo(w * 0.55, h * 0.38);
    path.lineTo(w * 0.45, h * 0.48);
    path.lineTo(w * 0.58, h * 0.58);
    path.lineTo(w * 0.48, h * 0.66);
    path.lineTo(w * 0.55, h * 0.76);
    path.lineTo(w * 0.5, h * 0.88);

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_LeftHeartPainter old) => old.isSelected != isSelected || old.isUsed != isUsed;
}

/// Paints the right half of a broken heart (jagged left, smooth right).
class _RightHeartPainter extends CustomPainter {
  final bool isMatched;
  final bool isCorrect;
  const _RightHeartPainter({this.isMatched = false, this.isCorrect = false});

  @override
  void paint(Canvas canvas, Size size) {
    final color = isCorrect
        ? const Color(0xFF455A64)
        : isMatched
            ? const Color(0xFFBF360C).withOpacity(0.7)
            : const Color(0xFF78909C);
    final paint = Paint()..color = color..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    // Right half heart with jagged left edge
    final path = Path();

    // Start at center bottom tip
    path.moveTo(w * 0.5, h * 0.88);

    // Jagged break edge going UP from bottom to top
    path.lineTo(w * 0.45, h * 0.76);
    path.lineTo(w * 0.55, h * 0.66);
    path.lineTo(w * 0.42, h * 0.58);
    path.lineTo(w * 0.52, h * 0.48);
    path.lineTo(w * 0.45, h * 0.38);
    path.lineTo(w * 0.5, h * 0.28);

    // Top-right bump
    path.cubicTo(
      w * 0.55, h * 0.05,
      w * 0.78, h * 0.05,
      w * 0.85, h * 0.22,
    );
    // Curve down right side to bottom tip
    path.cubicTo(
      w * 1.1, h * 0.45,
      w * 0.9, h * 0.65,
      w * 0.5, h * 0.88,
    );

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_RightHeartPainter old) => old.isMatched != isMatched || old.isCorrect != isCorrect;
}
