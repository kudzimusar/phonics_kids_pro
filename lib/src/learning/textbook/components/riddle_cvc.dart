import 'package:flutter/material.dart';

class RiddleCvc extends StatefulWidget {
  final List<Map<String, dynamic>> riddles;
  /* Example riddle:
    {
      'clue': 'I have a shell.',
      'answer': 'crab',
    }
  */

  const RiddleCvc({
    Key? key,
    required this.riddles,
  }) : super(key: key);

  @override
  State<RiddleCvc> createState() => _RiddleCvcState();
}

class _RiddleCvcState extends State<RiddleCvc> {
  // Store user's written answer for each riddle
  late List<String> _answers;

  @override
  void initState() {
    super.initState();
    _answers = List.generate(widget.riddles.length, (_) => '');
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: widget.riddles.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final riddle = widget.riddles[index];
        final clueText = riddle['clue'] as String;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // The riddle text
            Expanded(
              flex: 2,
              child: Text(
                "${index + 1}. $clueText",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            
            const SizedBox(width: 16),
            
            // The fill-in-the-blank field
            Expanded(
              flex: 1,
              child: Container(
                height: 50,
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black87, width: 2)),
                ),
                child: TextField(
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 28, 
                    fontWeight: FontWeight.bold, 
                    fontFamily: 'SassoonPrimary', 
                    color: Colors.blue
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(bottom: 8),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _answers[index] = val;
                    });
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
