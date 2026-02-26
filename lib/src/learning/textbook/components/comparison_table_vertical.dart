import 'package:flutter/material.dart';
import 'vector_graphic.dart';
import 'text_block.dart';

class ComparisonTableVertical extends StatelessWidget {
  final List<Map<String, dynamic>> rows;

  const ComparisonTableVertical({Key? key, required this.rows}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blueGrey.shade800, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.shade100,
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: rows.asMap().entries.map((entry) {
          final index = entry.key;
          final row = entry.value;
          final isLast = index == rows.length - 1;

          return Container(
            decoration: BoxDecoration(
              border: isLast ? null : Border(bottom: BorderSide(color: Colors.blueGrey.shade200, width: 2)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade50,
                      borderRadius: BorderRadius.only(
                        topLeft: index == 0 ? const Radius.circular(14) : Radius.zero,
                        bottomLeft: isLast ? const Radius.circular(14) : Radius.zero,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          row['label'] as String,
                          style: TextStyle(
                            fontFamily: 'FredokaOne',
                            fontSize: 24,
                            color: Colors.indigo.shade800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          row['explanation'] as String,
                          style: TextStyle(
                            fontFamily: 'SassoonPrimary',
                            fontSize: 20,
                            color: Colors.blueGrey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        VectorGraphic(assetName: row['imageId'] as String, size: 80),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Text(
                            row['example'] as String,
                            style: const TextStyle(
                              fontFamily: 'SassoonPrimary',
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
