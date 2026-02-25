import 'package:flutter/material.dart';
import 'vector_graphic.dart';
import 'letter_drop_target.dart';

class MultiFillInCard extends StatefulWidget {
  final String icon;
  final String word; // e.g., "F_owe_"
  final List<String> targetLetters; // e.g., ["l", "r"]

  const MultiFillInCard({
    Key? key,
    required this.icon,
    required this.word,
    required this.targetLetters,
  }) : super(key: key);

  @override
  State<MultiFillInCard> createState() => _MultiFillInCardState();
}

class _MultiFillInCardState extends State<MultiFillInCard> {
  late List<bool> _isFilledList;

  @override
  void initState() {
    super.initState();
    _isFilledList = List.generate(widget.targetLetters.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    int targetIndex = 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade300, width: 2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // 1. Icon
          Expanded(
            flex: 2,
            child: VectorGraphic(assetName: widget.icon, size: 64),
          ),
          const SizedBox(width: 16),
          
          // 2. Letters with Drop Targets
          Expanded(
            flex: 5,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: widget.word.split('').map((char) {
                if (char == '_') {
                  final currentTargetIndex = targetIndex;
                  final targetLetter = widget.targetLetters[currentTargetIndex];
                  final isFilled = _isFilledList[currentTargetIndex];
                  targetIndex++;

                  if (isFilled) {
                    return _buildFilledLetter(targetLetter);
                  }

                  return LetterDropTarget(
                    correctLetter: targetLetter,
                    onDropResult: (success, letterStr) {
                      if (success) {
                        setState(() => _isFilledList[currentTargetIndex] = true);
                      }
                    },
                  );
                }

                return Text(
                  char,
                  style: const TextStyle(
                    fontSize: 32,
                    fontFamily: 'FredokaOne',
                    color: Colors.black87,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilledLetter(String letter) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.yellow.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade300, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          fontFamily: 'FredokaOne',
          color: Colors.orange.shade800,
        ),
      ),
    );
  }
}
