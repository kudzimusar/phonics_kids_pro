import 'package:flutter/material.dart';

class ColorByCodeFishing extends StatefulWidget {
  final List<Map<String, String>> codes; // e.g. [{'label': 'Long A', 'color': 'Red'}, ...]
  final List<Map<String, String>> fish;  // e.g. [{'word': 'silo', 'answer': 'blue'}, ...]

  const ColorByCodeFishing({
    Key? key,
    required this.codes,
    required this.fish,
  }) : super(key: key);

  @override
  State<ColorByCodeFishing> createState() => _ColorByCodeFishingState();
}

class _ColorByCodeFishingState extends State<ColorByCodeFishing> {
  // Store the current color of each fish (default transparent/white)
  late List<Color> _fishColors;
  Color? _selectedInk; // The color the user currently has selected from the key

  @override
  void initState() {
    super.initState();
    _fishColors = List.generate(widget.fish.length, (_) => Colors.white);
  }

  Color _parseColor(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'red': return Colors.red;
      case 'orange': return Colors.orange;
      case 'yellow': return Colors.yellow;
      case 'green': return Colors.green;
      case 'blue': return Colors.blue;
      case 'purple': return Colors.purple;
      default: return Colors.grey;
    }
  }

  void _handleFishTap(int index) {
    if (_selectedInk == null) return;
    
    // In a strict pedagogical app, we might only allow coloring if it's the correct answer.
    // Or we allow them to color it wrong and check later.
    // Let's implement immediate feedback: only colors if correct paint is applied.
    final targetColorName = widget.fish[index]['answer']!;
    final targetColor = _parseColor(targetColorName);

    if (_selectedInk == targetColor) {
      setState(() {
        _fishColors[index] = targetColor;
      });
      // TODO: Play success chime
    } else {
      // TODO: Play error bleep / shake animation
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. Color Key Legend
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.blue.shade200, width: 2),
          ),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: widget.codes.map((code) {
              final colorValue = _parseColor(code['color']!);
              final isSelected = _selectedInk == colorValue;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedInk = colorValue;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? colorValue.withOpacity(0.2) : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: isSelected ? colorValue : Colors.grey.shade300,
                      width: isSelected ? 3 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: colorValue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black54),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        code['label']!,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'FredokaOne',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        
        const SizedBox(height: 32),

        // 2. The Fish Grid
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 24,
            ),
            itemCount: widget.fish.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _handleFishTap(index),
                child: CustomPaint(
                  painter: FishPainter(fillColor: _fishColors[index]),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20), // offset for the tail
                      child: Text(
                        widget.fish[index]['word']!,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'FredokaOne',
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class FishPainter extends CustomPainter {
  final Color fillColor;

  FishPainter({required this.fillColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paintFill = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
      
    final paintStroke = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // A simplified fish shape
    final path = Path();
    
    // Body (ellipse)
    final bodyRect = Rect.fromCenter(
      center: Offset(size.width * 0.4, size.height * 0.5),
      width: size.width * 0.6,
      height: size.height * 0.6,
    );
    path.addOval(bodyRect);
    
    // Tail (triangle)
    path.moveTo(size.width * 0.7, size.height * 0.5);
    path.lineTo(size.width * 0.95, size.height * 0.2);
    path.lineTo(size.width * 0.95, size.height * 0.8);
    path.close();

    canvas.drawPath(path, paintFill);
    canvas.drawPath(path, paintStroke);
    
    // Eye
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.4), 4, Paint()..color = Colors.black);
  }

  @override
  bool shouldRepaint(covariant FishPainter oldDelegate) {
    return oldDelegate.fillColor != fillColor;
  }
}
