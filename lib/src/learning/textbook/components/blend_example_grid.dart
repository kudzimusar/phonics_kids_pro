import 'package:flutter/material.dart';
import 'vector_graphic.dart';
import 'finger_trace_canvas.dart';
import '../utils/responsive_helper.dart';

/// A29: Practicing Consonant Blends
/// Open, borderless layout matching the physical textbook.
/// Each item: large image (open, no card container), underlined word below,
/// faded blend beside it for tracing.
class BlendExampleGrid extends StatelessWidget {
  final List<Map<String, dynamic>> entries;
  final int columns;

  const BlendExampleGrid({
    Key? key,
    required this.entries,
    this.columns = 4,
  }) : super(key: key);

  List<TextSpan> _buildHighlightedWord(String word, String blend) {
    final lowerWord = word.toLowerCase();
    final lowerBlend = blend.toLowerCase();

    final startIndex = lowerWord.indexOf(lowerBlend);
    if (startIndex == -1) {
      return [TextSpan(text: word, style: const TextStyle(color: Colors.black87))];
    }

    final endIndex = startIndex + blend.length;

    return [
      TextSpan(
        text: word.substring(0, startIndex),
        style: const TextStyle(
          color: Colors.black87,
          decoration: TextDecoration.underline,
          decorationColor: Colors.black87,
        ),
      ),
      TextSpan(
        text: word.substring(startIndex, endIndex),
        style: const TextStyle(
          color: Color(0xFF512DA8), // Deep purple blend highlight
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
          decorationColor: Color(0xFF512DA8),
          decorationThickness: 3,
        ),
      ),
      TextSpan(
        text: word.substring(endIndex),
        style: const TextStyle(
          color: Colors.black87,
          decoration: TextDecoration.underline,
          decorationColor: Colors.black87,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = ResponsiveHelper.getResponsiveGridCount(
      context: context,
      mobile: 2,
      tablet: columns,
      desktop: columns,
    );

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.9,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        final word = entry['word'] as String;
        final blend = entry['blend'] as String;
        final imageId = entry['imageId'] as String;

        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Large image, open — no card container
            Expanded(
              flex: 3,
              child: VectorGraphic(assetName: imageId, size: 100),
            ),
            // Word with blend underlined
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(
                  fontFamily: 'SassoonPrimary',
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
                children: _buildHighlightedWord(word, blend),
              ),
            ),
            // FingerTraceCanvas — real tracing target for the blend
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: SizedBox(
                width: 80,
                height: 36,
                child: FingerTraceCanvas(
                  inkColor: const Color(0xFF512DA8),
                  strokeWidth: 8,
                  showClearButton: false,
                  child: Center(
                    child: Text(
                      blend,
                      style: const TextStyle(
                        fontFamily: 'SassoonPrimary',
                        fontSize: 22,
                        color: Color(0x40512DA8),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
