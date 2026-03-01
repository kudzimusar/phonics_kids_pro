import 'package:flutter/material.dart';

class InteractiveVowelStack extends StatefulWidget {
  final String wordPart1;
  final String wordPart2;
  final List<String> choices;
  final String answer;
  final bool isSolved;
  final ValueChanged<bool>? onStatusChanged;

  const InteractiveVowelStack({
    Key? key,
    required this.wordPart1,
    required this.wordPart2,
    required this.choices,
    required this.answer,
    this.isSolved = false,
    this.onStatusChanged,
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
    if (widget.isSolved) return;
    if (choice == widget.answer) {
      setState(() {
        _selectedLetter = choice;
      });
      widget.onStatusChanged?.call(true);
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
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(vertical: 6.0),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: isCorrectSelected ? Colors.blue.shade100 : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: isCorrectSelected ? Colors.blue.shade400 : Colors.grey.shade300,
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isCorrectSelected ? Colors.blue.withOpacity(0.2) : Colors.black12,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
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
                          fontWeight: FontWeight.bold,
                          shadows: isCorrectSelected ? null : [
                            Shadow(offset: const Offset(-0.8, -0.8), color: Colors.blueGrey.shade200),
                            Shadow(offset: const Offset(0.8, -0.8), color: Colors.blueGrey.shade200),
                            Shadow(offset: const Offset(0.8, 0.8), color: Colors.blueGrey.shade200),
                            Shadow(offset: const Offset(-0.8, 0.8), color: Colors.blueGrey.shade200),
                          ],
                        ),
                      ),
                      // Solid colored top layer when selected
                      if (isCorrectSelected)
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.elasticOut,
                          builder: (context, val, child) {
                            return Transform.scale(scale: 0.8 + (0.2 * val), child: child);
                          },
                          child: Text(
                            choice,
                            style: TextStyle(
                              fontSize: 48,
                              fontFamily: 'SassoonPrimary',
                              color: Colors.blue.shade800,
                              fontWeight: FontWeight.bold,
                            ),
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
