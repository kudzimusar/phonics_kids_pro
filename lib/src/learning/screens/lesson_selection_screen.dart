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
import '../textbook/utils/responsive_helper.dart';
import '../textbook/components/ui_styles.dart';
import 'dart:ui';

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
      return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select a lesson to start!',
                        style: AppStyles.fredokaHeader.copyWith(
                          fontSize: ResponsiveHelper.responsiveFontSize(context, 22),
                          fontWeight: FontWeight.bold,
                          color: textColor.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Expanded(
                        child: GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: ResponsiveHelper.getResponsiveGridCount(
                              context: context,
                              mobile: MediaQuery.of(context).size.width < 380 ? 1 : 2,
                              tablet: 3,
                              desktop: 4,
                            ),
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            childAspectRatio: 0.88,
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

    return Hero(
      tag: 'lesson_${widget.lesson.id}',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) {
          setState(() => _pressed = false);
          if (isLocked) {
            context.push('/subscription');
          } else {
            context.push('/lesson/${widget.lesson.id}');
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()..scale(_pressed ? 0.96 : 1.0),
          child: Stack(
            children: [
              // Premium Glassmorphic Card
              ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: AppStyles.glassBlurX,
                    sigmaY: AppStyles.glassBlurY,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppStyles.glassBackground,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.5),
                        width: 1.5,
                      ),
                      boxShadow: [
                        AppStyles.premiumShadow,
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon/ID Container
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent.withOpacity(0.12),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.blueAccent.withOpacity(0.2),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              widget.lesson.id,
                              style: AppStyles.fredokaHeader.copyWith(
                                fontSize: 26,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Title
                        Text(
                          widget.lesson.title,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.quicksand(
                            fontSize: ResponsiveHelper.responsiveFontSize(context, 16),
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF37474F),
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Target Word
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Word: ${widget.lesson.targetWord}',
                            style: GoogleFonts.quicksand(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (isLocked)
                Positioned(
                  top: 14,
                  right: 14,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.lock_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
