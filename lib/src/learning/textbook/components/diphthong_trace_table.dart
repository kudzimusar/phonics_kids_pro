import 'package:flutter/material.dart';
import 'vector_graphic.dart';

class DiphthongTraceTable extends StatelessWidget {
  final List<Map<String, dynamic>> rows;
  final int columns;

  const DiphthongTraceTable({
    Key? key,
    required this.rows,
    this.columns = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.blueGrey.shade200, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          childAspectRatio: 2.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: rows.length,
        itemBuilder: (context, index) {
          final item = rows[index];
          return _buildTraceCell(
            item['word'] as String,
            item['diphthong'] as String,
            item['imageId'] as String,
          );
        },
      ),
    );
  }

  Widget _buildTraceCell(String word, String diphthong, String imageId) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blueGrey.shade100, width: 1),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Graphic
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: VectorGraphic(assetName: imageId, size: 40),
            ),
          ),
          const SizedBox(width: 16),
          // Word with underlined diphthong
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHighlightedWord(word, diphthong),
                const SizedBox(height: 8),
                // Tracing Area for the diphthong
                Row(
                  children: [
                    const Text(
                      "Trace:",
                      style: TextStyle(
                        fontFamily: 'SassoonPrimary',
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      diphthong,
                      style: const TextStyle(
                        fontFamily: 'FredokaOne', // Using Fredoka outline style or dashed
                        fontSize: 32,
                        color: Colors.black12, // Faint for tracing
                        decoration: TextDecoration.lineThrough, // Optional dash effect
                        decorationStyle: TextDecorationStyle.dashed,
                        decorationColor: Colors.black38,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightedWord(String word, String target) {
    final lowerWord = word.toLowerCase();
    final lowerTarget = target.toLowerCase();
    final startIndex = lowerWord.indexOf(lowerTarget);
    
    if (startIndex == -1) {
      return Text(word, style: const TextStyle(fontSize: 28, fontFamily: 'FredokaOne', color: Colors.black87));
    }

    final endIndex = startIndex + target.length;

    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 28, fontFamily: 'FredokaOne'),
        children: [
          TextSpan(
            text: word.substring(0, startIndex),
            style: const TextStyle(color: Colors.black87),
          ),
          TextSpan(
            text: word.substring(startIndex, endIndex),
            style: const TextStyle(
              color: Colors.redAccent,
              decoration: TextDecoration.underline,
              decorationColor: Colors.redAccent,
              decorationThickness: 2,
            ),
          ),
          TextSpan(
            text: word.substring(endIndex),
            style: const TextStyle(color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
