import 'package:flutter/material.dart';
import 'dart:math';

/// A32: Consonant Blend Band-Aids
/// Users drag from the blue dot on the band-aid to the matching word fragment.
/// The line is drawn in local Stack coordinates to avoid the globalToLocal scroll bug.
class MatchingConnectActivity extends StatefulWidget {
  final List<String> leftItems; // e.g., blends "sk", "sl"
  final List<Map<String, dynamic>> rightItems; // {'partial': 'unk', 'answer': 'sk', 'word': 'skunk'}

  const MatchingConnectActivity({
    Key? key,
    required this.leftItems,
    required this.rightItems,
  }) : super(key: key);

  @override
  State<MatchingConnectActivity> createState() => _MatchingConnectActivityState();
}

class _MatchingConnectActivityState extends State<MatchingConnectActivity> {
  // Key = Left Index -> Right Index
  final Map<int, int> _connections = {};

  // Active drag state
  int? _activeLeftIndex;
  Offset? _dragStartLocal; // Start position in Stack-local coords
  Offset? _currentDragLocal; // Current drag position in Stack-local coords

  // GlobalKeys to find positions
  late List<GlobalKey> _leftDotKeys;
  late List<GlobalKey> _rightDotKeys;

  // Key for the main Stack to convert global -> local coords
  final GlobalKey _stackKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _leftDotKeys = List.generate(widget.leftItems.length, (_) => GlobalKey());
    _rightDotKeys = List.generate(widget.rightItems.length, (_) => GlobalKey());
  }

  Offset? _globalToLocal(Offset global) {
    final box = _stackKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return null;
    return box.globalToLocal(global);
  }

  Offset? _getDotLocalCenter(GlobalKey key) {
    final box = key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return null;
    final globalCenter = box.localToGlobal(box.size.center(Offset.zero));
    return _globalToLocal(globalCenter);
  }

  void _onPanStart(DragStartDetails details, int leftIndex) {
    final localPos = _globalToLocal(details.globalPosition);
    setState(() {
      _activeLeftIndex = leftIndex;
      _dragStartLocal = _getDotLocalCenter(_leftDotKeys[leftIndex]);
      _currentDragLocal = localPos;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_activeLeftIndex != null) {
      final localPos = _globalToLocal(details.globalPosition);
      setState(() {
        _currentDragLocal = localPos;
      });
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (_activeLeftIndex != null && _currentDragLocal != null) {
      for (int i = 0; i < _rightDotKeys.length; i++) {
        final center = _getDotLocalCenter(_rightDotKeys[i]);
        if (center != null) {
          final dist = (_currentDragLocal! - center).distance;
          if (dist < 50) {
            final answer = widget.rightItems[i]['answer'] as String;
            if (widget.leftItems[_activeLeftIndex!] == answer) {
              setState(() {
                _connections[_activeLeftIndex!] = i;
              });
            }
            break;
          }
        }
      }
    }
    setState(() {
      _activeLeftIndex = null;
      _dragStartLocal = null;
      _currentDragLocal = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: _stackKey,
      children: [
        // Content layer
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left: Band-Aids
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: List.generate(widget.leftItems.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: _buildBandAid(index, widget.leftItems[index]),
                  );
                }),
              ),
              // Right: Word Fragments
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: List.generate(widget.rightItems.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: _buildWordFragment(index, widget.rightItems[index]),
                  );
                }),
              ),
            ],
          ),
        ),

        // Drawing layer (on top, no pointer events intercepted)
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: ConnectionPainter(
                connections: _connections,
                activeStart: _dragStartLocal,
                activeCurrent: _currentDragLocal,
                leftDotKeys: _leftDotKeys,
                rightDotKeys: _rightDotKeys,
                stackKey: _stackKey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBandAid(int index, String blend) {
    final isConnected = _connections.containsKey(index);

    return GestureDetector(
      onPanStart: isConnected ? null : (d) => _onPanStart(d, index),
      onPanUpdate: isConnected ? null : _onPanUpdate,
      onPanEnd: isConnected ? null : _onPanEnd,
      child: Opacity(
        opacity: isConnected ? 0.55 : 1.0,
        child: SizedBox(
          width: 130,
          height: 60,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Band-aid body
              CustomPaint(
                size: const Size(130, 60),
                painter: BandAidPainter(isConnected: isConnected),
              ),
              // Blend text in center
              Positioned.fill(
                child: Center(
                  child: Text(
                    blend,
                    style: const TextStyle(
                      fontSize: 30,
                      fontFamily: 'FredokaOne',
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Blue drag dot on the right side
              Positioned(
                right: -10,
                top: 20,
                child: Container(
                  key: _leftDotKeys[index],
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade600,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.5),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWordFragment(int index, Map<String, dynamic> item) {
    final isConnected = _connections.containsValue(index);
    final partial = item['partial'] as String;
    final answer = item['answer'] as String;
    final word = item['word'] as String? ?? '';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Dot on the left
        Container(
          key: _rightDotKeys[index],
          width: 22,
          height: 22,
          margin: const EdgeInsets.only(right: 14),
          decoration: BoxDecoration(
            color: isConnected ? Colors.green.shade500 : Colors.grey.shade300,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
        ),
        // Word box
        Container(
          width: 160,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isConnected ? Colors.green.shade400 : Colors.pinkAccent.shade100,
              width: 2.5,
            ),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))
            ],
          ),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: isConnected
              ? RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 30,
                      fontFamily: 'FredokaOne',
                    ),
                    children: [
                      TextSpan(
                        text: answer,
                        style: const TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: word.substring(answer.length),
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),
                )
              : RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 28,
                      fontFamily: 'FredokaOne',
                      color: Colors.black87,
                    ),
                    children: [
                      TextSpan(
                        text: '__ ',
                        style: const TextStyle(
                          color: Color(0xFFE91E63),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: partial),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}

/// Custom band-aid painter — authentic pill shape with cross pattern on each end
class BandAidPainter extends CustomPainter {
  final bool isConnected;

  const BandAidPainter({this.isConnected = false});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final skinColor = isConnected ? const Color(0xFFBCAAA4) : const Color(0xFFFFCC80);
    final borderColor = isConnected ? const Color(0xFF8D6E63) : const Color(0xFFF57C00);

    // Main pill body
    final bodyPaint = Paint()..color = skinColor;
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final rrect = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, w, h), const Radius.circular(30));
    canvas.drawRRect(rrect, bodyPaint);
    canvas.drawRRect(rrect, borderPaint);

    // Center white pad
    final padPaint = Paint()..color = Colors.white.withOpacity(0.85);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(w / 2, h / 2), width: 44, height: 44),
        const Radius.circular(6),
      ),
      padPaint,
    );

    // Cross pattern on each end
    _drawCrossPattern(canvas, Offset(22, h / 2), borderColor.withOpacity(0.5));
    _drawCrossPattern(canvas, Offset(w - 22, h / 2), borderColor.withOpacity(0.5));
  }

  void _drawCrossPattern(Canvas canvas, Offset center, Color color) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    // H lines
    for (double y = center.dy - 8; y <= center.dy + 8; y += 8) {
      canvas.drawLine(Offset(center.dx - 12, y), Offset(center.dx + 12, y), p);
    }
    // V lines
    for (double x = center.dx - 8; x <= center.dx + 8; x += 8) {
      canvas.drawLine(Offset(x, center.dy - 12), Offset(x, center.dy + 12), p);
    }
  }

  @override
  bool shouldRepaint(covariant BandAidPainter old) => old.isConnected != isConnected;
}

/// Paints connection lines in local Stack coordinates (no scroll offset bug)
class ConnectionPainter extends CustomPainter {
  final Map<int, int> connections;
  final Offset? activeStart;
  final Offset? activeCurrent;
  final List<GlobalKey> leftDotKeys;
  final List<GlobalKey> rightDotKeys;
  final GlobalKey stackKey;

  ConnectionPainter({
    required this.connections,
    required this.activeStart,
    required this.activeCurrent,
    required this.leftDotKeys,
    required this.rightDotKeys,
    required this.stackKey,
  });

  Offset? _getLocalCenter(GlobalKey key) {
    final box = key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return null;
    final globalCenter = box.localToGlobal(box.size.center(Offset.zero));
    final stackBox = stackKey.currentContext?.findRenderObject() as RenderBox?;
    return stackBox?.globalToLocal(globalCenter);
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Draw confirmed connections
    connections.forEach((leftIdx, rightIdx) {
      final start = _getLocalCenter(leftDotKeys[leftIdx]);
      final end = _getLocalCenter(rightDotKeys[rightIdx]);
      if (start != null && end != null) {
        _drawLine(canvas, start, end, Colors.green.shade500, 5);
      }
    });

    // Draw active drag line
    if (activeStart != null && activeCurrent != null) {
      _drawLine(canvas, activeStart!, activeCurrent!, Colors.blue.shade300.withOpacity(0.7), 4);
    }
  }

  void _drawLine(Canvas canvas, Offset start, Offset end, Color color, double strokeWidth) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(start.dx, start.dy);
    final controlX = (start.dx + end.dx) / 2;
    path.cubicTo(
      controlX, start.dy,
      controlX, end.dy,
      end.dx, end.dy,
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant ConnectionPainter old) => true;
}
