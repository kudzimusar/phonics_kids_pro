import 'package:flutter/material.dart';
import 'vector_graphic.dart';

class IdentifySort extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final String leftChoice;
  final String rightChoice;
  final String highlightKey; // Key in the item map for what string to highlight
  final bool useVectorGraphic; 

  const IdentifySort({
    Key? key, 
    required this.items,
    this.leftChoice = 'vowel',
    this.rightChoice = 'consonant',
    this.highlightKey = 'y',
    this.useVectorGraphic = false,
  }) : super(key: key);

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
              // Emoji or VectorGraphic
              if (widget.useVectorGraphic)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: VectorGraphic(assetName: item['imageId'] as String, size: 80),
                )
              else
                Text(
                  item['emoji'] ?? '❓', // Fallback emoji
                  style: const TextStyle(fontSize: 80),
                ),
              if (!widget.useVectorGraphic)
                const SizedBox(height: 16),
              
              // Word with bolded target string
              _buildHighlightedWord(item['word'], item[widget.highlightKey] ?? widget.highlightKey),
              const SizedBox(height: 8),
              
              // Vowel or consonant selector
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSelectableText(index, widget.leftChoice, selection),
                  const Text(
                    " or ", 
                    style: TextStyle(
                      fontSize: 24, 
                      fontFamily: 'FredokaOne', 
                      color: Colors.black54
                    ),
                  ),
                  _buildSelectableText(index, widget.rightChoice, selection),
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

  Widget _buildHighlightedWord(String word, String stringToHighlight) {
    if (stringToHighlight.length == 1) {
      final spans = <TextSpan>[];
      for (int i = 0; i < word.length; i++) {
        final char = word[i];
        if (char.toLowerCase() == stringToHighlight.toLowerCase()) {
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
    } else {
      // Highlighting a substring (blend/digraph)
      final lowerWord = word.toLowerCase();
      final lowerTarget = stringToHighlight.toLowerCase();
      final startIndex = lowerWord.indexOf(lowerTarget);
      
      if (startIndex == -1) {
        return Text(word, style: const TextStyle(fontSize: 36, fontFamily: 'FredokaOne'));
      }

      final endIndex = startIndex + stringToHighlight.length;

      return RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 36, fontFamily: 'FredokaOne'),
          children: [
            TextSpan(
              text: word.substring(0, startIndex),
              style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.normal),
            ),
            TextSpan(
              text: word.substring(startIndex, endIndex),
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
                decoration: TextDecoration.underline,
              ),
            ),
            TextSpan(
              text: word.substring(endIndex),
              style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildSelectableText(int index, String choiceText, String? currentSelection) {
    final isSelected = currentSelection == choiceText;
    
    return GestureDetector(
      onTap: () => _selectChoice(index, choiceText),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          // Simulate circling the answer
          border: isSelected 
              ? Border.all(color: Colors.green.shade500, width: 3) 
              : Border.all(color: Colors.transparent, width: 3),
          borderRadius: BorderRadius.circular(20), // Oval circling
          color: isSelected ? Colors.green.shade50 : Colors.transparent,

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
