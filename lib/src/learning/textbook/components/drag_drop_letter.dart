import 'package:flutter/material.dart';
import 'phonics_box.dart';

class DragDropLetter extends StatelessWidget {
  final String letter;
  final Color? color;

  const DragDropLetter({Key? key, required this.letter, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Draggable<String>(
      data: letter,
      feedback: Material(
        color: Colors.transparent,
        child: Transform.scale(
          scale: 1.1,
          child: Opacity(
            opacity: 0.9,
            child: PhonicsBox(text: letter, type: BoxType.small, backgroundColor: color),
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: PhonicsBox(text: letter, type: BoxType.small, backgroundColor: color),
      ),
      child: PhonicsBox(text: letter, type: BoxType.small, backgroundColor: color),
    );
  }
}
