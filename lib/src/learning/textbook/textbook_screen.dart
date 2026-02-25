import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'textbook_canvas.dart';

class TextbookScreen extends StatefulWidget {
  final String? initialPageId;

  const TextbookScreen({Key? key, this.initialPageId}) : super(key: key);

  @override
  State<TextbookScreen> createState() => _TextbookScreenState();
}

class _TextbookScreenState extends State<TextbookScreen> {
  bool _teacherModeUnlocked = false;
  int _tapCount = 0;
  DateTime _lastTapTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Force Landscape for Textbook Mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    
    // Hide Status Bar and Navigation Bar for an immersive experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    // Restore preferred orientations when leaving textbook mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    
    // Restore UI overlays
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _handleHiddenTap() {
    final now = DateTime.now();
    if (now.difference(_lastTapTime).inSeconds > 2) {
      _tapCount = 1;
    } else {
      _tapCount++;
    }
    _lastTapTime = now;

    if (_tapCount == 3) {
      _tapCount = 0;
      _showKidsLockDialog();
    }
  }

  void _showKidsLockDialog() {
    // A simple math problem to unlock teacher mode (e.g., 8 x 2)
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("For Parents & Teachers",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("What is 8 x 2?", style: TextStyle(fontSize: 18)),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim() == "16") {
                  setState(() {
                    _teacherModeUnlocked = !_teacherModeUnlocked;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_teacherModeUnlocked
                          ? "Teacher Mode Unlocked"
                          : "Teacher Mode Locked"),
                      backgroundColor: _teacherModeUnlocked ? Colors.green : Colors.orange,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                } else {
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Unlock"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Letterbox background color
      body: Stack(
        children: [
          // The pure 4:3 canvas (Student View)
          Center(
            child: TextbookCanvas(
              teacherModeActive: _teacherModeUnlocked,
              initialPageId: widget.initialPageId,
            ),
          ),

          // Hidden Gesture Detector for Teacher View
          Positioned(
            top: 0,
            right: 0,
            width: 80,
            height: 80,
            child: GestureDetector(
              onTap: _handleHiddenTap,
              behavior: HitTestBehavior.opaque,
            ),
          ),

          // Close Button
          Positioned(
            top: 16,
            left: 16,
            child: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.black87),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
