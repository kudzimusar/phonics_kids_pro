import 'package:flutter/material.dart';

/// A43 & A47: Equation list for prefix/suffix building.
/// Layout (matching the physical textbook):
///   root + suffix = [oval input box]
///   Which means: [definition in bold]
///
/// Mode 'prefix': [prefix] + [root] = [blank]
/// Mode 'suffix': [root] + [suffix] = [blank]
class EquationBuilder extends StatefulWidget {
  final List<Map<String, dynamic>> entries;
  final String mode; // 'prefix' or 'suffix'

  const EquationBuilder({Key? key, required this.entries, required this.mode}) : super(key: key);

  @override
  State<EquationBuilder> createState() => _EquationBuilderState();
}

class _EquationBuilderState extends State<EquationBuilder> {
  late final List<TextEditingController> _controllers;
  late final List<bool?> _results;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.entries.length, (_) => TextEditingController());
    _results = List.generate(widget.entries.length, (_) => null);
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
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
      children: widget.entries.asMap().entries.map((entry) {
        final i = entry.key;
        final data = entry.value;
        final prefix = data['prefix'] as String? ?? '';
        final root = data['root'] as String? ?? '';
        final suffix = data['suffix'] as String? ?? '';
        final definition = data['definition'] as String? ?? '';
        final answer = data['answer'] as String;
        final result = _results[i];

        // Build the equation parts: leftLabel + "+" + rightLabel + "=" + [oval box]
        final leftLabel = widget.mode == 'prefix' ? prefix : root;
        final rightLabel = widget.mode == 'prefix' ? root : suffix;

        return Padding(
          padding: const EdgeInsets.only(bottom: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Equation row: left + right = [input or result]
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  Text(
                    leftLabel,
                    style: const TextStyle(
                      fontFamily: 'SassoonPrimary',
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Text(' + ', style: TextStyle(fontSize: 26, color: Colors.black54, fontWeight: FontWeight.bold)),
                  Text(
                    rightLabel,
                    style: const TextStyle(
                      fontFamily: 'SassoonPrimary',
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Text(' = ', style: TextStyle(fontSize: 26, color: Colors.black54, fontWeight: FontWeight.bold)),
                  // Oval input box or result box
                  if (result == null)
                    _OvalInputBox(
                      controller: _controllers[i],
                      answer: answer,
                      onSubmitted: (_) => _check(i),
                      onChanged: (_) => setState(() {}),
                    )
                  else
                    _OvalResultBox(answer: answer, isCorrect: result!),
                  if (result == null && _controllers[i].text.isNotEmpty)
                    GestureDetector(
                      onTap: () => _check(i),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade700,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('✓', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  if (result != null && !result!)
                    GestureDetector(
                      onTap: () => setState(() {
                        _results[i] = null;
                        _controllers[i].clear();
                      }),
                      child: const Icon(Icons.refresh, size: 22, color: Colors.red),
                    ),
                ],
              ),
              // "Which means: ..." line below the equation
              if (definition.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Which means: $definition',
                    style: const TextStyle(
                      fontFamily: 'SassoonPrimary',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

/// Oval pill-shaped input box — matches the textbook design.
class _OvalInputBox extends StatelessWidget {
  final TextEditingController controller;
  final String answer;
  final ValueChanged<String> onSubmitted;
  final ValueChanged<String> onChanged;

  const _OvalInputBox({
    required this.controller,
    required this.answer,
    required this.onSubmitted,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (answer.length * 18.0 + 60).clamp(100.0, 220.0),
      height: 48,
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
        maxLength: answer.length + 2,
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        style: const TextStyle(
          fontFamily: 'SassoonPrimary',
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}

/// Shows the result in an oval box (green = correct, red = wrong).
class _OvalResultBox extends StatelessWidget {
  final String answer;
  final bool isCorrect;

  const _OvalResultBox({required this.answer, required this.isCorrect});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isCorrect ? Colors.green.shade100 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isCorrect ? Colors.green : Colors.red,
          width: 2,
        ),
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
