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
          scale: 1.15,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 15,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
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
