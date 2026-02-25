import 'package:flutter/material.dart';

class PhonicFoxNarrator extends StatefulWidget {
  final String text;
  final FoxState state;

  const PhonicFoxNarrator({
    Key? key,
    required this.text,
    this.state = FoxState.idle,
  }) : super(key: key);

  @override
  State<PhonicFoxNarrator> createState() => _PhonicFoxNarratorState();
}

class _PhonicFoxNarratorState extends State<PhonicFoxNarrator> {
  // This will later contain the Rive animation controller
  
  @override
  Widget build(BuildContext context) {
    String emoji = "🦊";
    if (widget.state == FoxState.openMouth) {
      emoji = "🦊😮";
    } else if (widget.state == FoxState.success) {
      emoji = "🦊✨";
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.shade300, width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Image.network(
                'https://img.icons8.com/fluency/96/fox.png',
                width: 64,
                height: 64,
              ),
              if (widget.state == FoxState.success)
                Positioned(
                  top: -5,
                  right: -5,
                  child: Image.network(
                    'https://img.icons8.com/fluency/48/sparkling.png',
                    width: 24,
                    height: 24,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.orange.shade100, width: 2),
              ),
              child: Text(
                widget.text,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.orange.shade900,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'FredokaOne',
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

enum FoxState {
  idle,
  openMouth,
  success,
  error
}
