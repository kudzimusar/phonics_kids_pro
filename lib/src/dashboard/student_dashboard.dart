import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../auth/models/app_user.dart';
import '../auth/services/auth_service.dart';
import '../school/widgets/join_class_dialog.dart';
import 'mode_switcher_dialog.dart';
import 'kids_lock_overlay.dart';

/// 🧒 Practice Mode Dashboard — child-friendly, large targets, Kids Lock active.
class StudentDashboard extends StatelessWidget {
  final AppUser user;
  final void Function(UserRole) onModeChanged;

  const StudentDashboard({
    super.key,
    required this.user,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return KidsLockOverlay(
      currentRole: UserRole.student,
      onModeChanged: onModeChanged,
      child: _StudentBody(user: user, onModeChanged: onModeChanged),
    );
  }
}

class _StudentBody extends StatelessWidget {
  final AppUser user;
  final void Function(UserRole) onModeChanged;
  const _StudentBody({required this.user, required this.onModeChanged});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B4B),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Hero Welcome ─────────────────────────────────────────
            SliverToBoxAdapter(
              child: _WelcomeHero(isTablet: isTablet),
            ),

            // ── Progress Banner ──────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                child: _ProgressBanner(userId: user.id),
              ),
            ),

            // ── Action Grid ──────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverGrid(
                delegate: SliverChildListDelegate([
                  _KidCard(
                    emoji: '📖',
                    label: 'Open Textbook',
                    sublabel: 'Start Reading!',
                    gradient: const [Color(0xFF1565C0), Color(0xFF42A5F5)],
                    onTap: () => _openTextbook(context),
                  ),
                  _KidCard(
                    emoji: '🎯',
                    label: 'Lessons',
                    sublabel: 'Practise Phonics',
                    gradient: const [Color(0xFF00838F), Color(0xFF4DD0E1)],
                    onTap: () => _openLessons(context),
                  ),
                  _KidCard(
                    emoji: '⭐',
                    label: 'My Stickers',
                    sublabel: 'Trophy Room',
                    gradient: const [Color(0xFFF57F17), Color(0xFFFFD54F)],
                    onTap: () => _openStickers(context),
                  ),
                  _KidCard(
                    emoji: '🏅',
                    label: 'My Certificate',
                    sublabel: 'Show Off!',
                    gradient: const [Color(0xFF6A1B9A), Color(0xFFCE93D8)],
                    onTap: () => _openCertificate(context),
                  ),
                  _KidCard(
                    emoji: '🏫',
                    label: 'Join a Class',
                    sublabel: 'Enter code',
                    gradient: const [Color(0xFF2E7D32), Color(0xFF81C784)],
                    onTap: () => _joinClass(context),
                  ),
                ]),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isTablet ? 3 : 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.95,
                ),
              ),
            ),

            // ── Bottom padding ───────────────────────────────────────
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),

      // PhonicFox FAB (grown-up access)
      floatingActionButton: Semantics(
        label: 'Ask a grown-up to change mode',
        button: true,
        child: FloatingActionButton.extended(
          heroTag: 'mode_fab',
          onPressed: () async {
            HapticFeedback.mediumImpact();
            final role = await showModeSwitcher(
              context: context,
              currentRole: UserRole.student,
            );
            if (role != null && role != UserRole.student) onModeChanged(role);
          },
          backgroundColor: const Color(0xFF1A1F3C),
          icon: const Text('🦊', style: TextStyle(fontSize: 20)),
          label: Text('Grown-Up',
              style: GoogleFonts.fredoka(color: Colors.white, fontSize: 15)),
        ),
      ),
    );
  }

  void _openTextbook(BuildContext context) {
    context.push('/textbook');
  }

  void _openLessons(BuildContext context) {
    context.push('/lessons');
  }

  void _openStickers(BuildContext context) {
    context.push('/stickers');
  }

  void _openCertificate(BuildContext context) {
    context.push('/certificate');
  }

  void _joinClass(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_) => JoinClassDialog(userId: user.id),
    );
  }
}

// ── Welcome Hero ──────────────────────────────────────────────────────────────
class _WelcomeHero extends StatelessWidget {
  final bool isTablet;
  const _WelcomeHero({required this.isTablet});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A237E), Color(0xFF283593)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A237E).withOpacity(0.5),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          const Text('🦊', style: TextStyle(fontSize: 64)),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hello, Reader! 👋',
                    style: GoogleFonts.fredoka(
                        color: Colors.amberAccent,
                        fontSize: isTablet ? 28 : 22)),
                const SizedBox(height: 6),
                Text("Let's practise reading today!",
                    style: GoogleFonts.quicksand(
                        color: Colors.white70,
                        fontSize: isTablet ? 16 : 13,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amberAccent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Colors.amberAccent.withOpacity(0.4)),
                  ),
                  child: Text('🎯  Practice Mode',
                      style: GoogleFonts.quicksand(
                          color: Colors.amberAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Progress Banner ───────────────────────────────────────────────────────────
class _ProgressBanner extends StatelessWidget {
  final String userId;
  const _ProgressBanner({required this.userId});

  @override
  Widget build(BuildContext context) {
    // Static display — wire to real shared_preferences data when available
    const double progress = 0.35;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white12,
                  color: Colors.amberAccent,
                  strokeWidth: 5,
                  semanticsLabel: 'Reading progress',
                  semanticsValue: '${(progress * 100).round()}%',
                ),
                Center(
                  child: Text(
                    '${(progress * 100).round()}%',
                    style: GoogleFonts.fredoka(
                        color: Colors.amberAccent, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Reading Journey',
                    style: GoogleFonts.fredoka(
                        color: Colors.white, fontSize: 16)),
                Text('Keep going — you\'re doing great! 🌟',
                    style: GoogleFonts.quicksand(
                        color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Kid Action Card ───────────────────────────────────────────────────────────
class _KidCard extends StatefulWidget {
  final String emoji;
  final String label;
  final String sublabel;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _KidCard({
    required this.emoji,
    required this.label,
    required this.sublabel,
    required this.gradient,
    required this.onTap,
  });

  @override
  State<_KidCard> createState() => _KidCardState();
}

class _KidCardState extends State<_KidCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${widget.label}. ${widget.sublabel}',
      button: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) => setState(() => _pressed = true),
          onTapCancel: () => setState(() => _pressed = false),
          onTapUp: (_) {
            setState(() => _pressed = false);
            HapticFeedback.lightImpact();
            widget.onTap();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            transform: Matrix4.identity()..scale(_pressed ? 0.93 : 1.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: widget.gradient.last.withOpacity(0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.emoji,
                      style: const TextStyle(fontSize: 48)),
                  const SizedBox(height: 12),
                  Text(widget.label,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.fredoka(
                          color: Colors.white, fontSize: 18)),
                  const SizedBox(height: 2),
                  Text(widget.sublabel,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.quicksand(
                          color: Colors.white70, fontSize: 11)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
