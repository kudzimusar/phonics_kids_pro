import 'package:flutter/material.dart';
import 'vector_graphic.dart';
import 'letter_drop_target.dart';

class CharmBraceletRow extends StatefulWidget {
  final String icon;
  final List<String> letters; // '?' represents the blank/target letter
  final List<String> targetLetters; // If multiple blanks, list them in order

  const CharmBraceletRow({
    Key? key,
    required this.icon,
    required this.letters,
    required this.targetLetters,
  }) : super(key: key);

  @override
  State<CharmBraceletRow> createState() => _CharmBraceletRowState();
}

class _CharmBraceletRowState extends State<CharmBraceletRow> {
  late List<bool> _isFilledList;

  @override
  void initState() {
    super.initState();
    _isFilledList = List.generate(widget.letters.where((l) => l == '?').length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    int targetIndex = 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // The background chain line
          Positioned(
            left: 40,
            right: 0,
            top: 20,
            child: Container(
              height: 4,
              color: Colors.blueGrey.shade800,
            ),
          ),
          
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Icon (The Charm hanger)
              Column(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blueGrey.shade800, width: 4),
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    width: 4,
                    height: 16,
                    color: Colors.blueGrey.shade800,
                  ),
                  VectorGraphic(assetName: widget.icon, size: 64),
                ],
              ),
              const SizedBox(width: 24),

              // 2. Chained Square Letters
              Expanded(
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: widget.letters.map((letter) {
                    if (letter == '?') {
                      final currentTargetIndex = targetIndex;
                      final targetLetter = widget.targetLetters[currentTargetIndex];
                      final isFilled = _isFilledList[currentTargetIndex];
                      targetIndex++;

                      return Column(
                        children: [
                          Container(
                            width: 24,
                            height: 12,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueGrey.shade800, width: 3),
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            width: 4,
                            height: 16,
                            color: Colors.blueGrey.shade800,
                          ),
                          if (isFilled)
                            CharmSquare(letter: targetLetter, isTarget: true)
                          else
                            LetterDropTarget(
                              correctLetter: targetLetter,
                              onDropResult: (success, letterStr) {
                                if (success) {
                                  setState(() => _isFilledList[currentTargetIndex] = true);
                                }
                              },
                            )
                        ],
                      );
                    }
                    
                    return Column(
                      children: [
                        Container(
                          width: 24,
                          height: 12,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueGrey.shade800, width: 3),
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          width: 4,
                          height: 16,
                          color: Colors.blueGrey.shade800,
                        ),
                        CharmSquare(letter: letter),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CharmSquare extends StatelessWidget {
  final String letter;
  final bool isTarget;

  const CharmSquare({
    Key? key,
    required this.letter,
    this.isTarget = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: isTarget ? Colors.yellow.shade100 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blueGrey.shade800, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 4,
          )
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          fontFamily: 'FredokaOne',
          color: isTarget ? Colors.orange.shade800 : Colors.blueGrey.shade900,
        ),
      ),
    );
  }
}
