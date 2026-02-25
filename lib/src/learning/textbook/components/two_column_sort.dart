import 'package:flutter/material.dart';

class TwoColumnSort extends StatefulWidget {
  final String leftLabel;
  final String rightLabel;
  final List<String> leftAnswers;
  final List<String> rightAnswers;
  final List<String> wordBank;

  const TwoColumnSort({
    Key? key,
    required this.leftLabel,
    required this.rightLabel,
    required this.leftAnswers,
    required this.rightAnswers,
    required this.wordBank,
  }) : super(key: key);

  @override
  State<TwoColumnSort> createState() => _TwoColumnSortState();
}

class _TwoColumnSortState extends State<TwoColumnSort> {
  final List<String> _leftItems = [];
  final List<String> _rightItems = [];
  late List<String> _bankItems;

  @override
  void initState() {
    super.initState();
    _bankItems = List.from(widget.wordBank);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Word Bank
        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: _bankItems.map((word) {
            return Draggable<String>(
              data: word,
              feedback: _buildDraggableFeedback(word),
              childWhenDragging: Opacity(
                opacity: 0.3,
                child: _buildWordCard(word),
              ),
              child: _buildWordCard(word),
            );
          }).toList(),
        ),
        const SizedBox(height: 32),

        // Sorting Tables
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildSortColumn(
                label: widget.leftLabel,
                items: _leftItems,
                correctAnswers: widget.leftAnswers,
                onAccept: (word) {
                  setState(() {
                    _bankItems.remove(word);
                    if (!_leftItems.contains(word)) _leftItems.add(word);
                  });
                },
              ),
            ),
            const SizedBox(width: 32),
            Expanded(
              child: _buildSortColumn(
                label: widget.rightLabel,
                items: _rightItems,
                correctAnswers: widget.rightAnswers,
                onAccept: (word) {
                  setState(() {
                    _bankItems.remove(word);
                    if (!_rightItems.contains(word)) _rightItems.add(word);
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWordCard(String word) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blueGrey.shade800, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 4,
          )
        ],
      ),
      child: Text(
        word,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'FredokaOne',
          color: Colors.blueGrey.shade900,
        ),
      ),
    );
  }

  Widget _buildDraggableFeedback(String word) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.amber.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.amber.shade400, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withOpacity(0.3),
              offset: const Offset(0, 8),
              blurRadius: 12,
            )
          ],
        ),
        child: Text(
          word,
          style: TextStyle(
            fontSize: 28, // Slightly larger when dragging
            fontWeight: FontWeight.bold,
            fontFamily: 'FredokaOne',
            color: Colors.amber.shade900,
          ),
        ),
      ),
    );
  }

  Widget _buildSortColumn({
    required String label,
    required List<String> items,
    required List<String> correctAnswers,
    required Function(String) onAccept,
  }) {
    return DragTarget<String>(
      onWillAccept: (data) => data != null,
      onAccept: (data) {
        if (correctAnswers.contains(data)) {
          onAccept(data);
          // TODO: Trigger success animation (e.g., Fox wiggle)
        } else {
          // TODO: Trigger error shake / hint
        }
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          decoration: BoxDecoration(
            color: candidateData.isNotEmpty ? Colors.blueGrey.shade50 : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: candidateData.isNotEmpty ? Colors.orange.shade300 : Colors.blueGrey.shade200,
              width: 3,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade800,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontFamily: 'FredokaOne',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Items
              MinColumnHeight(
                minHeight: 200,
                child: Column(
                  children: items.map((word) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green.shade400, width: 2),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          word,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade800,
                          ),
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

class MinColumnHeight extends StatelessWidget {
  final double minHeight;
  final Widget child;

  const MinColumnHeight({Key? key, required this.minHeight, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight),
      child: child,
    );
  }
}
