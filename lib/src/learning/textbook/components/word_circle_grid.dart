import 'package:flutter/material.dart';

class WordCircleGrid extends StatefulWidget {
  final List<Map<String, dynamic>> words; 
  /* Example word:
    {
      'word': 'make',
      'hasBossyR': false,
    }
  */
  final int columns;

  const WordCircleGrid({
    Key? key,
    required this.words,
    this.columns = 4,
  }) : super(key: key);

  @override
  State<WordCircleGrid> createState() => _WordCircleGridState();
}

class _WordCircleGridState extends State<WordCircleGrid> {
  // Keeps track of which words have been circled by the user
  late List<bool> _circled;

  @override
  void initState() {
    super.initState();
    _circled = List.generate(widget.words.length, (_) => false);
  }

  void _handleTap(int index) {
    setState(() {
      _circled[index] = !_circled[index];
    });
    
    // Optional: play a drawing sound effect here
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.columns,
        childAspectRatio: 2.0, // Wide boxes for words
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: widget.words.length,
      itemBuilder: (context, index) {
        final wordData = widget.words[index];
        final word = wordData['word'] as String;
        final isCircled = _circled[index];

        return GestureDetector(
          onTap: () => _handleTap(index),
          child: Container(
            color: Colors.transparent, // Keeps the whole area tappable
            child: Stack(
              alignment: Alignment.center,
              children: [
                // The Text
                Text(
                  word,
                  style: const TextStyle(
                    fontSize: 32,
                    fontFamily: 'SassoonPrimary', // Dyslexia-friendly handwriting font
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                // The Circle Overlay (Only visible if tapped)
                if (isCircled)
                  CustomPaint(
                    size: const Size(120, 60),
                    painter: _HandDrawnCirclePainter(),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HandDrawnCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.redAccent.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // We want to simulate a slightly imperfect, hand-drawn ellipse around the word.
    final path = Path();
    
    // Start at roughly 12 o'clock, slightly offset
    path.moveTo(size.width * 0.5, size.height * 0.1);
    
    // Draw the top right curve
    path.quadraticBezierTo(
      size.width * 0.9, size.height * 0.05, 
      size.width * 0.95, size.height * 0.5
    );
    
    // Draw the bottom curve
    path.quadraticBezierTo(
      size.width * 0.8, size.height * 0.95, 
      size.width * 0.5, size.height * 0.9
    );
    
    // Draw the left curve back up
    path.quadraticBezierTo(
      size.width * 0.1, size.height * 0.85, 
      size.width * 0.05, size.height * 0.5
    );
    
    // Close the loop with a slight overlap to look "drawn"
    path.quadraticBezierTo(
      size.width * 0.1, size.height * 0.15, 
      size.width * 0.6, size.height * 0.1
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
