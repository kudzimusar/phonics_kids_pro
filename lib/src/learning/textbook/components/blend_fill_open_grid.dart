import 'package:flutter/material.dart';
import 'vector_graphic.dart';
import '../utils/responsive_helper.dart';

/// A33: Finish The Word — Open, clean layout
/// No card containers. Each item: large image, dashed partial word with input for blend.
/// Matches the physical textbook Page 36 layout exactly.
class BlendFillOpenGrid extends StatefulWidget {
  final List<Map<String, dynamic>> entries;
  final int columns;

  const BlendFillOpenGrid({
    Key? key,
    required this.entries,
    this.columns = 3,
  }) : super(key: key);

  @override
  State<BlendFillOpenGrid> createState() => _BlendFillOpenGridState();
}

class _BlendFillOpenGridState extends State<BlendFillOpenGrid> {
  late List<TextEditingController> _controllers;
  late List<bool?> _results;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.entries.length, (_) => TextEditingController());
    _results = List.generate(widget.entries.length, (_) => null);
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _checkAnswer(int index) {
    final answer = widget.entries[index]['answer'] as String;
    setState(() {
      _results[index] = _controllers[index].text.trim().toLowerCase() == answer.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colCount = ResponsiveHelper.getResponsiveGridCount(
      context: context,
      mobile: 2,
      tablet: widget.columns,
      desktop: widget.columns,
    );

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: colCount,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: widget.entries.length,
      itemBuilder: (context, index) {
        final entry = widget.entries[index];
        final imageId = entry['imageId'] as String;
        final partial = entry['partial'] as String; // e.g. "__ove"
        final answer = entry['answer'] as String;   // e.g. "gl"
        final result = _results[index];

        // Split the partial around the blank
        // partial like "__ove" -> prefix="", suffix="ove"
        // partial like "ta__e" -> prefix="ta", suffix="e"
        final blanks = partial.split('__');
        final prefix = blanks.isNotEmpty ? blanks[0] : '';
        final suffix = blanks.length > 1 ? blanks[1] : '';

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image — open, no container
            Expanded(
              flex: 3,
              child: VectorGraphic(assetName: imageId, size: 110),
            ),
            const SizedBox(height: 8),
            // Word row: prefix + dashed input + suffix
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (prefix.isNotEmpty)
                  Text(
                    prefix,
                    style: TextStyle(
                      fontFamily: 'SassoonPrimary',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: result == true ? Colors.green.shade700 : Colors.black87,
                    ),
                  ),
                // Dashed input box for the blend
                SizedBox(
                  width: 70,
                  child: TextField(
                    controller: _controllers[index],
                    textAlign: TextAlign.center,
                    maxLength: 3,
                    style: TextStyle(
                      fontFamily: 'SassoonPrimary',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: result == null
                          ? Colors.blue.shade700
                          : (result == true ? Colors.green.shade700 : Colors.red.shade600),
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: answer.split('').map((_) => '_').join(),
                      hintStyle: const TextStyle(color: Color(0xFF888888), fontSize: 28),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black54, width: 3),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue.shade400, width: 3),
                      ),
                    ),
                    onChanged: (_) => _checkAnswer(index),
                  ),
                ),
                if (suffix.isNotEmpty)
                  Text(
                    suffix,
                    style: TextStyle(
                      fontFamily: 'SassoonPrimary',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: result == true ? Colors.green.shade700 : Colors.black87,
                    ),
                  ),
              ],
            ),
            // Correct/incorrect feedback icon
            if (result != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Icon(
                  result == true ? Icons.check_circle_rounded : Icons.cancel_rounded,
                  color: result == true ? Colors.green : Colors.redAccent,
                  size: 24,
                ),
              ),
          ],
        );
      },
    );
  }
}
