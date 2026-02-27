import 'package:flutter/material.dart';
import 'vector_graphic.dart';

/// A36: Find the Diphthongs
/// Open card layout — image + sentence, user taps words to highlight diphthongs.
/// No heavy borders. Clean, spacious, touch-friendly font (28px).
class SentenceFindGrid extends StatefulWidget {
  final List<Map<String, dynamic>> sentences;
  final int columns;

  const SentenceFindGrid({
    Key? key,
    required this.sentences,
    this.columns = 2,
  }) : super(key: key);

  @override
  State<SentenceFindGrid> createState() => _SentenceFindGridState();
}

class _SentenceFindGridState extends State<SentenceFindGrid> {
  // For each sentence, track which words the user has tapped
  late final List<Set<String>> _tappedWords;
  late final List<bool> _checked;

  @override
  void initState() {
    super.initState();
    _tappedWords = List.generate(widget.sentences.length, (_) => {});
    _checked = List.generate(widget.sentences.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.sentences.asMap().entries.map((entry) {
        final i = entry.key;
        final sentence = entry.value;
        final text = sentence['text'] as String;
        final imageId = sentence['imageId'] as String;
        final highlight = List<String>.from(sentence['highlight'] ?? []);
        final answers = List<String>.from(sentence['answers'] ?? []);

        final words = text.split(RegExp(r'\s+'));

        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image — open, no box
              Padding(
                padding: const EdgeInsets.only(right: 16, top: 4),
                child: VectorGraphic(assetName: imageId, size: 72),
              ),
              // Sentence word chips + check button
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tappable word row
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: words.map((rawWord) {
                        final clean = rawWord.replaceAll(RegExp(r'[^a-zA-Z]'), '').toLowerCase();
                        final isTapped = _tappedWords[i].contains(clean);
                        final isCorrect = highlight.any((h) => h.toLowerCase() == clean);
                        final showCorrect = _checked[i] && isCorrect;
                        final showWrong = _checked[i] && isTapped && !isCorrect;

                        Color bg = Colors.transparent;
                        Color border = Colors.transparent;
                        if (isTapped && !_checked[i]) {
                          bg = Colors.amber.shade100;
                          border = Colors.amber.shade400;
                        }
                        if (showCorrect) {
                          bg = Colors.green.shade100;
                          border = Colors.green;
                        }
                        if (showWrong) {
                          bg = Colors.red.shade50;
                          border = Colors.red.shade300;
                        }

                        return GestureDetector(
                          onTap: () {
                            if (!_checked[i]) {
                              setState(() {
                                if (_tappedWords[i].contains(clean)) {
                                  _tappedWords[i].remove(clean);
                                } else {
                                  _tappedWords[i].add(clean);
                                }
                              });
                            }
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: bg,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: border, width: 2),
                            ),
                            child: Text(
                              rawWord,
                              style: const TextStyle(
                                fontFamily: 'SassoonPrimary',
                                fontSize: 26,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),
                    // Check button + answer list
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => setState(() => _checked[i] = true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.indigo.shade600,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Check ✓',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'SassoonPrimary',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        if (_checked[i]) ...[
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              answers.join(' • '),
                              style: TextStyle(
                                fontFamily: 'SassoonPrimary',
                                fontSize: 16,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
