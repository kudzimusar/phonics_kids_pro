import 'package:flutter/material.dart';
import 'vector_graphic.dart';
import 'finger_trace_canvas.dart';
import '../utils/responsive_helper.dart';

/// A21: Defining Digraphs
/// Card style matching A23's TrigraphExamples:
/// - Large image (top flex 3)
/// - Highlighted word + FingerTraceCanvas over faded digraph (bottom flex 2)
/// 2-column grid with generous cards
class DigraphExampleGrid extends StatelessWidget {
  final List<Map<String, dynamic>> entries;
  final int columns;

  const DigraphExampleGrid({
    Key? key,
    required this.entries,
    this.columns = 2,
  }) : super(key: key);

  List<TextSpan> _buildHighlightedWord(String word, String digraph) {
    final lowerWord = word.toLowerCase();
    final lowerDigraph = digraph.toLowerCase();

    final startIndex = lowerWord.indexOf(lowerDigraph);
    if (startIndex == -1) {
      return [TextSpan(text: word, style: const TextStyle(color: Colors.black87))];
    }

    final endIndex = startIndex + digraph.length;

    return [
      TextSpan(
        text: word.substring(0, startIndex),
        style: const TextStyle(color: Colors.black87),
      ),
      TextSpan(
        text: word.substring(startIndex, endIndex),
        style: const TextStyle(
          color: Color(0xFFE53935),
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
          decorationColor: Color(0xFFE53935),
          decorationThickness: 2.5,
        ),
      ),
      TextSpan(
        text: word.substring(endIndex),
        style: const TextStyle(color: Colors.black87),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveHelper.getResponsiveGridCount(
          context: context,
          mobile: 2,
          tablet: columns,
          desktop: columns,
        ),
        childAspectRatio: 1.05,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        final word = entry['word'] as String;
        final digraph = entry['digraph'] as String;
        final imageId = entry['imageId'] as String;

        return Container(
          decoration: BoxDecoration(
            color: Colors.indigo.shade50,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.indigo.shade200, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.indigo.shade100.withOpacity(0.5),
                offset: const Offset(0, 4),
                blurRadius: 8,
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image (large top portion)
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: VectorGraphic(assetName: imageId, size: 90),
                ),
              ),
              // Word + tracing row (bottom portion)
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Highlighted word
                      Flexible(
                        child: RichText(
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            style: const TextStyle(
                              fontFamily: 'SassoonPrimary',
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                            children: _buildHighlightedWord(word, digraph),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // FingerTraceCanvas — kids trace the digraph with their finger
                      SizedBox(
                        width: 52,
                        height: 44,
                        child: FingerTraceCanvas(
                          inkColor: const Color(0xFFE53935),
                          strokeWidth: 9,
                          showClearButton: false,
                          child: Center(
                            child: Text(
                              digraph,
                              style: const TextStyle(
                                fontFamily: 'SassoonPrimary',
                                fontSize: 26,
                                color: Color(0x30E53935),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
