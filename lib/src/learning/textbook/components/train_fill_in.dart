import 'package:flutter/material.dart';
import 'vector_graphic.dart';
import 'squash_stretch.dart';

class TrainFillIn extends StatefulWidget {
  final List<Map<String, dynamic>> trains;
  final VoidCallback? onComplete;

  const TrainFillIn({Key? key, required this.trains, this.onComplete}) : super(key: key);

  @override
  State<TrainFillIn> createState() => _TrainFillInState();
}

class _TrainFillInState extends State<TrainFillIn> {
  // Store user's written vowel for each train
  late List<String> _answers;

  @override
  void initState() {
    super.initState();
    _answers = List.generate(widget.trains.length, (_) => '');
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      itemCount: widget.trains.length,
      separatorBuilder: (context, index) => const SizedBox(height: 48), // Track spacing
      itemBuilder: (context, index) {
        final train = widget.trains[index];
        final letters = train['letters'] as List<String>;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Clue sitting above the train
            Padding(
              padding: const EdgeInsets.only(left: 32.0, bottom: 8.0),
              child: VectorGraphic(
                assetName: train['imageId'],
                size: 80,
              ),
            ),
            // The Train
            SizedBox(
              height: 120,
              child: Stack(
                children: [
                  // Draw the train track
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.brown.shade800,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  // The Cars
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SquashStretch(child: _buildTrainEngine(letters[0])),
                      _buildTrainConnector(),
                      SquashStretch(
                        child: _buildTrainCar(
                          isVowel: true, 
                          currentAnswer: _answers[index],
                          onChanged: (val) {
                            setState(() {
                              _answers[index] = val;
                            });
                            if (val.toLowerCase() == train['answer'].toString().toLowerCase()) {
                              widget.onComplete?.call();
                            }
                          },
                        ),
                      ),
                      _buildTrainConnector(),
                      SquashStretch(child: _buildTrainCaboose(letters[2])),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTrainEngine(String letter) {
    return Container(
      width: 120,
      height: 100,
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.red.shade600,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(16),
        ),
        border: Border.all(color: Colors.black87, width: 3),
      ),
      child: Stack(
        children: [
          // Smokestack
          Positioned(
            top: -20,
            left: 20,
            child: Container(
              width: 20,
              height: 20,
              color: Colors.black87,
            ),
          ),
          // Window/Letter Box
          Center(
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black87, width: 2),
              ),
              alignment: Alignment.center,
              child: Text(
                letter,
                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, fontFamily: 'FredokaOne'),
              ),
            ),
          ),
          // Wheels
          Positioned(
            bottom: -15,
            left: 10,
            child: _buildWheel(),
          ),
          Positioned(
            bottom: -15,
            right: 10,
            child: _buildWheel(),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainCar({required bool isVowel, required String currentAnswer, required Function(String) onChanged}) {
    return Container(
      width: 100,
      height: 80,
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.blue.shade500,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black87, width: 3),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(
            child: Container(
              width: 60,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black87, width: 2),
              ),
              child: TextField(
                textAlign: TextAlign.center,
                maxLength: 1,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, fontFamily: 'FredokaOne', color: Colors.blue),
                decoration: const InputDecoration(
                  counterText: "",
                  border: InputBorder.none,
                ),
                onChanged: onChanged,
              ),
            ),
          ),
          // Wheels
          Positioned(
            bottom: -15,
            left: 10,
            child: _buildWheel(),
          ),
          Positioned(
            bottom: -15,
            right: 10,
            child: _buildWheel(),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainCaboose(String letter) {
    return Container(
      width: 120,
      height: 80,
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.green.shade600,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(30),
        ),
        border: Border.all(color: Colors.black87, width: 3),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(
            child: Container(
              width: 60,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black87, width: 2),
              ),
              alignment: Alignment.center,
              child: Text(
                letter,
                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, fontFamily: 'FredokaOne'),
              ),
            ),
          ),
          // Wheels
          Positioned(
            bottom: -15,
            left: 10,
            child: _buildWheel(),
          ),
          Positioned(
            bottom: -15,
            right: 10,
            child: _buildWheel(),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainConnector() {
    return Container(
      width: 16,
      height: 6,
      margin: const EdgeInsets.only(bottom: 30),
      color: Colors.grey.shade800,
    );
  }

  Widget _buildWheel() {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade500, width: 4),
      ),
    );
  }
}
