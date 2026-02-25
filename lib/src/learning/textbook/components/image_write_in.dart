import 'package:flutter/material.dart';
import 'vector_graphic.dart';

class ImageWriteIn extends StatelessWidget {
  final String icon;
  final String? answer; // Not visually displayed unless teacher mode or solved
  final int blankLines; 

  const ImageWriteIn({
    Key? key,
    required this.icon,
    this.answer,
    this.blankLines = 4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        VectorGraphic(assetName: icon, size: 80),
        const SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(blankLines, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Container(
                width: 16,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade800,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class ImageWriteInList extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const ImageWriteInList({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: items.map((item) {
        return ImageWriteIn(
          icon: item['icon'],
          blankLines: item['blanks'] ?? 4,
          answer: item['answer'],
        );
      }).toList(),
    );
  }
}
