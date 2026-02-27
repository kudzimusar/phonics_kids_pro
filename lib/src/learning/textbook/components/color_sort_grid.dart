import 'package:flutter/material.dart';

/// A41: Glued Sounds Color Sort
/// Color-coded key + word grid. User taps a word chip to cycle through the 4 colors.
/// Correct color = ✓. Open layout, 22px touch-friendly font.
class ColorSortGrid extends StatefulWidget {
  final List<Map<String, dynamic>> codes; // {label, color}
  final List<Map<String, dynamic>> words; // {word, gluedSound, answer}
  final String? instruction;
  final List<String> freePrompts;

  const ColorSortGrid({
    Key? key,
    required this.codes,
    required this.words,
    this.instruction,
    this.freePrompts = const [],
  }) : super(key: key);

  @override
  State<ColorSortGrid> createState() => _ColorSortGridState();
}

class _ColorSortGridState extends State<ColorSortGrid> {
  // Map word -> selected color label (null = unselected)
  late final Map<String, String?> _selected;
  final Map<String, TextEditingController> _freeControllers = {};

  static const Map<String, Color> _colorMap = {
    'Red': Color(0xFFEF5350),
    'Blue': Color(0xFF1E88E5),
    'Green': Color(0xFF43A047),
    'Purple': Color(0xFF8E24AA),
  };

  static const Map<String, Color> _lightColorMap = {
    'Red': Color(0xFFFFCDD2),
    'Blue': Color(0xFFBBDEFB),
    'Green': Color(0xFFC8E6C9),
    'Purple': Color(0xFFE1BEE7),
  };

  @override
  void initState() {
    super.initState();
    _selected = {for (final w in widget.words) (w['word'] as String): null};
    for (final p in widget.freePrompts) {
      _freeControllers[p] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (final c in _freeControllers.values) c.dispose();
    super.dispose();
  }

  void _tapWord(String word) {
    final colorLabels = widget.codes.map((c) => c['color'] as String).toList();
    final current = _selected[word];
    final currentIndex = current == null ? -1 : colorLabels.indexOf(current);
    final nextIndex = (currentIndex + 1) % (colorLabels.length + 1);
    setState(() {
      _selected[word] = nextIndex == colorLabels.length ? null : colorLabels[nextIndex];
    });
  }

  bool _isCorrect(Map<String, dynamic> wordData) {
    final word = wordData['word'] as String;
    final answer = wordData['answer'] as String;
    return _selected[word] == answer;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Color key row
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Wrap(
            spacing: 16,
            runSpacing: 8,
            children: widget.codes.map((code) {
              final label = code['label'] as String;
              final colorLabel = code['color'] as String;
              final color = _colorMap[colorLabel] ?? Colors.grey;
              final lightColor = _lightColorMap[colorLabel] ?? Colors.grey.shade100;

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  color: lightColor,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: color, width: 2.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 18, height: 18, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Text(
                      label,
                      style: TextStyle(
                        fontFamily: 'SassoonPrimary',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        // Word grid
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: widget.words.map((wordData) {
            final word = wordData['word'] as String;
            final colorLabel = _selected[word];
            final correct = colorLabel != null && _isCorrect(wordData);

            final bgColor = colorLabel != null
                ? (_lightColorMap[colorLabel] ?? Colors.grey.shade100)
                : Colors.grey.shade100;
            final borderColor = colorLabel != null
                ? (_colorMap[colorLabel] ?? Colors.grey)
                : Colors.grey.shade300;

            return GestureDetector(
              onTap: () => _tapWord(word),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor, width: 2.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      word,
                      style: const TextStyle(
                        fontFamily: 'SassoonPrimary',
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    if (correct) ...[
                      const SizedBox(width: 6),
                      const Icon(Icons.check_circle, color: Colors.green, size: 20),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        // Free response prompts
        if (widget.freePrompts.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(
            'Write another word for each sound:',
            style: TextStyle(
              fontFamily: 'SassoonPrimary',
              fontSize: 20,
              fontStyle: FontStyle.italic,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: widget.freePrompts.map((prompt) {
              final color = widget.codes.firstWhere(
                (c) => (c['label'] as String).toLowerCase() == prompt.toLowerCase(),
                orElse: () => {'color': 'Blue'},
              )['color'] as String;
              final accentColor = _colorMap[color] ?? Colors.blue;

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: (_lightColorMap[color] ?? Colors.blue.shade50),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: accentColor, width: 2),
                    ),
                    child: Text(
                      prompt,
                      style: TextStyle(
                        fontFamily: 'SassoonPrimary',
                        fontSize: 20,
                        color: accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 120,
                    child: TextField(
                      controller: _freeControllers[prompt],
                      decoration: InputDecoration(
                        hintText: 'your word',
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: accentColor, width: 2),
                        ),
                      ),
                      style: const TextStyle(
                        fontFamily: 'SassoonPrimary',
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
