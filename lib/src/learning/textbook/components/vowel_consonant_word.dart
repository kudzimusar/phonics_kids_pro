import 'package:flutter/material.dart';
import '../../services/notebook_service.dart';
import '../../models/notebook_entry.dart';

class VowelConsonantWord extends StatefulWidget {
  final String word;
  final String? moduleId;
  final ValueChanged<bool>? onStatusChanged;

  const VowelConsonantWord({
    Key? key, 
    required this.word,
    this.moduleId,
    this.onStatusChanged,
  }) : super(key: key);

  @override
  State<VowelConsonantWord> createState() => _VowelConsonantWordState();
}

class _VowelConsonantWordState extends State<VowelConsonantWord> {
  // Store the selected state of each character
  late List<bool> _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = List.filled(widget.word.length, false);
  }

  bool _isVowel(String char) {
    return 'aeiouy'.contains(char.toLowerCase());
  }

  void _toggleChar(int index) {
    setState(() {
      _isSelected[index] = !_isSelected[index];
    });
    
    if (widget.onStatusChanged != null) {
      bool isComplete = _isSelected.every((element) => element == true);
      widget.onStatusChanged!(isComplete);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, 4),
                blurRadius: 4,
              )
            ],
          ),
          child: Wrap(
            spacing: 4,
            runSpacing: 4,
            alignment: WrapAlignment.center,
            children: List.generate(widget.word.length, (index) {
              final char = widget.word[index];
              final isSelected = _isSelected[index];
              final isVowelVal = _isVowel(char);
              
              Color bgColor = Colors.transparent;
              Color borderColor = Colors.transparent;
              Color textColor = Colors.black87;

              if (isSelected) {
                if (isVowelVal) {
                  bgColor = Colors.blue.shade50;
                  borderColor = Colors.blue.shade300;
                  textColor = Colors.blue.shade800;
                } else {
                  bgColor = Colors.red.shade50;
                  borderColor = Colors.red.shade300;
                  textColor = Colors.red.shade800;
                }
              }

              return GestureDetector(
                onTap: () => _toggleChar(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 36,
                  height: 48,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? borderColor : Colors.grey.shade200, 
                      width: 2
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    char,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      fontFamily: 'FredokaOne',
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Material(
            color: Colors.transparent,
            child: IconButton(
              icon: const Icon(Icons.edit_note_rounded, size: 20, color: Colors.indigo),
              onPressed: () {
                NotebookService().saveEntry(
                  NotebookEntry(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    moduleId: widget.moduleId ?? 'unknown',
                    type: NotebookEntryType.manual,
                    content: widget.word,
                    timestamp: DateTime.now(),
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Added "${widget.word}" to Fox Notebook!')),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
