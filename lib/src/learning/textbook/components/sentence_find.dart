import 'package:flutter/material.dart';

class SentenceFind extends StatefulWidget {
  final List<Map<String, dynamic>> sentences;
  final bool numbered;
  final bool hasDecoration;

  const SentenceFind({
    Key? key,
    required this.sentences,
    this.numbered = false,
    this.hasDecoration = true,
  }) : super(key: key);

  @override
  State<SentenceFind> createState() => _SentenceFindState();
}

class _SentenceFindState extends State<SentenceFind> {
  // Map of sentenceIndex to a Set of selected word indices
  final Map<int, Set<int>> _selections = {};

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.sentences.length; i++) {
      _selections[i] = {};
    }
  }

  void _toggleWord(int sentenceIndex, int wordIndex) {
    setState(() {
      if (_selections[sentenceIndex]!.contains(wordIndex)) {
        _selections[sentenceIndex]!.remove(wordIndex);
      } else {
        _selections[sentenceIndex]!.add(wordIndex);
      }
    });
  }

  List<String> _splitSentenceIntoWords(String sentence) {
    // Split by spaces but we need to keep punctuation attached to words for display, 
    // or separate them. A simple split by space is easiest.
    return sentence.split(' ');
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.sentences.length,
      separatorBuilder: (context, index) => const SizedBox(height: 32),
      itemBuilder: (context, sentenceIndex) {
        final sentenceData = widget.sentences[sentenceIndex];
        final text = sentenceData['text'] as String;
        final answers = List<String>.from(sentenceData['answers'] ?? []);
        final words = _splitSentenceIntoWords(text);

        final childRow = Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              if (widget.numbered || sentenceData.containsKey('number')) ...[
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade500,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${sentenceData['number'] ?? (sentenceIndex + 1)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'FredokaOne',
                    ),
                  ),
                ),
                const SizedBox(width: 24),
              ],
              Expanded(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 16,
                  children: words.asMap().entries.map((entry) {
                    final wordIndex = entry.key;
                    final word = entry.value;
                    final isSelected = _selections[sentenceIndex]!.contains(wordIndex);
                    
                    final answers = List<String>.from(sentenceData['answers'] ?? []);
                    final cleanWord = word.replaceAll(RegExp(r'[^\w\s]'), '').trim();
                    final isCorrect = answers.any((a) => a.toLowerCase() == cleanWord.toLowerCase());

                    Color bgColor = Colors.transparent;
                    Color textColor = Colors.black87;
                    IconData? overlayIcon;

                    if (isSelected) {
                      if (isCorrect) {
                        bgColor = Colors.green.shade100;
                        textColor = Colors.green.shade800;
                        overlayIcon = Icons.check_circle;
                      } else {
                        bgColor = Colors.red.shade100;
                        textColor = Colors.red.shade800;
                        overlayIcon = Icons.cancel;
                      }
                    }

                    return GestureDetector(
                      onTap: () => _toggleWord(sentenceIndex, wordIndex),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              word,
                              style: TextStyle(
                                fontFamily: 'SassoonPrimary',
                                fontSize: 32,
                                fontWeight: FontWeight.w500,
                                color: textColor,
                                decoration: isSelected && isCorrect ? TextDecoration.underline : TextDecoration.none,
                                decorationColor: Colors.green.shade600,
                                decorationThickness: 2,
                              ),
                            ),
                            if (overlayIcon != null) ...[
                              const SizedBox(width: 4),
                              Icon(overlayIcon, color: textColor, size: 24),
                            ]
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          );

        if (widget.hasDecoration) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blueGrey.shade200, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey.shade50,
                  offset: const Offset(0, 4),
                  blurRadius: 8,
                )
              ],
            ),
            child: childRow,
          );
        } else {
          return childRow;
        }
      },
    );
  }
}
