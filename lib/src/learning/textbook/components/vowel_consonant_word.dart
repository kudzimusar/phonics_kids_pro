import 'package:flutter/material.dart';

class VowelConsonantWord extends StatefulWidget {
  final String word;

  const VowelConsonantWord({Key? key, required this.word}) : super(key: key);

  @override
  State<VowelConsonantWord> createState() => _VowelConsonantWordState();
}

class _VowelConsonantWordState extends State<VowelConsonantWord> {
  // Store the selected state of each character
  late List<bool> _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = List.filled(widget.word.length, false);
  }

  bool _isVowel(String char) {
    return 'aeiouy'.contains(char.toLowerCase());
  }

  void _toggleChar(int index) {
    setState(() {
      _isSelected[index] = !_isSelected[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 4,
          )
        ],
      ),
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        alignment: WrapAlignment.center,
        children: List.generate(widget.word.length, (index) {
          final char = widget.word[index];
          final isSelected = _isSelected[index];
          final isVowelVal = _isVowel(char);
          
          Color bgColor = Colors.transparent;
          Color borderColor = Colors.transparent;
          Color textColor = Colors.black87;

          if (isSelected) {
            if (isVowelVal) {
              bgColor = Colors.blue.shade50;
              borderColor = Colors.blue.shade300;
              textColor = Colors.blue.shade800;
            } else {
              bgColor = Colors.red.shade50;
              borderColor = Colors.red.shade300;
              textColor = Colors.red.shade800;
            }
          }

          return GestureDetector(
            onTap: () => _toggleChar(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 36,
              height: 48,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? borderColor : Colors.grey.shade200, 
                  width: 2
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                char,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  fontFamily: 'FredokaOne',
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
