import 'package:flutter/material.dart';

class WordSelectionList extends StatefulWidget {
  final List<Map<String, dynamic>> sets;

  const WordSelectionList({Key? key, required this.sets}) : super(key: key);

  @override
  State<WordSelectionList> createState() => _WordSelectionListState();
}

class _WordSelectionListState extends State<WordSelectionList> {
  // Map of setIndex to a Set of selected word indices
  final Map<int, Set<int>> _selections = {};

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.sets.length; i++) {
      _selections[i] = {};
    }
  }

  void _toggleSelection(int setIndex, int wordIndex) {
    setState(() {
      if (_selections[setIndex]!.contains(wordIndex)) {
        _selections[setIndex]!.remove(wordIndex);
      } else {
        _selections[setIndex]!.add(wordIndex);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.sets.length,
      separatorBuilder: (context, index) => const SizedBox(height: 24),
      itemBuilder: (context, setIndex) {
        final wordSet = widget.sets[setIndex];
        final words = List<String>.from(wordSet['words'] ?? []);

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
          child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            spacing: 16,
            runSpacing: 16,
            children: words.asMap().entries.map((entry) {
              final wordIndex = entry.key;
              final word = entry.value;
              final isSelected = _selections[setIndex]!.contains(wordIndex);

              return GestureDetector(
                onTap: () => _toggleSelection(setIndex, wordIndex),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.red.shade50 : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Colors.redAccent : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    word,
                    style: TextStyle(
                      fontFamily: 'SassoonPrimary',
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.red.shade800 : Colors.black87,
                      decoration: isSelected ? TextDecoration.underline : TextDecoration.none,
                      decorationColor: Colors.redAccent,
                      decorationThickness: 3,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
