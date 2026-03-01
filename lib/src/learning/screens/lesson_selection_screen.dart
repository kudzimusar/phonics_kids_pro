import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../repositories/lesson_repository.dart';
import '../models/phonics_lesson.dart';
import 'phonics_lesson_screen.dart';
import '../../school/widgets/join_class_dialog.dart';
import '../../auth/services/auth_service.dart';
import '../../auth/services/user_service.dart';
import '../../auth/models/app_user.dart';

/// 📚 Lesson Selection — shown when student taps "Practice" from StudentDashboard.
/// Each lesson tile routes to /lesson/:id via GoRouter.
class LessonSelectionScreen extends StatelessWidget {
  const LessonSelectionScreen({super.key});

  void _showJoinClass(BuildContext context) async {
    final userId = AuthService().currentUser?.uid ?? 'student_001';
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => JoinClassDialog(userId: userId),
    );
    if (result == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully joined class! 🎉', style: GoogleFonts.fredoka()),
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
    final userId = AuthService().currentUser?.uid;

    return userId == null
        ? const Center(child: CircularProgressIndicator())
        : StreamBuilder<AppUser?>(
            stream: UserService().getUserStream(userId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error loading profile.',
                      style: GoogleFonts.quicksand(color: Colors.red)),
                );
              }
              final hasActiveSub =
                  snapshot.data?.hasActiveSubscription ?? false;
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Select a lesson to start!',
                        style: GoogleFonts.quicksand(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textColor.withOpacity(0.7))),
                    const SizedBox(height: 20),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.85,
                        ),
                        itemCount: lessons.length,
                        itemBuilder: (context, index) {
                          final lesson = lessons[index];
                          return _LessonTile(
                            lesson: lesson,
                            hasActiveSubscription: hasActiveSub,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
  }
}

// ── Lesson Tile ───────────────────────────────────────────────────────────────
class _LessonTile extends StatefulWidget {
  final PhonicsLesson lesson;
  final bool hasActiveSubscription;

  const _LessonTile({
    required this.lesson,
    required this.hasActiveSubscription,
  });
  @override
  State<_LessonTile> createState() => _LessonTileState();
}

class _LessonTileState extends State<_LessonTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final bool isLocked = widget.lesson.isPremium && !widget.hasActiveSubscription;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) {
        setState(() => _pressed = false);
        if (isLocked) {
          context.push('/subscription');
        } else {
          // Push to the dynamic lesson route
          context.push('/lesson/${widget.lesson.id}');
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        transform: Matrix4.identity()..scale(_pressed ? 0.95 : 1.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey.withOpacity(_pressed ? 0.2 : 0.08),
              blurRadius: _pressed ? 4 : 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
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
                      child: Text(widget.lesson.id,
                          style: GoogleFonts.fredoka(
                              fontSize: 24, color: Colors.blueAccent)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(widget.lesson.title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.quicksand(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF37474F))),
                  const SizedBox(height: 4),
                  Text('Word: ${widget.lesson.targetWord}',
                      style: GoogleFonts.quicksand(
                          fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            if (isLocked)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.amber, shape: BoxShape.circle),
                  child: const Icon(Icons.lock_rounded,
                      size: 14, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
