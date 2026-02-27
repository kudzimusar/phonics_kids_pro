import 'package:flutter/material.dart';
import 'vector_graphic.dart';

/// SentenceTable for A34: Defining Diphthongs
/// Matches the exact PDF layout — alternating rows where even rows are
/// [text | image] and odd rows are [image | text], except row 1 which is
/// [text | image]. This creates the staggered checkerboard look from page 37.
class SentenceTable extends StatelessWidget {
  final List<Map<String, dynamic>> rows;

  const SentenceTable({Key? key, required this.rows}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: Colors.black87, width: 2),
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1),
      },
      children: rows.asMap().entries.map((entry) {
        final index = entry.key;
        final row = entry.value;
        final text = row['text'] as String;
        final imageId = row['imageId'] as String;
        final diphthongs = List<String>.from(row['diphthongs'] ?? []);

        // Even index (0, 2, 4...): text LEFT, image RIGHT
        // Odd index (1, 3, 5...): image LEFT, text RIGHT
        final textIsLeft = index.isEven;

        final textCell = TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: _buildHighlightedSentence(text, diphthongs),
          ),
        );

        final imageCell = TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Center(
              child: VectorGraphic(assetName: imageId, size: 80),
            ),
          ),
        );

        return TableRow(
          children: textIsLeft
              ? [textCell, imageCell]
              : [imageCell, textCell],
        );
      }).toList(),
    );
  }

  Widget _buildHighlightedSentence(String sentence, List<String> targets) {
    if (targets.isEmpty) {
      return Text(
        sentence,
        style: const TextStyle(
          fontSize: 22,
          fontFamily: 'SassoonPrimary',
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      );
    }

    final escapedTargets = targets.map((t) => RegExp.escape(t)).join('|');
    final regex = RegExp('($escapedTargets)', caseSensitive: false);
    final matches = regex.allMatches(sentence);

    if (matches.isEmpty) {
      return Text(
        sentence,
        style: const TextStyle(
          fontSize: 22,
          fontFamily: 'SassoonPrimary',
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      );
    }

    final spans = <TextSpan>[];
    int currentIndex = 0;

    for (final match in matches) {
      if (match.start > currentIndex) {
        spans.add(TextSpan(
          text: sentence.substring(currentIndex, match.start),
          style: const TextStyle(color: Colors.black87),
        ));
      }
      spans.add(TextSpan(
        text: sentence.substring(match.start, match.end),
        style: const TextStyle(
          color: Color(0xFFD32F2F),
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
          decorationColor: Color(0xFFD32F2F),
          decorationThickness: 2,
        ),
      ));
      currentIndex = match.end;
    }

    if (currentIndex < sentence.length) {
      spans.add(TextSpan(
        text: sentence.substring(currentIndex),
        style: const TextStyle(color: Colors.black87),
      ));
    }

    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 22,
          fontFamily: 'SassoonPrimary',
          fontWeight: FontWeight.bold,
        ),
        children: spans,
      ),
    );
  }
}
