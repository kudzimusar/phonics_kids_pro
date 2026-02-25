import 'package:flutter/material.dart';

class IdentifySort extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  /* Example item:
    {
      'word': 'baby',
      'emoji': '👶',
      'answer': 'vowel', // 'vowel' or 'consonant'
    }
  */

  const IdentifySort({Key? key, required this.items}) : super(key: key);

  @override
  State<IdentifySort> createState() => _IdentifySortState();
}

class _IdentifySortState extends State<IdentifySort> {
  // Store the user's selected choice for each item. null = unselected.
  late List<String?> _selections;

  @override
  void initState() {
    super.initState();
    _selections = List.generate(widget.items.length, (_) => null);
  }

  void _selectChoice(int index, String choice) {
    setState(() {
      _selections[index] = choice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 32,
        mainAxisSpacing: 32,
      ),
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        final item = widget.items[index];
        final selection = _selections[index];
        
        return Container(
          decoration: BoxDecoration(
            color: Colors.transparent, // No box around items in the PDF
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Emoji
              Text(
                item['emoji'] ?? '❓', // Fallback emoji
                style: const TextStyle(fontSize: 80),
              ),
              const SizedBox(height: 16),
              
              // Word with bolded 'y'
              _buildHighlightedWord(item['word'], 'y'),
              const SizedBox(height: 8),
              
              // Vowel or consonant selector
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSelectableText(index, "vowel", selection),
                  const Text(
                    " or ", 
                    style: TextStyle(
                      fontSize: 24, 
                      fontFamily: 'SassoonPrimary', 
                      color: Colors.black87
                    ),
                  ),
                  _buildSelectableText(index, "consonant", selection),
                  const Text(
                    "?", 
                    style: TextStyle(
                      fontSize: 24, 
                      fontFamily: 'SassoonPrimary', 
                      color: Colors.black87
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHighlightedWord(String word, String letterToHighlight) {
    final spans = <TextSpan>[];
    for (int i = 0; i < word.length; i++) {
      final char = word[i];
      if (char.toLowerCase() == letterToHighlight.toLowerCase()) {
        spans.add(TextSpan(
          text: char,
          style: const TextStyle(
            color: Colors.black, 
            fontWeight: FontWeight.w900, // Extra bold 'y'
          ),
        ));
      } else {
        spans.add(TextSpan(
          text: char, 
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.normal,
          ),
        ));
      }
    }

    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 36, fontFamily: 'FredokaOne'),
        children: spans,
      ),
    );
  }

  Widget _buildSelectableText(int index, String choiceText, String? currentSelection) {
    final isSelected = currentSelection == choiceText;
    
    return GestureDetector(
      onTap: () => _selectChoice(index, choiceText),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          // Simulate circling the answer
          border: isSelected 
              ? Border.all(color: Colors.pinkAccent, width: 3) 
              : Border.all(color: Colors.transparent, width: 3),
          borderRadius: BorderRadius.circular(20), // Oval circling
        ),
        child: Text(
          choiceText,
          style: const TextStyle(
            fontSize: 26,
            fontFamily: 'SassoonPrimary', // Using the body font
            color: Colors.black87,
            decoration: TextDecoration.underline, // Underlined in the PDF design
            decorationStyle: TextDecorationStyle.solid,
            decorationColor: Colors.blueGrey,
          ),
        ),
      ),
    );
  }
}
