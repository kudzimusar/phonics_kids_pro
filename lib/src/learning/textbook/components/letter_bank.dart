import 'package:flutter/material.dart';
import 'drag_drop_letter.dart';

class LetterBank extends StatelessWidget {
  final List<String> letters;
  final Set<String> usedLetters;

  const LetterBank({
    Key? key,
    required this.letters,
    required this.usedLetters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -4),
          )
        ],
      ),
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: letters
                .where((l) => !usedLetters.contains(l))
                .map((letter) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: DragDropLetter(
                    letter: letter,
                    color: _isVowel(letter) ? Colors.blue.shade100 : Colors.red.shade100,
                  ),
                )).toList(),
          ),
        ),
      ),
    );
  }

  bool _isVowel(String text) {
    if (text.isEmpty) return false;
    final firstChar = text.toLowerCase()[0];
    return 'aeiou'.contains(firstChar);
  }
}
