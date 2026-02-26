import 'package:flutter/material.dart';
import 'vector_graphic.dart';

class SentenceTable extends StatelessWidget {
  final List<Map<String, dynamic>> rows;
  /* Example row:
    {
      'text': "The author wrote a book on law.",
      'imageId': "book2",
      'diphthongs': ["aw", "oo"]
    }
  */

  const SentenceTable({Key? key, required this.rows}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.blueGrey.shade100, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: rows.map((row) {
          final isLast = row == rows.last;
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: isLast 
                  ? null 
                  : Border(bottom: BorderSide(color: Colors.blueGrey.shade100, width: 2)),
            ),
            child: Row(
              children: [
                // Image
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Center(
                    child: VectorGraphic(
                      assetName: row['imageId'] as String,
                      size: 80,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                // Sentence
                Expanded(
                  child: _buildHighlightedSentence(
                    row['text'] as String, 
                    List<String>.from(row['diphthongs'] ?? []),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHighlightedSentence(String sentence, List<String> targets) {
    if (targets.isEmpty) {
      return Text(
        sentence,
        style: const TextStyle(
          fontSize: 32,
          fontFamily: 'SassoonPrimary',
          color: Colors.black87,
        ),
      );
    }

    // We build the TextSpans by searching for the target substrings.
    // To handle multiple targets, we can use a regex approach.
    // E.g., targets = ["aw", "oo"]. Pattern = "(aw|oo)"
    
    // Escape targets for regex
    final escapedTargets = targets.map((t) => RegExp.escape(t)).join('|');
    final regex = RegExp('($escapedTargets)', caseSensitive: false);
    
    final matches = regex.allMatches(sentence);
    
    if (matches.isEmpty) {
       return Text(
        sentence,
        style: const TextStyle(
          fontSize: 32,
          fontFamily: 'SassoonPrimary',
          color: Colors.black87,
        ),
      );
    }

    final spans = <TextSpan>[];
    int currentIndex = 0;

    for (final match in matches) {
      // Add text before match
      if (match.start > currentIndex) {
        spans.add(TextSpan(
          text: sentence.substring(currentIndex, match.start),
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.normal),
        ));
      }

      // Add match text
      spans.add(TextSpan(
        text: sentence.substring(match.start, match.end),
        style: const TextStyle(
          color: Colors.redAccent, // Emphasize diphthongs
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
          decorationColor: Colors.redAccent,
        ),
      ));

      currentIndex = match.end;
    }

    // Add remaining text
    if (currentIndex < sentence.length) {
      spans.add(TextSpan(
        text: sentence.substring(currentIndex),
        style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.normal),
      ));
    }

    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 32,
          fontFamily: 'SassoonPrimary',
        ),
        children: spans,
      ),
    );
  }
}
