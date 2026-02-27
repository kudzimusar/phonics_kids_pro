import 'package:flutter/material.dart';

/// A45: Reread It (Prefix Fill) — Definition → oval input box layout.
/// Matches the textbook exactly:
///   Example (read-only): "To wind again.  [rewind]" (in bold+underline)
///   Fill-in rows: "To play again.  [oval pill box]"
///   Open-ended creative prompt in a bordered rectangle at the bottom.
class DefinitionFillList extends StatefulWidget {
  final List<Map<String, dynamic>> entries;
  final Map<String, dynamic>? example;
  final String? openEndedPrompt;

  const DefinitionFillList({
    Key? key,
    required this.entries,
    this.example,
    this.openEndedPrompt,
  }) : super(key: key);

  @override
  State<DefinitionFillList> createState() => _DefinitionFillListState();
}

class _DefinitionFillListState extends State<DefinitionFillList> {
  late final List<TextEditingController> _controllers;
  late final List<bool?> _results;
  final TextEditingController _openController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.entries.length, (_) => TextEditingController());
    _results = List.generate(widget.entries.length, (_) => null);
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    _openController.dispose();
    super.dispose();
  }

  void _check(int i) {
    final answer = widget.entries[i]['answer'] as String;
    setState(() => _results[i] = _controllers[i].text.toLowerCase().trim() == answer.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── Example row (read-only, shows the answer in bold+underline) ───
        if (widget.example != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    widget.example!['definition'] as String? ?? '',
                    style: const TextStyle(
                      fontFamily: 'SassoonPrimary',
                      fontSize: 22,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  widget.example!['answer'] as String? ?? '',
                  style: const TextStyle(
                    fontFamily: 'SassoonPrimary',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    decoration: TextDecoration.underline,
                    decorationThickness: 2,
                  ),
                ),
              ],
            ),
          ),

        // ─── Fill-in rows ───
        ...widget.entries.asMap().entries.map((entry) {
          final i = entry.key;
          final data = entry.value;
          final definition = data['definition'] as String;
          final answer = data['answer'] as String;
          final result = _results[i];

          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    definition,
                    style: const TextStyle(
                      fontFamily: 'SassoonPrimary',
                      fontSize: 22,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                if (result == null)
                  _OvalInputBox(
                    controller: _controllers[i],
                    answer: answer,
                    onSubmitted: (_) => _check(i),
                    onChanged: (_) => setState(() {}),
                    hasInput: _controllers[i].text.isNotEmpty,
                    onCheck: () => _check(i),
                  )
                else
                  _OvalRevealedBox(answer: answer, isCorrect: result!),
              ],
            ),
          );
        }).toList(),

        // ─── Open-ended creative prompt at the bottom ───
        if (widget.openEndedPrompt != null) ...[
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black87, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.openEndedPrompt!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'SassoonPrimary',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _openController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Write your ideas here...',
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.5),
                    ),
                  ),
                  style: const TextStyle(fontFamily: 'SassoonPrimary', fontSize: 20),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

/// Oval pill-shaped bordered input box — matches the physical textbook A45 design.
class _OvalInputBox extends StatelessWidget {
  final TextEditingController controller;
  final String answer;
  final ValueChanged<String> onSubmitted;
  final ValueChanged<String> onChanged;
  final bool hasInput;
  final VoidCallback onCheck;

  const _OvalInputBox({
    required this.controller,
    required this.answer,
    required this.onSubmitted,
    required this.onChanged,
    required this.hasInput,
    required this.onCheck,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: (answer.length * 16.0 + 60).clamp(130.0, 220.0),
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.black87, width: 2),
          ),
          alignment: Alignment.center,
          child: TextField(
            controller: controller,
            onSubmitted: onSubmitted,
            onChanged: onChanged,
            textAlign: TextAlign.center,
            maxLength: answer.length + 3,
            decoration: const InputDecoration(
              counterText: '',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
            ),
            style: const TextStyle(
              fontFamily: 'SassoonPrimary',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        if (hasInput) ...[
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onCheck,
            child: const Icon(Icons.check_circle_outline, color: Colors.indigo, size: 28),
          ),
        ],
      ],
    );
  }
}

/// Shows a revealed answer in an oval box — green if correct, red if wrong.
class _OvalRevealedBox extends StatelessWidget {
  final String answer;
  final bool isCorrect;

  const _OvalRevealedBox({required this.answer, required this.isCorrect});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isCorrect ? Colors.green.shade100 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: isCorrect ? Colors.green : Colors.red, width: 2),
      ),
      child: Text(
        isCorrect ? answer : '✗ $answer',
        style: TextStyle(
          fontFamily: 'SassoonPrimary',
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: isCorrect ? Colors.green.shade800 : Colors.red,
        ),
      ),
    );
  }
}
