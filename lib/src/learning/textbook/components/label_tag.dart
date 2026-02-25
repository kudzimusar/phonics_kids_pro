import 'package:flutter/material.dart';

class LabelTag extends StatelessWidget {
  final String label;

  const LabelTag({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange, width: 2),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.orange,
          fontFamily: 'FredokaOne', // Ensure this runs even if font is not loaded
        ),
      ),
    );
  }
}
