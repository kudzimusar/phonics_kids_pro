import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LetterDropTarget extends StatefulWidget {
  final String correctLetter;
  final void Function(bool success, String droppedString)? onDropResult;

  const LetterDropTarget({
    Key? key,
    required this.correctLetter,
    this.onDropResult,
  }) : super(key: key);

  @override
  State<LetterDropTarget> createState() => _LetterDropTargetState();
}

class _LetterDropTargetState extends State<LetterDropTarget> {
  String? _droppedLetter;
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      onWillAccept: (data) {
        setState(() => _isHovering = true);
        return true;
      },
      onLeave: (data) {
        setState(() => _isHovering = false);
      },
      onAccept: (data) {
        setState(() {
          _isHovering = false;
          _droppedLetter = data;
        });
        widget.onDropResult?.call(data.toLowerCase() == widget.correctLetter.toLowerCase(), data);
      },
      builder: (context, candidateData, rejectedData) {
        final bool isSuccess = _droppedLetter?.toLowerCase() == widget.correctLetter.toLowerCase();
        
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 50,
          height: 60, // Match typical font size layout
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: _isHovering 
                ? Colors.indigo.shade100 
                : (_droppedLetter != null 
                    ? (isSuccess ? Colors.green.shade100 : Colors.red.shade100)
                    : Colors.grey.shade100),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHovering 
                  ? Colors.indigo 
                  : (_droppedLetter != null
                      ? (isSuccess ? Colors.green : Colors.red)
                      : Colors.grey.shade400),
              width: 2,
            ),
          ),
          alignment: Alignment.center,
          child: _droppedLetter != null
              ? Text(
                  _droppedLetter!,
                  style: GoogleFonts.comicNeue(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: isSuccess ? Colors.green.shade800 : Colors.red.shade800,
                  ),
                )
              : null,
        );
      },
    );
  }
}
