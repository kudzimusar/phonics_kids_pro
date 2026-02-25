import 'package:flutter/material.dart';

class InteractiveVowelStack extends StatefulWidget {
  final String wordPart1;
  final String wordPart2;
  final List<String> choices;
  final String answer;
  final bool isSolved; // e.g. the first one 'cow' is done for them

  const InteractiveVowelStack({
    Key? key,
    required this.wordPart1,
    required this.wordPart2,
    required this.choices,
    required this.answer,
    this.isSolved = false,
  }) : super(key: key);

  @override
  State<InteractiveVowelStack> createState() => _InteractiveVowelStackState();
}

class _InteractiveVowelStackState extends State<InteractiveVowelStack> {
  String? _selectedLetter;

  @override
  void initState() {
    super.initState();
    if (widget.isSolved) {
      _selectedLetter = widget.answer;
    }
  }

  void _handleTap(String choice) {
    if (widget.isSolved) return; // Already solved
    
    if (choice == widget.answer) {
      setState(() {
        _selectedLetter = choice;
      });
      // TODO: Success sound or Fox animation
    } else {
      // TODO: Error sound or Fox animation
      // We could add a shake animation here, but for now just visual feedback
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.wordPart1,
            style: const TextStyle(
              fontSize: 64,
              fontFamily: 'FredokaOne',
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 8),
          
          // The Stack of Vowel Choices
          Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.choices.map((choice) {
              final isCorrectSelected = _selectedLetter == choice;
              
              return GestureDetector(
                onTap: () => _handleTap(choice),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Tracing dashed/hollow base layer
                      Text(
                        choice,
                        style: TextStyle(
                          fontSize: 48,
                          fontFamily: 'SassoonPrimary',
                          color: isCorrectSelected ? Colors.transparent : Colors.grey.shade400,
                          // Use dashed or hollow font styling if available; here simulating with grey and outline
                          shadows: isCorrectSelected ? null : [
                            const Shadow(offset: Offset(-1, -1), color: Colors.blueGrey),
                            const Shadow(offset: Offset(1, -1), color: Colors.blueGrey),
                            const Shadow(offset: Offset(1, 1), color: Colors.blueGrey),
                            const Shadow(offset: Offset(-1, 1), color: Colors.blueGrey),
                          ],
                        ),
                      ),
                      // Solid colored top layer when selected
                      if (isCorrectSelected)
                        Text(
                          choice,
                          style: const TextStyle(
                            fontSize: 48,
                            fontFamily: 'SassoonPrimary',
                            color: Colors.blue, // 'Filled in' color
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(width: 8),
          Text(
            widget.wordPart2,
            style: const TextStyle(
              fontSize: 64,
              fontFamily: 'FredokaOne',
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
