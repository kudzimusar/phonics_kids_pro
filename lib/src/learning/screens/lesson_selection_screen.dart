import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../repositories/lesson_repository.dart';
import '../models/phonics_lesson.dart';
import 'phonics_lesson_screen.dart';
import 'sticker_book_screen.dart';
import '../../school/widgets/join_class_dialog.dart';
import '../../auth/screens/subscription_gate_screen.dart';

class LessonSelectionScreen extends StatelessWidget {
  const LessonSelectionScreen({Key? key}) : super(key: key);

  void _showJoinClass(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (_) => const JoinClassDialog(userId: 'student_001'), // Replace with actual Auth UID if needed
    );

    if (result == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully joined the class!', style: GoogleFonts.fredoka()),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lessons = LessonRepository.allLessons;
    const bgColor = Color(0xFFE1F5FE);
    const textColor = Color(0xFF37474F);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Learning Hub',
          style: GoogleFonts.fredoka(color: textColor, fontSize: 24),
        ),
        actions: [
          IconButton(
            tooltip: 'Join Class',
            icon: const Icon(Icons.school_rounded, color: Colors.blueAccent),
            onPressed: () => _showJoinClass(context),
          ),
          IconButton(
            tooltip: 'My Stickers',
            icon: const Icon(Icons.menu_book_rounded, color: Colors.blueAccent),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const StickerBookScreen()),
            ),
          ),
          IconButton(
            tooltip: 'Upgrade',
            icon: const Icon(Icons.star_rounded, color: Colors.amber),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SubscriptionGateScreen()),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select a lesson to start!',
              style: GoogleFonts.quicksand(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: lessons.length,
                itemBuilder: (context, index) {
                  final lesson = lessons[index];
                  return _LessonTile(lesson: lesson);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LessonTile extends StatelessWidget {
  final PhonicsLesson lesson;
  const _LessonTile({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (lesson.isPremium) {
           Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SubscriptionGateScreen()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PhonicsLessonScreen(lesson: lesson),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        lesson.id,
                        style: GoogleFonts.fredoka(
                          fontSize: 24,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    lesson.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.quicksand(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF37474F),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Word: ${lesson.targetWord}',
                    style: GoogleFonts.quicksand(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            if (lesson.isPremium)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.amber,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_rounded,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
