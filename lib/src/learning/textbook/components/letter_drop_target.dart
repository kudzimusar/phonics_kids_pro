import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';

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
    final scale = ResponsiveHelper.componentScale(context);
    
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
          width: 50 * scale,
          height: 60 * scale, // Match typical font size layout
          margin: EdgeInsets.symmetric(horizontal: 6 * scale),
          decoration: BoxDecoration(
            color: _isHovering 
                ? Colors.indigo.shade100 
                : (_droppedLetter != null 
                    ? (isSuccess ? Colors.green.shade50 : Colors.red.shade50)
                    : Colors.white),
            borderRadius: BorderRadius.circular(16 * scale),
            border: Border.all(
              color: _isHovering 
                  ? Colors.indigo 
                  : (_droppedLetter != null
                      ? (isSuccess ? Colors.green.shade300 : Colors.red.shade300)
                      : Colors.blueGrey.withOpacity(0.2)),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10 * scale,
                offset: Offset(0, 4 * scale),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: _droppedLetter != null
              ? Text(
                  _droppedLetter!,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.responsiveFontSize(context, 32),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'FredokaOne',
                    color: isSuccess ? Colors.green.shade800 : Colors.red.shade800,
                  ),
                )
              : null,
        );
      },
    );
  }
}
