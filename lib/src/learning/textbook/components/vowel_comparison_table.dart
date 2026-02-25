import 'package:flutter/material.dart';
import 'vector_graphic.dart';

class VowelComparisonTable extends StatelessWidget {
  final List<Map<String, String>> rows; 
  /* Example row data:
    {
      'vowel': 'Aa',
      'shortWord': 'Apple',
      'shortIcon': 'apple',
      'longWord': 'Acorn',
      'longIcon': 'acorn',
      'vowelChar': 'A', // For underlining
    }
  */

  const VowelComparisonTable({Key? key, required this.rows}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.blueGrey.shade800, width: 2),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade100,
              border: Border(bottom: BorderSide(color: Colors.blueGrey.shade800, width: 2)),
            ),
            child: Row(
              children: [
                _buildHeaderCell("Short Vowel Sounds"),
                Container(width: 2, height: 30, color: Colors.blueGrey.shade800),
                _buildHeaderCell("Long Vowel Sounds"),
              ],
            ),
          ),
          
          // Rows
          ...rows.map((row) {
            return Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.blueGrey.shade800, width: 1)),
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: _buildVowelCell(row['vowel']!, row['shortIcon']!, row['shortWord']!, row['vowelChar']!.toLowerCase())),
                    Container(width: 2, color: Colors.blueGrey.shade800),
                    Expanded(child: _buildVowelCell(row['vowel']!, row['longIcon']!, row['longWord']!, row['vowelChar']!.toLowerCase())),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Expanded(
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'FredokaOne',
            color: Colors.blueGrey.shade900,
          ),
        ),
      ),
    );
  }

  Widget _buildVowelCell(String letter, String icon, String word, String vowelChar) {
    // We need to underline the vowelChar in the word
    int vowelIndex = word.toLowerCase().indexOf(vowelChar);
    List<TextSpan> spans = [];
    if (vowelIndex != -1) {
      if (vowelIndex > 0) {
        spans.add(TextSpan(text: word.substring(0, vowelIndex)));
      }
      spans.add(TextSpan(
        text: word.substring(vowelIndex, vowelIndex + 1),
        style: const TextStyle(decoration: TextDecoration.underline),
      ));
      if (vowelIndex < word.length - 1) {
        spans.add(TextSpan(text: word.substring(vowelIndex + 1)));
      }
    } else {
      spans.add(TextSpan(text: word));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Letters: Normal Aa and Traced Aa
          Row(
            children: [
              Text(
                letter,
                style: const TextStyle(
                  fontSize: 56,
                  fontFamily: 'SassoonPrimary',
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 16),
              // Tracing letters with handwriting lines
              CustomPaint(
                painter: HandwritingLinePainter(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Text(
                    letter,
                    style: TextStyle(
                      fontSize: 56,
                      fontFamily: 'SassoonPrimary',
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Icon & Word
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              VectorGraphic(assetName: icon, size: 70),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 28,
                    fontFamily: 'SassoonPrimary',
                    color: Colors.black,
                  ),
                  children: spans,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HandwritingLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final solidPaint = Paint()
      ..color = Colors.blueGrey.shade300
      ..strokeWidth = 1.0;
    
    final dashedPaint = Paint()
      ..color = Colors.blueGrey.shade300
      ..strokeWidth = 1.0;

    // Top line
    canvas.drawLine(Offset(0, size.height * 0.2), Offset(size.width, size.height * 0.2), solidPaint);
    // Bottom line
    canvas.drawLine(Offset(0, size.height * 0.8), Offset(size.width, size.height * 0.8), solidPaint);
    
    // Middle dashed line
    double dashWidth = 5, dashSpace = 5, startX = 0;
    final y = size.height * 0.5;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, y), Offset(startX + dashWidth, y), dashedPaint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
