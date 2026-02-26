import 'package:flutter/material.dart';
import 'vector_graphic.dart';
import '../utils/responsive_helper.dart';

class CircleChoiceGrid extends StatefulWidget {
  final List<Map<String, dynamic>> entries;
  final int columns;

  const CircleChoiceGrid({
    Key? key,
    required this.entries,
    this.columns = 2,
  }) : super(key: key);

  @override
  State<CircleChoiceGrid> createState() => _CircleChoiceGridState();
}

class _CircleChoiceGridState extends State<CircleChoiceGrid> {
  // Map of entryIndex to selected choice string
  final Map<int, String> _selections = {};

  void _selectChoice(int entryIndex, String choice) {
    setState(() {
      _selections[entryIndex] = choice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveHelper.getResponsiveGridCount(
          context: context, 
          mobile: 1, 
          tablet: widget.columns, 
          desktop: widget.columns
        ),
        childAspectRatio: 1.1,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
      ),
      itemCount: widget.entries.length,
      itemBuilder: (context, index) {
        final entry = widget.entries[index];
        final imageId = entry['imageId'] as String;
        final choices = List<String>.from(entry['choices'] ?? []);
        final selectedChoice = _selections[index];

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.indigo.shade100, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.indigo.shade50.withOpacity(0.5),
                offset: const Offset(0, 4),
                blurRadius: 12,
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: VectorGraphic(assetName: imageId, size: 80),
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: choices.map((choice) {
                    final isSelected = choice == selectedChoice;
                    final isCorrect = choice == entry['answer'];
                    
                    Color bgColor = Colors.blueGrey.shade50;
                    Color borderColor = Colors.blueGrey.shade200;
                    Color textColor = Colors.blueGrey.shade800;
                    IconData? overlayIcon;
                    
                    if (isSelected) {
                      if (isCorrect) {
                        bgColor = Colors.green.shade400;
                        borderColor = Colors.green.shade600;
                        textColor = Colors.white;
                        overlayIcon = Icons.check_circle;
                      } else {
                        bgColor = Colors.red.shade400;
                        borderColor = Colors.red.shade600;
                        textColor = Colors.white;
                        overlayIcon = Icons.cancel;
                      }
                    }

                    return GestureDetector(
                      onTap: () => _selectChoice(index, choice),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: bgColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: borderColor,
                            width: 3,
                          ),
                          boxShadow: isSelected
                              ? [BoxShadow(color: bgColor.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))]
                              : [],
                        ),
                        alignment: Alignment.center,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(
                              choice,
                              style: TextStyle(
                                fontFamily: 'FredokaOne',
                                fontSize: 28,
                                color: textColor,
                              ),
                            ),
                            if (overlayIcon != null)
                              Positioned(
                                right: -4,
                                top: -4,
                                child: Icon(
                                  overlayIcon,
                                  color: Colors.white,
                                  size: 24,
                                  shadows: const [Shadow(color: Colors.black26, blurRadius: 4)],
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
