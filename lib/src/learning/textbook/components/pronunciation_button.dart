import 'package:flutter/material.dart';
import '../services/pronunciation_service.dart';

class PronunciationButton extends StatefulWidget {
  final String targetWord;
  final ValueChanged<PronunciationResult>? onResult;

  const PronunciationButton({
    Key? key,
    required this.targetWord,
    this.onResult,
  }) : super(key: key);

  @override
  State<PronunciationButton> createState() => _PronunciationButtonState();
}

class _PronunciationButtonState extends State<PronunciationButton> with SingleTickerProviderStateMixin {
  bool _isProcessing = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);

    try {
      final result = await PronunciationService().validatePronunciation(widget.targetWord);
      
      if (mounted) {
        widget.onResult?.call(result);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.feedback),
            backgroundColor: result.isAccurate ? Colors.green : Colors.orange,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          final isRecording = PronunciationService().isRecording;
          final double scale = isRecording ? 1.0 + (_pulseController.value * 0.1) : 1.0;
          final Color color = isRecording 
              ? Color.lerp(Colors.red.shade400, Colors.red.shade700, _pulseController.value)!
              : (_isProcessing ? Colors.orange : Colors.indigo);

          return Transform.scale(
            scale: scale,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: isRecording ? 12 : 6,
                    spreadRadius: isRecording ? 4 : 2,
                  ),
                ],
              ),
              child: Icon(
                isRecording ? Icons.mic : (_isProcessing ? Icons.hourglass_empty : Icons.mic_none),
                color: Colors.white,
                size: 28,
              ),
            ),
          );
        },
      ),
    );
  }
}
