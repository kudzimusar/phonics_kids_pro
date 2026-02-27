import 'package:flutter/material.dart';
import 'vector_graphic.dart';

/// A40: How To Put A Word Together — Glued Sounds
/// Matches the textbook layout exactly:
/// - 2-column grid  
/// - Each entry: word (bold large) | glued-sound (lighter below) | image (right)
/// - No card borders — open layout just like the book
/// - Font: SassoonPrimary, word 32px bold, glued-sound 22px normal
class GluedSoundGrid extends StatelessWidget {
  final List<Map<String, dynamic>> entries;
  final int columns;

  const GluedSoundGrid({Key? key, required this.entries, this.columns = 2}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Build rows of 2 entries each
    final rows = <List<Map<String, dynamic>>>[];
    for (int i = 0; i < entries.length; i += columns) {
      rows.add(entries.sublist(i, (i + columns).clamp(0, entries.length)));
    }

    return Column(
      children: rows.map((row) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: row.map((entry) {
              return Expanded(
                child: _GluedSoundEntry(
                  word: entry['word'] as String,
                  gluedSound: entry['gluedSound'] as String,
                  imageId: entry['imageId'] as String,
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}

class _GluedSoundEntry extends StatelessWidget {
  final String word;
  final String gluedSound;
  final String imageId;

  const _GluedSoundEntry({
    required this.word,
    required this.gluedSound,
    required this.imageId,
  });

  @override
  Widget build(BuildContext context) {
    // Underline the glued sound portion of the word
    final lower = word.toLowerCase();
    final lowerGlued = gluedSound.toLowerCase();
    final gluedStart = lower.lastIndexOf(lowerGlued);

    Widget wordWidget;
    if (gluedStart >= 0) {
      final prefix = word.substring(0, gluedStart);
      final gluedPart = word.substring(gluedStart);
      wordWidget = RichText(
        text: TextSpan(
          style: const TextStyle(
            fontFamily: 'SassoonPrimary',
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          children: [
            TextSpan(text: prefix),
            TextSpan(
              text: gluedPart,
              style: const TextStyle(
                decoration: TextDecoration.underline,
                decorationThickness: 3,
                decorationColor: Colors.black87,
              ),
            ),
          ],
        ),
      );
    } else {
      wordWidget = Text(
        word,
        style: const TextStyle(
          fontFamily: 'SassoonPrimary',
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Word + glued sound stacked
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              wordWidget,
              Text(
                gluedSound,
                style: const TextStyle(
                  fontFamily: 'SassoonPrimary',
                  fontSize: 22,
                  color: Colors.black54,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        // Image — large, open, no container
        VectorGraphic(assetName: imageId, size: 88),
        const SizedBox(width: 8),
      ],
    );
  }
}
