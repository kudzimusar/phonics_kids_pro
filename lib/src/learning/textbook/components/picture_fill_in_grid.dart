import 'package:flutter/material.dart';
import 'vector_graphic.dart';

class PictureFillInGrid extends StatefulWidget {
  final List<Map<String, dynamic>> entries;
  /* Example entry:
    {
      'imageDesc': 'Bird / dove',
      'imageId': 'img-bird2',
      'partial': 'b__d',
      'answer': 'ir',
      'word': 'bird' // full word representation
    }
  */
  final int columns;

  const PictureFillInGrid({
    Key? key,
    required this.entries,
    this.columns = 3,
  }) : super(key: key);

  @override
  State<PictureFillInGrid> createState() => _PictureFillInGridState();
}

class _PictureFillInGridState extends State<PictureFillInGrid> {
  late List<String> _answers;

  @override
  void initState() {
    super.initState();
    _answers = List.generate(widget.entries.length, (_) => '');
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.columns,
        childAspectRatio: 1.0, // More square to give graphics space
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: widget.entries.length,
      itemBuilder: (context, index) {
        final entry = widget.entries[index];
        final partialParts = (entry['partial'] as String).split('__');
        
        // Example: 'b__d' -> parts = ['b', 'd']
        // Some might be '__th' -> parts = ['', 'th']
        // Some might be 'cha__' -> parts = ['cha', '']
        final prefix = partialParts.isNotEmpty ? partialParts[0] : '';
        final suffix = partialParts.length > 1 ? partialParts[1] : '';

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.blueGrey.shade200, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.blueGrey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Image
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: VectorGraphic(
                    assetName: entry['imageId'],
                    size: 140, // Increased from 80
                  ),
                ),
              ),
              // Word Row (Prefix + Input + Suffix)
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (prefix.isNotEmpty)
                      Text(
                        prefix,
                        style: const TextStyle(
                          fontFamily: 'SassoonPrimary', 
                          fontSize: 36, // Increased
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    
                    // The Blank Input Box
                    Container(
                      width: 65, // Increased
                      height: 50, // Increased
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.black87, width: 3)),
                      ),
                      child: TextField(
                        textAlign: TextAlign.center,
                        maxLength: 2, // Bossy R is usually 2 letters
                        style: const TextStyle(
                          fontSize: 36, // Increased
                          fontWeight: FontWeight.bold, 
                          fontFamily: 'SassoonPrimary', 
                          color: Colors.blue
                        ),
                        decoration: const InputDecoration(
                          counterText: "",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(bottom: 8),
                        ),
                        onChanged: (val) {
                          setState(() {
                            _answers[index] = val;
                          });
                        },
                      ),
                    ),

                    if (suffix.isNotEmpty)
                      Text(
                        suffix,
                        style: const TextStyle(
                          fontFamily: 'SassoonPrimary', 
                          fontSize: 36, // Increased
                          fontWeight: FontWeight.bold
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
