import 'package:flutter/material.dart';

/// A44: Word Grid Underline — user taps a word to reveal/underline the prefix.
/// Open Wrap layout with free-response text fields below.
class WordGridUnderline extends StatefulWidget {
  final List<Map<String, dynamic>> entries;
  final int columns;
  final List<String> freeResponsePrompts;
  final String? freeResponseInstruction;

  const WordGridUnderline({
    Key? key,
    required this.entries,
    this.columns = 3,
    this.freeResponsePrompts = const [],
    this.freeResponseInstruction,
  }) : super(key: key);

  @override
  State<WordGridUnderline> createState() => _WordGridUnderlineState();
}

class _WordGridUnderlineState extends State<WordGridUnderline> {
  late final Set<String> _revealed;
  late final List<TextEditingController> _freeControllers;

  @override
  void initState() {
    super.initState();
    _revealed = {};
    _freeControllers = List.generate(widget.freeResponsePrompts.length, (_) => TextEditingController());
  }

  @override
  void dispose() {
    for (final c in _freeControllers) c.dispose();
    super.dispose();
  }

  Widget _buildWord(Map<String, dynamic> entry) {
    final word = entry['word'] as String;
    final prefix = entry['prefix'] as String;
    final isRevealed = _revealed.contains(word);

    final prefixLength = prefix.length;
    final before = word.substring(0, prefixLength);
    final after = word.substring(prefixLength);

    return GestureDetector(
      onTap: () => setState(() {
        if (_revealed.contains(word)) {
          _revealed.remove(word);
        } else {
          _revealed.add(word);
        }
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isRevealed ? Colors.orange.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isRevealed ? Colors.orange.shade400 : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(
              fontFamily: 'SassoonPrimary',
              fontSize: 26,
              color: Colors.black87,
            ),
            children: [
              if (isRevealed)
                TextSpan(
                  text: before,
                  style: const TextStyle(
                    color: Color(0xFFE65100),
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationColor: Color(0xFFE65100),
                    decorationThickness: 3,
                  ),
                )
              else
                TextSpan(text: before),
              TextSpan(text: after),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          children: widget.entries.map(_buildWord).toList(),
        ),
        if (widget.freeResponsePrompts.isNotEmpty) ...[
          const SizedBox(height: 24),
          if (widget.freeResponseInstruction != null)
            Text(
              widget.freeResponseInstruction!,
              style: const TextStyle(
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
            children: widget.freeResponsePrompts.asMap().entries.map((e) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.orange.shade300, width: 2),
                    ),
                    child: Text(
                      e.value,
                      style: const TextStyle(
                        fontFamily: 'SassoonPrimary',
                        fontSize: 22,
                        color: Color(0xFFE65100),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 80,
                    child: TextField(
                      controller: _freeControllers[e.key],
                      decoration: const InputDecoration(
                        hintText: '...',
                        border: UnderlineInputBorder(),
                      ),
                      style: const TextStyle(
                        fontFamily: 'SassoonPrimary',
                        fontSize: 22,
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
