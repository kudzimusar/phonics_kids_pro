import 'package:flutter/material.dart';
import 'vector_graphic.dart';
import '../utils/responsive_helper.dart';

class DigraphExampleGrid extends StatelessWidget {
  final List<Map<String, dynamic>> entries;
  final int columns;

  const DigraphExampleGrid({
    Key? key,
    required this.entries,
    this.columns = 4,
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
          color: Colors.redAccent,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
          decorationColor: Colors.redAccent,
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
          mobile: 2, 
          tablet: columns, 
          desktop: columns
        ),
        childAspectRatio: 0.85,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        final word = entry['word'] as String;
        final digraph = entry['digraph'] as String;
        final imageId = entry['imageId'] as String;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.indigo.shade100, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.indigo.shade50,
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
                  padding: const EdgeInsets.all(8.0),
                  child: VectorGraphic(assetName: imageId, size: 80),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontFamily: 'SassoonPrimary',
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                      ),
                      children: _buildHighlightedWord(word, digraph),
                    ),
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
