import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../auth/models/app_user.dart';
import '../auth/services/auth_service.dart';
import '../auth/services/user_service.dart';
import '../core/input/input_router.dart';
import 'student_dashboard.dart';
import 'teacher_dashboard_hub.dart';
import 'parent_dashboard.dart';

/// 🎛️ Mode Orchestrator — the central routing shell after login.
///
/// Streams the user's [AppUser] from Firestore and renders the
/// correct dashboard for their current role. Supports in-session
/// role switching via [ModeSwitcherDialog] without sign-out.
class RoleAwareDashboard extends StatefulWidget {
  const RoleAwareDashboard({super.key});

  @override
  State<RoleAwareDashboard> createState() => _RoleAwareDashboardState();
}

class _RoleAwareDashboardState extends State<RoleAwareDashboard> {
  /// Runtime session role override (does NOT write to Firestore).
  /// Null means "use the role from Firestore".
  UserRole? _sessionRoleOverride;

  void _onModeChanged(UserRole newRole) {
    setState(() => _sessionRoleOverride = newRole);
  }

  @override
  Widget build(BuildContext context) {
    final uid = AuthService().currentUser?.uid;

    if (uid == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return InputRouter(
      child: StreamBuilder<AppUser?>(
        stream: UserService().getUserStream(uid),
        builder: (context, snapshot) {
          // ── Loading ───────────────────────────────────────────
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _LoadingSplash();
          }

          // ── Error ─────────────────────────────────────────────
          if (snapshot.hasError || snapshot.data == null) {
            return _ErrorSplash(onRetry: () => setState(() {}));
          }

          final user = snapshot.data!;
          // Session override wins; otherwise use Firestore role.
          final role = _sessionRoleOverride ?? user.role;

          // ── Dispatch to correct dashboard ─────────────────────
          switch (role) {
            case UserRole.student:
              return StudentDashboard(
                user: user,
                onModeChanged: _onModeChanged,
              );
            case UserRole.teacher:
              return TeacherDashboardHub(
                user: user,
                onModeChanged: _onModeChanged,
              );
            case UserRole.parent:
            default:
              return ParentDashboard(
                user: user,
                onModeChanged: _onModeChanged,
              );
          }
        },
      ),
    );
  }
}

// ── Loading Splash ────────────────────────────────────────────────────────────
class _LoadingSplash extends StatelessWidget {
  const _LoadingSplash();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B4B),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🦊', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text('Loading your world…',
                style: GoogleFonts.fredoka(
                    color: Colors.white70, fontSize: 20)),
            const SizedBox(height: 24),
            const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                color: Colors.amberAccent,
                strokeWidth: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Error Splash ──────────────────────────────────────────────────────────────
class _ErrorSplash extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorSplash({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B4B),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, color: Colors.white38, size: 56),
            const SizedBox(height: 16),
            Text('Could not load your profile.',
                style: GoogleFonts.fredoka(
                    color: Colors.white70, fontSize: 20)),
            const SizedBox(height: 8),
            Text('Check your internet connection.',
                style: GoogleFonts.quicksand(
                    color: Colors.white38, fontSize: 14)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text('Retry',
                  style: GoogleFonts.fredoka(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amberAccent,
                foregroundColor: Colors.black87,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
