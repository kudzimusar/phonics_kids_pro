import 'package:flutter/material.dart';

class MatchingConnectActivity extends StatefulWidget {
  final List<String> leftItems; // e.g., blends "sk", "sl"
  final List<Map<String, dynamic>> rightItems; // e.g., {'partial': 'unk', 'answer': 'sk', 'word': 'skunk'}

  const MatchingConnectActivity({
    Key? key,
    required this.leftItems,
    required this.rightItems,
  }) : super(key: key);

  @override
  State<MatchingConnectActivity> createState() => _MatchingConnectActivityState();
}

class _MatchingConnectActivityState extends State<MatchingConnectActivity> {
  // Key = Left Item Index, Value = Right Item Index
  final Map<int, int> _connections = {};
  
  // Track active drag
  int? _activeLeftIndex;
  Offset? _currentDragPosition;
  
  // GlobalKeys to find positions of the connect points
  late List<GlobalKey> _leftKeys;
  late List<GlobalKey> _rightKeys;

  @override
  void initState() {
    super.initState();
    _leftKeys = List.generate(widget.leftItems.length, (_) => GlobalKey());
    _rightKeys = List.generate(widget.rightItems.length, (_) => GlobalKey());
  }

  void _onPanStart(DragStartDetails details, int leftIndex) {
    setState(() {
      _activeLeftIndex = leftIndex;
      _currentDragPosition = details.globalPosition;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_activeLeftIndex != null) {
      setState(() {
        _currentDragPosition = details.globalPosition;
      });
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (_activeLeftIndex != null && _currentDragPosition != null) {
      // Check if dropped near a right item
      for (int i = 0; i < _rightKeys.length; i++) {
        final key = _rightKeys[i];
        final RenderBox? box = key.currentContext?.findRenderObject() as RenderBox?;
        if (box != null) {
          final offset = box.localToGlobal(Offset.zero);
          final rect = offset & box.size;
          
          // Add some padding to the hit area
          if (rect.inflate(30).contains(_currentDragPosition!)) {
            // Found a match attempt!
            final answerStr = widget.rightItems[i]['answer'] as String;
            if (widget.leftItems[_activeLeftIndex!] == answerStr) {
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
      _currentDragPosition = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Content Layer
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left Column (Band-Aids)
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(widget.leftItems.length, (index) {
                  return _buildLeftItem(index, widget.leftItems[index]);
                }),
              ),
              
              // Right Column (Broken Words)
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(widget.rightItems.length, (index) {
                  return _buildRightItem(index, widget.rightItems[index]);
                }),
              ),
            ],
          ),
        ),

        // Drawing Layer
        IgnorePointer(
          child: CustomPaint(
            size: Size.infinite,
            painter: ConnectionPainter(
              connections: _connections,
              activeLeftIndex: _activeLeftIndex,
              currentDragPosition: _currentDragPosition,
              leftKeys: _leftKeys,
              rightKeys: _rightKeys,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLeftItem(int index, String text) {
    final isConnected = _connections.containsKey(index);
    
    return GestureDetector(
      onPanStart: isConnected ? null : (details) => _onPanStart(details, index),
      onPanUpdate: isConnected ? null : _onPanUpdate,
      onPanEnd: isConnected ? null : _onPanEnd,
      child: Opacity(
        opacity: isConnected ? 0.6 : 1.0,
        child: Container(
          width: 120,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.orange.shade200, // Band-aid color
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.brown.shade300, width: 2),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2, 2))
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // Inner pad of bandaid
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 28,
                  fontFamily: 'SassoonPrimary',
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Connection Point Anchor
              Positioned(
                right: -10,
                child: Container(
                  key: _leftKeys[index],
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRightItem(int index, Map<String, dynamic> item) {
    final isConnected = _connections.containsValue(index);
    final partialText = item['partial'] as String;
    // Replace underscores with underlines for display
    final displayText = partialText.replaceAll('_', '   ').trimLeft();

    return Row(
      children: [
        // Connection Point Anchor
        Container(
          key: _rightKeys[index],
          width: 20,
          height: 20,
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: isConnected ? Colors.green : Colors.grey.shade300,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
        ),
        Container(
          width: 140,
          height: 60,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isConnected ? Colors.green : Colors.pinkAccent.shade100,
              width: 2,
            ),
          ),
          child: isConnected 
            ? RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 32,
                    fontFamily: 'FredokaOne',
                    color: Colors.black87,
                  ),
                  children: [
                    TextSpan(
                      text: item['answer'], 
                      style: const TextStyle(color: Colors.green)
                    ),
                    TextSpan(
                      text: partialText.replaceAll('_', ''),
                    ),
                  ]
                )
              )
            : Text(
                "__ $displayText",
                style: const TextStyle(
                  fontSize: 28,
                  fontFamily: 'FredokaOne',
                  color: Colors.black87,
                ),
              ),
        ),
      ],
    );
  }
}

class ConnectionPainter extends CustomPainter {
  final Map<int, int> connections;
  final int? activeLeftIndex;
  final Offset? currentDragPosition;
  final List<GlobalKey> leftKeys;
  final List<GlobalKey> rightKeys;

  ConnectionPainter({
    required this.connections,
    required this.activeLeftIndex,
    required this.currentDragPosition,
    required this.leftKeys,
    required this.rightKeys,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw established connections
    connections.forEach((leftIdx, rightIdx) {
      final startOffset = _getWidgetCenter(leftKeys[leftIdx]);
      final endOffset = _getWidgetCenter(rightKeys[rightIdx]);

      if (startOffset != null && endOffset != null) {
        paint.color = Colors.green;
        _drawBezierCurve(canvas, startOffset, endOffset, paint);
      }
    });

    // Draw active drag line
    if (activeLeftIndex != null && currentDragPosition != null) {
      final startOffset = _getWidgetCenter(leftKeys[activeLeftIndex!]);
      if (startOffset != null) {
        paint.color = Colors.blueAccent.withOpacity(0.6);
        _drawBezierCurve(canvas, startOffset, currentDragPosition!, paint);
      }
    }
  }

  void _drawBezierCurve(Canvas canvas, Offset start, Offset end, Paint paint) {
    final path = Path();
    path.moveTo(start.dx, start.dy);
    
    // Create a smooth cubic bezier curve
    final controlPoint1 = Offset(start.dx + 100, start.dy);
    final controlPoint2 = Offset(end.dx - 100, end.dy);
    
    path.cubicTo(
      controlPoint1.dx, controlPoint1.dy, 
      controlPoint2.dx, controlPoint2.dy, 
      end.dx, end.dy
    );
    
    canvas.drawPath(path, paint);
  }

  Offset? _getWidgetCenter(GlobalKey key) {
    final RenderBox? box = key.currentContext?.findRenderObject() as RenderBox?;
    if (box != null && box.hasSize) {
      final offset = box.localToGlobal(Offset.zero);
      return Offset(offset.dx + box.size.width / 2, offset.dy + box.size.height / 2);
    }
    return null;
  }

  @override
  bool shouldRepaint(covariant ConnectionPainter oldDelegate) {
    return true; // Simplified for dragging reactivity
  }
}
