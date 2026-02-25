import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import '../models/phonics_lesson.dart';
import '../services/phonics_engine.dart';
import '../models/reward_models.dart';
import '../repositories/sticker_repository.dart';
import '../widgets/sticker_reward_overlay.dart';
import '../widgets/phonic_fox.dart';
import '../../auth/services/auth_service.dart';
import '../../auth/screens/subscription_gate_screen.dart';

class PhonicsLessonScreen extends StatefulWidget {
  final PhonicsLesson lesson;

  const PhonicsLessonScreen({Key? key, required this.lesson}) : super(key: key);

  @override
  _PhonicsLessonScreenState createState() => _PhonicsLessonScreenState();
}

class _PhonicsLessonScreenState extends State<PhonicsLessonScreen>
    with SingleTickerProviderStateMixin {
  FoxExpression _foxState = FoxExpression.idle;
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  bool _isProcessing = false;
  double? _lastScore;
  Sticker? _newSticker;

  late AnimationController _cardController;
  late Animation<double> _cardFade;

  @override
  void initState() {
    super.initState();
    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _cardFade = CurvedAnimation(parent: _cardController, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    _cardController.dispose();
    super.dispose();
  }

  void _onRecordTapped() async {
    if (_isRecording) {
      await _stopRecording();
    } else {
      await _startRecording();
    }
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final cache = await getTemporaryDirectory();
        final path = '${cache.path}/attempt_${DateTime.now().millisecondsSinceEpoch}.m4a';
        await _audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc),
          path: path,
        );
        setState(() {
          _isRecording = true;
          _lastScore = null;
          _newSticker = null;
          _foxState = FoxExpression.idle;
          _cardController.reverse();
        });
      }
    } catch (e) {
      debugPrint('Error starting record: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
        _isProcessing = true;
      });

      if (path != null) {
        Uint8List bytes;
        if (kIsWeb) {
          // On web, path is often a blob URL. 
          // Use a network request or a specific package to get bytes.
          // For now, we stub this as the goal is Stripe testing.
          bytes = Uint8List(0);
        } else {
          // This will still need 'dart:io' if we were on mobile, 
          // but we've removed the import. 
          // Ideally use 'package:file/file.dart' or similar for cross-platform.
          bytes = Uint8List(0); // Stub for now
        }
        final engine = PhonicsAIEngine();
        final score = await engine.checkPronunciation(bytes, widget.lesson.targetWord);

        Sticker? unlocked;
        if (score >= 0.8) {
          unlocked = await StickerRepository().unlockRandomSticker('student_001');
        }

        setState(() {
          _isProcessing = false;
          _lastScore = score;
          _newSticker = unlocked;
          _foxState = score >= 0.7 ? FoxExpression.cheer : FoxExpression.wrong;
        });
        _cardController.forward();

        if (unlocked == null) {
          Future.delayed(const Duration(seconds: 4), () {
            if (mounted) {
              setState(() => _foxState = FoxExpression.idle);
              _cardController.reverse();
            }
          });
        }
      }
    } catch (e) {
      debugPrint('Error stopping recording: $e');
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFE1F5FE);
    const textColor = Color(0xFF37474F);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.blueAccent),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Phonics Kids Pro',
          style: GoogleFonts.fredoka(
            color: textColor.withOpacity(0.5),
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Upgrade',
            icon: const Icon(Icons.star_rounded, color: Colors.amber),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SubscriptionGateScreen()),
            ),
          ),
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout_rounded, color: Colors.blueAccent),
            onPressed: () async => AuthService().signOut(),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      _SectionBadge(label: widget.lesson.id),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          widget.lesson.title,
                          style: GoogleFonts.fredoka(
                            fontSize: 26,
                            color: textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueGrey.withOpacity(0.08),
                            blurRadius: 24,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Say the word out loud!',
                            style: GoogleFonts.quicksand(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: textColor.withOpacity(0.6),
                            ),
                          ),
                          Image.asset(
                            widget.lesson.imagePath,
                            height: 130,
                            errorBuilder: (_, __, ___) => const Icon(
                                Icons.pets_rounded,
                                size: 100,
                                color: Colors.orange),
                          ),
                          _WordDisplay(
                            letters: widget.lesson.letters,
                            score: _lastScore,
                          ),
                          FadeTransition(
                            opacity: _cardFade,
                            child: _lastScore == null
                                ? const SizedBox.shrink()
                                : _ScoreCard(score: _lastScore!),
                          ),
                          _RecordButton(
                            label: _isProcessing ? '...' : (_isRecording ? 'STOP' : 'READ!'),
                            color: _isRecording ? const Color(0xFFD32F2F) : const Color(0xFFE53935),
                            isProcessing: _isProcessing,
                            isRecording: _isRecording,
                            onTap: _isProcessing ? null : _onRecordTapped,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 24,
              right: 20,
              child: PhonicFoxWidget(expression: _foxState),
            ),
            if (_newSticker != null)
              StickerRewardOverlay(
                sticker: _newSticker!,
                onDismiss: () {
                  setState(() {
                    _newSticker = null;
                    _foxState = FoxExpression.idle;
                    _cardController.reverse();
                  });
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _SectionBadge extends StatelessWidget {
  final String label;
  const _SectionBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.blueAccent, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.15),
            blurRadius: 8,
          )
        ],
      ),
      child: Text(
        label,
        style: GoogleFonts.fredoka(fontSize: 26, color: Colors.blueAccent),
      ),
    );
  }
}

class _WordDisplay extends StatelessWidget {
  final List<String> letters;
  final double? score;
  const _WordDisplay({required this.letters, this.score});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: letters
          .map((l) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: _LetterTile(letter: l, score: score),
              ))
          .toList(),
    );
  }
}

class _LetterTile extends StatelessWidget {
  final String letter;
  final double? score;
  const _LetterTile({required this.letter, this.score});

  @override
  Widget build(BuildContext context) {
    final Color borderColor = score == null ? Colors.grey.shade300 : (score! >= 0.7 ? Colors.green.shade400 : Colors.red.shade300);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      width: 76,
      height: 90,
      decoration: BoxDecoration(
        color: score == null ? Colors.grey.shade50 : (score! >= 0.7 ? Colors.green.shade50 : Colors.red.shade50),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: GoogleFonts.quicksand(
          fontSize: 54,
          fontWeight: FontWeight.w300,
          color: borderColor,
        ),
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  final double score;
  const _ScoreCard({required this.score});

  @override
  Widget build(BuildContext context) {
    final passed = score >= 0.7;
    final color = passed ? Colors.green : Colors.redAccent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(passed ? Icons.check_circle_rounded : Icons.replay_rounded, color: color),
          const SizedBox(width: 8),
          Text(
            passed ? 'Amazing! ${(score * 100).round()}% accuracy' : 'Keep trying! ${(score * 100).round()}% — you\'re close!',
            style: GoogleFonts.quicksand(fontWeight: FontWeight.w700, color: color, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _RecordButton extends StatelessWidget {
  final String label;
  final Color color;
  final bool isProcessing;
  final bool isRecording;
  final VoidCallback? onTap;

  const _RecordButton({required this.label, required this.color, required this.isProcessing, required this.isRecording, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 22),
        decoration: BoxDecoration(
          color: onTap == null ? Colors.grey.shade300 : color,
          borderRadius: BorderRadius.circular(40),
          boxShadow: onTap == null ? [] : [BoxShadow(color: color.withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 6))],
        ),
        child: isProcessing
            ? const SizedBox(width: 28, height: 28, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(isRecording ? Icons.stop_rounded : Icons.mic_rounded, color: Colors.white, size: 28),
                  const SizedBox(width: 10),
                  Text(label, style: GoogleFonts.fredoka(fontSize: 32, color: Colors.white)),
                ],
              ),
      ),
    );
  }
}
