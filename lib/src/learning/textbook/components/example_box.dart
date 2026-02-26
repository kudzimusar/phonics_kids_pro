import 'package:flutter/material.dart';
import 'vector_graphic.dart';
import 'text_block.dart';
import 'sentence_find.dart';

class ExampleBox extends StatelessWidget {
  final String imageId;
  final String text;
  final String? explanation;
  final List<String>? answers;

  const ExampleBox({
    Key? key,
    required this.imageId,
    required this.text,
    this.explanation,
    this.answers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.shade200, width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: VectorGraphic(assetName: imageId, size: 60),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (answers != null && answers!.isNotEmpty)
                  SentenceFind(
                    sentences: [{'text': text, 'answers': answers}],
                    hasDecoration: false,
                  )
                else
                  TextBlock(
                    text: text,
                    type: TextType.instruction,
                    color: Colors.amber.shade900,
                  ),
                if (explanation != null) ...[
                  const SizedBox(height: 12),
                  TextBlock(
                    text: explanation!,
                    type: TextType.body,
                    color: Colors.blueGrey.shade800,
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}
