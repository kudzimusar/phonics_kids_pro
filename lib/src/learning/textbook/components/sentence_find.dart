import 'package:flutter/material.dart';

class SentenceFind extends StatefulWidget {
  final List<Map<String, dynamic>> sentences;
  final bool numbered;

  const SentenceFind({
    Key? key,
    required this.sentences,
    this.numbered = false,
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
        final words = _splitSentenceIntoWords(text);

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
          child: Row(
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

                    return GestureDetector(
                      onTap: () => _toggleWord(sentenceIndex, wordIndex),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.yellow.shade200 : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          word,
                          style: TextStyle(
                            fontFamily: 'SassoonPrimary',
                            fontSize: 32,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                            decoration: isSelected ? TextDecoration.underline : TextDecoration.none,
                            decorationColor: Colors.deepOrange,
                            decorationThickness: 2,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
