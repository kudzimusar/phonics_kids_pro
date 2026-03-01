import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../textbook/components/phonic_fox_narrator.dart';

class NotebookOverlay extends StatefulWidget {
  final String moduleId;
  final VoidCallback onDismiss;

  const NotebookOverlay({
    Key? key,
    required this.moduleId,
    required this.onDismiss,
  }) : super(key: key);

  @override
  State<NotebookOverlay> createState() => _NotebookOverlayState();
}

class _NotebookOverlayState extends State<NotebookOverlay> {
  final List<List<DrawingPoint>> _lines = [];
  Color _selectedColor = Colors.black;
  double _strokeWidth = 3.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F0), // Japanese Washi-like off-white
      body: Stack(
        children: [
          // 1. Textured Background Layer
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                'assets/images/japanese_stationery_texture.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(),
              ),
            ),
          ),
          
          // 2. Drawing Canvas Layer
          GestureDetector(
            onPanStart: (details) {
              setState(() {
                _lines.add([
                  DrawingPoint(
                    offset: details.localPosition,
                    paint: Paint()
                      ..color = _selectedColor
                      ..strokeWidth = _strokeWidth
                      ..strokeCap = StrokeCap.round
                      ..style = PaintingStyle.stroke,
                  )
                ]);
              });
            },
            onPanUpdate: (details) {
              setState(() {
                _lines.last.add(
                  DrawingPoint(
                    offset: details.localPosition,
                    paint: Paint()
                      ..color = _selectedColor
                      ..strokeWidth = _strokeWidth
                      ..strokeCap = StrokeCap.round
                      ..style = PaintingStyle.stroke,
                  ),
                );
              });
            },
            child: Listener(
              onPointerDown: (event) {
                // Specialized handling for stylus vs touch if needed
                if (event.kind == PointerDeviceKind.stylus) {
                  // Adjust stroke width based on pressure if supported
                  _strokeWidth = event.pressure * 10;
                } else {
                  _strokeWidth = 3.0; // Thick line for finger/mouse
                }
              },
              child: CustomPaint(
                painter: NotebookPainter(_lines),
                size: Size.infinite,
              ),
            ),
          ),

          // 3. Toolbar & Mascot
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, size: 30, color: Colors.indigo),
                      onPressed: widget.onDismiss,
                    ),
                    Text(
                      'Benjamin Notebook',
                      style: const TextStyle(
                        fontFamily: 'FredokaOne',
                        fontSize: 28,
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        _buildColorButton(Colors.red),
                        _buildColorButton(Colors.blue),
                        _buildColorButton(Colors.black),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: const Icon(Icons.undo, color: Colors.indigo),
                          onPressed: () {
                            if (_lines.isNotEmpty) {
                              setState(() => _lines.removeLast());
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const PhonicFoxNarrator(
                  text: "Let's master our mistakes together! Try re-writing the words you found difficult.",
                  state: FoxState.thinking,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorButton(Color color) {
    return GestureDetector(
      onTap: () => setState(() => _selectedColor = color),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: _selectedColor == color ? Colors.orange : Colors.grey.shade300,
            width: _selectedColor == color ? 3 : 1,
          ),
        ),
      ),
    );
  }
}

class DrawingPoint {
  final Offset offset;
  final Paint paint;

  DrawingPoint({required this.offset, required this.paint});
}

class NotebookPainter extends CustomPainter {
  final List<List<DrawingPoint>> lines;

  NotebookPainter(this.lines);

  @override
  void paint(Canvas canvas, Size size) {
    for (final line in lines) {
      for (int i = 0; i < line.length - 1; i++) {
        canvas.drawLine(line[i].offset, line[i+1].offset, line[i].paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant NotebookPainter oldDelegate) => true;
}
