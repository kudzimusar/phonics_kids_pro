import 'package:flutter/material.dart';
import 'vector_graphic.dart';
import 'finger_trace_canvas.dart';

/// A35: Diphthong Tracing — Touch-friendly, large-font vertical layout
/// Each row: image (left), word with diphthong highlighted (large, centre),
/// REAL FingerTraceCanvas over the faded diphthong (right) for actual tracing.
class DiphthongTraceTable extends StatelessWidget {
  final List<Map<String, dynamic>> rows;
  final int columns;

  const DiphthongTraceTable({
    Key? key,
    required this.rows,
    this.columns = 2,
  }) : super(key: key);

  List<TextSpan> _buildHighlightedWord(String word, String diphthong) {
    final lowerWord = word.toLowerCase();
    final lowerDiph = diphthong.toLowerCase();
    final start = lowerWord.indexOf(lowerDiph);
    if (start == -1) {
      return [TextSpan(text: word, style: const TextStyle(color: Colors.black87))];
    }
    final end = start + diphthong.length;
    return [
      TextSpan(
        text: word.substring(0, start),
        style: const TextStyle(color: Colors.black87),
      ),
      TextSpan(
        text: word.substring(start, end),
        style: const TextStyle(
          color: Color(0xFFD32F2F),
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
          decorationColor: Color(0xFFD32F2F),
          decorationThickness: 3,
        ),
      ),
      TextSpan(
        text: word.substring(end),
        style: const TextStyle(color: Colors.black87),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: rows.asMap().entries.map((e) {
        final index = e.key;
        final row = e.value;
        final word = row['word'] as String;
        final diphthong = row['diphthong'] as String;
        final imageId = row['imageId'] as String? ?? '';

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Image — large and unboxed
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: imageId.isNotEmpty
                        ? VectorGraphic(assetName: imageId, size: 80)
                        : Center(
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Colors.deepPurple.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  word.substring(0, 1).toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 38,
                                    color: Colors.deepPurple.shade400,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(width: 16),
                  // Word with diphthong highlighted — large
                  Expanded(
                    flex: 2,
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontFamily: 'SassoonPrimary',
                          fontSize: 46,
                          fontWeight: FontWeight.w600,
                        ),
                        children: _buildHighlightedWord(word, diphthong),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Real FingerTraceCanvas — wrap faded diphthong for actual tracing
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 90,
                      child: FingerTraceCanvas(
                        inkColor: const Color(0xFFD32F2F),
                        strokeWidth: 12,
                        child: Center(
                          child: Text(
                            diphthong,
                            style: const TextStyle(
                              fontFamily: 'SassoonPrimary',
                              fontSize: 72,
                              color: Color(0x25D32F2F), // Very faded guide
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Subtle divider
            if (index < rows.length - 1)
              Divider(
                color: Colors.grey.shade200,
                thickness: 1.5,
                indent: 12,
                endIndent: 12,
              ),
          ],
        );
      }).toList(),
    );
  }
}
