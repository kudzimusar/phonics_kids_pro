import 'package:flutter/material.dart';

class BalloonChoiceActivity extends StatefulWidget {
  // [{blendChoices: [fl, sh], endingBalloons: [i, n, g], answer: fl, word: fling}, ...]
  final List<dynamic> rows; 

  const BalloonChoiceActivity({
    Key? key,
    required this.rows,
  }) : super(key: key);

  @override
  State<BalloonChoiceActivity> createState() => _BalloonChoiceActivityState();
}

class _BalloonChoiceActivityState extends State<BalloonChoiceActivity> {
  // Map row index to the currently selected string choice
  final Map<int, String?> _selections = {};

  void _selectChoice(int rowIndex, String choice) {
    setState(() {
      _selections[rowIndex] = choice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.rows.length,
      separatorBuilder: (_, __) => const SizedBox(height: 48),
      itemBuilder: (context, index) {
        final rowData = widget.rows[index];
        final List<String> blendChoices = List<String>.from(rowData['blendChoices']);
        final List<String> endingBalloons = List<String>.from(rowData['endingBalloons']);
        final answer = rowData['answer'] as String;
        final currentSelection = _selections[index];

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Left Side: Interactive Blend Balloons
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: blendChoices.map((choice) {
                  return _buildBlendBalloon(index, choice, answer, currentSelection);
                }).toList(),
              ),
            ),
            
            // Middle: Plus Sign
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
              child: Text(
                "+",
                style: TextStyle(
                  fontSize: 48,
                  fontFamily: 'FredokaOne',
                  color: Colors.black54,
                ),
              ),
            ),

            // Right Side: Fixed Letter Balloons
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: endingBalloons.map((letter) {
                  return _buildFixedLetterBalloon(letter);
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBlendBalloon(int rowIndex, String choice, String answer, String? currentSelection) {
    final isSelected = currentSelection == choice;
    final isCorrect = isSelected && choice == answer;
    final isWrong = isSelected && choice != answer;

    Color balloonColor = Colors.grey.shade300;
    if (isCorrect) {
      balloonColor = Colors.green.shade400;
    } else if (isWrong) {
      balloonColor = Colors.red.shade400;
    }

    return GestureDetector(
      onTap: () => _selectChoice(rowIndex, choice),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        transform: Matrix4.identity()..scale(isSelected ? 1.15 : 1.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Balloon Body
            Container(
              width: 80,
              height: 100,
              decoration: BoxDecoration(
                color: balloonColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(40),
                  bottom: Radius.circular(50),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  )
                ],
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.grey.shade400,
                  width: 3,
                )
              ),
              child: Center(
                child: Text(
                  choice,
                  style: TextStyle(
                    fontSize: 36,
                    fontFamily: 'SassoonPrimary',
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Balloon String
            CustomPaint(
              size: const Size(20, 60),
              painter: BalloonStringPainter(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFixedLetterBalloon(String letter) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(25),
                bottom: Radius.circular(30),
              ),
              border: Border.all(color: Colors.blue.shade300, width: 2),
            ),
            child: Center(
              child: Text(
                letter,
                style: const TextStyle(
                  fontSize: 28,
                  fontFamily: 'SassoonPrimary',
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          CustomPaint(
            size: const Size(10, 40),
            painter: BalloonStringPainter(),
          ),
        ],
      ),
    );
  }
}

class BalloonStringPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black45
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final path = Path();
    // Balloon knot
    path.moveTo(size.width / 2 - 4, 0);
    path.lineTo(size.width / 2 + 4, 0);
    path.lineTo(size.width / 2 + 2, 4);
    path.lineTo(size.width / 2 - 2, 4);
    path.close();
    canvas.drawPath(path, Paint()..color = Colors.black45..style = PaintingStyle.fill);

    // Wavy string
    path.moveTo(size.width / 2, 4);
    path.quadraticBezierTo(size.width / 2 + 5, size.height * 0.3, size.width / 2, size.height * 0.5);
    path.quadraticBezierTo(size.width / 2 - 5, size.height * 0.7, size.width / 2 + 2, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
