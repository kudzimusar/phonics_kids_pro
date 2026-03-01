import 'package:flutter/material.dart';
import 'vector_graphic.dart';

class TracingCard extends StatefulWidget {
  final String icon;
  final String partialWord;
  final String position; // 'beginning' or 'end'
  final List<String> tracingOptions;
  final ValueChanged<bool>? onStatusChanged;

  const TracingCard({
    Key? key,
    required this.icon,
    required this.partialWord,
    required this.position,
    required this.tracingOptions,
    this.onStatusChanged,
  }) : super(key: key);

  @override
  State<TracingCard> createState() => _TracingCardState();
}

class _TracingCardState extends State<TracingCard> {
  String? _selectedLetter;

  void _selectLetter(String letter) {
    if (_selectedLetter != null) return; // Only allow one pick for simplicity, or toggle

    setState(() {
      _selectedLetter = letter;
    });

    // Check if the selected letter matches the icon's starting/ending letter (simplified logic)
    // The first tracingOption is usually the correct one based on current database
    // but better would be to pass the correct letter. 
    // For now, let's assume the first option is the hint/answer if it matches the 'cat' -> 'c' logic.
    // Actually, let's just use the first 'tracingOption' as the correct one for now, 
    // OR we can even just report TRUE if they click ANY, but better to check.
    
    // In A5: cat(c, M), dog(d, T), pig(p, s), green(g, d), farm(f, s), feet(f, b)
    // So tracingOptions[0] is ALWAYS the correct choice.
    final bool isCorrect = letter == widget.tracingOptions[0];
    if (isCorrect) {
      widget.onStatusChanged?.call(true);
    }
  }

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
                      if (widget.position == 'beginning') _buildBlankSpace(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          widget.partialWord,
                          style: const TextStyle(
                            fontSize: 32,
                            fontFamily: 'FredokaOne',
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      if (widget.position == 'end') _buildBlankSpace(),
                    ],
                  ),
                  
                  // Divider line
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Divider(color: Colors.blueGrey.shade200, thickness: 2),
                  ),

                  // Bottom part: The tracing options stacked vertically
                  _buildTraceOption(widget.tracingOptions[0]),
                  _buildTraceOption(widget.tracingOptions[1]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlankSpace() {
    if (_selectedLetter != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Text(
          _selectedLetter!,
          style: TextStyle(
            fontSize: 40,
            fontFamily: 'FredokaOne',
            color: _selectedLetter == widget.tracingOptions[0] ? Colors.green.shade800 : Colors.red.shade800,
          ),
        ),
      );
    }
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
    final bool isSelected = _selectedLetter == letter;
    final bool isCorrect = letter == widget.tracingOptions[0];

    return GestureDetector(
      onTap: () => _selectLetter(letter),
      child: Text(
        letter,
        style: TextStyle(
          fontSize: 48,
          fontFamily: 'SassoonPrimary', // Prefer SassoonPrimary for tracing
          color: isSelected 
              ? (isCorrect ? Colors.green : Colors.red) 
              : Colors.grey,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w300,
          decoration: isSelected ? null : TextDecoration.none,
        ),
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
