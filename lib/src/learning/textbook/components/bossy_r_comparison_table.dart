import 'package:flutter/material.dart';
import 'vector_graphic.dart';

class BossyRComparisonTable extends StatelessWidget {
  final List<Map<String, dynamic>> rows;

  const BossyRComparisonTable({Key? key, required this.rows}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.blueGrey.shade800, width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: rows.asMap().entries.map((entry) {
          int index = entry.key;
          var row = entry.value;
          List<String> pair = List<String>.from(row['pair']);
          
          return Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: index < rows.length - 1 
                    ? Border(right: BorderSide(color: Colors.blueGrey.shade800, width: 2))
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  VectorGraphic(assetName: row['imageId1'] as String, size: 64),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade50,
                      border: Border.symmetric(
                        horizontal: BorderSide(color: Colors.blueGrey.shade800, width: 1),
                      ),
                    ),
                    child: Text(
                      "${pair[0]} / ${pair[1]}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'FredokaOne',
                        color: Colors.blueGrey.shade900,
                      ),
                    ),
                  ),
                  VectorGraphic(assetName: row['imageId2'] as String, size: 64),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
