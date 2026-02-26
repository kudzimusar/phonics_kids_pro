import 'package:flutter/material.dart';
import 'vector_graphic.dart';
import '../utils/responsive_helper.dart';

class TrigraphExamples extends StatelessWidget {
  final List<Map<String, dynamic>> entries;

  const TrigraphExamples({Key? key, required this.entries}) : super(key: key);

  List<TextSpan> _buildHighlightedWord(String word, String trigraph) {
    final lowerWord = word.toLowerCase();
    final lowerTrigraph = trigraph.toLowerCase();
    
    final startIndex = lowerWord.indexOf(lowerTrigraph);
    if (startIndex == -1) {
      return [TextSpan(text: word, style: const TextStyle(color: Colors.black87))];
    }

    final endIndex = startIndex + trigraph.length;
    
    return [
      TextSpan(
        text: word.substring(0, startIndex),
        style: const TextStyle(color: Colors.black87),
      ),
      TextSpan(
        text: word.substring(startIndex, endIndex),
        style: const TextStyle(
          color: Colors.purpleAccent,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
          decorationColor: Colors.purpleAccent,
          decorationThickness: 2,
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
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveHelper.getResponsiveGridCount(
          context: context, 
          mobile: 1, 
          tablet: 2, 
          desktop: 2
        ),
        childAspectRatio: 1.2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        final word = entry['word'] as String;
        final trigraph = entry['trigraph'] as String;
        final imageId = entry['imageId'] as String;

        return Container(
          decoration: BoxDecoration(
            color: Colors.purple.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.purple.shade200, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.shade100.withOpacity(0.5),
                offset: const Offset(0, 4),
                blurRadius: 8,
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: VectorGraphic(assetName: imageId, size: 90),
                ),
              ),
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontFamily: 'SassoonPrimary',
                            fontSize: 36,
                            fontWeight: FontWeight.w600,
                          ),
                          children: _buildHighlightedWord(word, trigraph),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        trigraph,
                        style: const TextStyle(
                          fontFamily: 'SassoonPrimary',
                          fontSize: 36,
                          fontWeight: FontWeight.w400,
                          color: Colors.black26, // Tracing style simulation
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
