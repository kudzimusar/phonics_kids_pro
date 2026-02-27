import 'package:flutter/material.dart';
import 'vector_graphic.dart';

/// A39 (top): Picture Name Grid — image + dash lines for letter count.
/// Large image, dashes rendered as actual dash marks below the image.
/// User taps the image/dashes area → full text field appears → types the word.
class PictureNameGrid extends StatefulWidget {
  final List<Map<String, dynamic>> entries;
  final int columns;

  const PictureNameGrid({Key? key, required this.entries, this.columns = 2}) : super(key: key);

  @override
  State<PictureNameGrid> createState() => _PictureNameGridState();
}

class _PictureNameGridState extends State<PictureNameGrid> {
  late final List<TextEditingController> _controllers;
  late final List<bool?> _results;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.entries.length, (_) => TextEditingController());
    _results = List.generate(widget.entries.length, (_) => null);
    _focusNodes = List.generate(widget.entries.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  void _check(int i) {
    final answer = widget.entries[i]['answer'] as String;
    setState(() => _results[i] = _controllers[i].text.toLowerCase().trim() == answer.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.columns,
        childAspectRatio: 0.8,
        crossAxisSpacing: 24,
        mainAxisSpacing: 16,
      ),
      itemCount: widget.entries.length,
      itemBuilder: (context, i) {
        final entry = widget.entries[i];
        final imageId = entry['imageId'] as String;
        final answer = entry['answer'] as String;
        final blanks = (entry['blanks'] as int?) ?? answer.length;
        final result = _results[i];

        return GestureDetector(
          onTap: () => _focusNodes[i].requestFocus(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Large image — no container, open
              Expanded(
                flex: 5,
                child: Center(
                  child: VectorGraphic(assetName: imageId, size: 120),
                ),
              ),
              const SizedBox(height: 12),
              // Dashes or typed letters — mimics the physical textbook dashes
              if (result == true)
                Text(
                  answer.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'SassoonPrimary',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                )
              else ...[
                // Shows dashes + typed letters overlaid
                SizedBox(
                  height: 44,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      // Dash row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(blanks, (li) {
                          return Container(
                            width: 28,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            alignment: Alignment.bottomCenter,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Letter if typed
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: Text(
                                    _controllers[i].text.length > li
                                        ? _controllers[i].text[li].toUpperCase()
                                        : '',
                                    style: const TextStyle(
                                      fontFamily: 'SassoonPrimary',
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                // Dash line
                                Container(height: 2.5, color: Colors.black87),
                              ],
                            ),
                          );
                        }),
                      ),
                      // Invisible text field captures typing
                      SizedBox(
                        width: 120,
                        child: TextField(
                          controller: _controllers[i],
                          focusNode: _focusNodes[i],
                          maxLength: blanks,
                          onChanged: (_) => setState(() {}),
                          onSubmitted: (_) => _check(i),
                          decoration: const InputDecoration(
                            counterText: '',
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(color: Colors.transparent, fontSize: 1),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _check(i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade600,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('Check', style: TextStyle(color: Colors.white, fontFamily: 'SassoonPrimary', fontSize: 16)),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

/// A39 (bottom): Riddle Fill List — numbered riddle clues with dash blanks.
/// Matches the physical textbook: write the diphthong word that answers the clue.
class RiddleFillList extends StatefulWidget {
  final String instruction;
  final List<Map<String, dynamic>> riddles;

  const RiddleFillList({Key? key, required this.instruction, required this.riddles}) : super(key: key);

  @override
  State<RiddleFillList> createState() => _RiddleFillListState();
}

class _RiddleFillListState extends State<RiddleFillList> {
  late final List<TextEditingController> _controllers;
  late final List<bool?> _results;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.riddles.length, (_) => TextEditingController());
    _results = List.generate(widget.riddles.length, (_) => null);
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    super.dispose();
  }

  void _check(int i) {
    final answer = widget.riddles[i]['answer'] as String;
    setState(() => _results[i] = _controllers[i].text.toLowerCase().trim() == answer.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            widget.instruction,
            style: const TextStyle(
              fontFamily: 'SassoonPrimary',
              fontSize: 20,
              color: Colors.black54,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        ...widget.riddles.asMap().entries.map((entry) {
          final i = entry.key;
          final riddle = entry.value;
          final clue = riddle['clue'] as String;
          final answer = riddle['answer'] as String;
          final result = _results[i];

          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Clue text — inline with dash blanks after it
                Text(
                  clue,
                  style: const TextStyle(
                    fontFamily: 'SassoonPrimary',
                    fontSize: 22,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                // Answer area — dash lines or result
                if (result != null)
                  Text(
                    result! ? '✓  ${answer.toUpperCase()}' : '✗  ${answer.toUpperCase()}',
                    style: TextStyle(
                      fontFamily: 'SassoonPrimary',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: result! ? Colors.green.shade700 : Colors.red,
                    ),
                  )
                else
                  Row(
                    children: [
                      // Dash blanks
                      ...List.generate(answer.length, (li) => Container(
                        width: 28,
                        height: 2.5,
                        margin: const EdgeInsets.only(right: 6),
                        color: Colors.black87,
                      )),
                      const SizedBox(width: 12),
                      // Text input
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: TextField(
                            controller: _controllers[i],
                            onSubmitted: (_) => _check(i),
                            maxLength: answer.length + 2,
                            decoration: InputDecoration(
                              counterText: '',
                              border: const UnderlineInputBorder(),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.indigo.shade300, width: 2),
                              ),
                              hintText: 'type here',
                              hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            style: const TextStyle(fontFamily: 'SassoonPrimary', fontSize: 22),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _check(i),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          margin: const EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                            color: Colors.indigo.shade600,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text('✓', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}
