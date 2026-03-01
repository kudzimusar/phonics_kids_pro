import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'firebase_options.dart';
import 'src/auth/screens/auth_gate.dart';
import 'src/auth/screens/payment_success_screen.dart';
import 'src/auth/screens/payment_cancel_screen.dart';
import 'src/auth/screens/subscription_gate_screen.dart';
import 'src/auth/services/auth_service.dart';
import 'src/auth/services/user_service.dart';
import 'src/auth/models/app_user.dart';
import 'src/learning/textbook/textbook_screen.dart';
import 'src/learning/screens/lesson_selection_screen.dart';
import 'src/learning/screens/sticker_book_screen.dart';
import 'src/settings/screens/settings_screen.dart';
import 'src/tracking/screens/progress_dashboard.dart';
import 'src/school/screens/teacher_dashboard_screen.dart';
import 'src/school/screens/classroom_detail_screen.dart';
import 'src/school/repositories/school_repository.dart';
import 'src/school/models/classroom.dart';
import 'src/dashboard/role_aware_dashboard.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'src/core/config/app_config.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';

// ── Scroll behaviour (all pointer kinds) ─────────────────────────────────────
class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
        PointerDeviceKind.invertedStylus,
      };

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics();
}

// ── App Initialisation ────────────────────────────────────────────────────────
Future<void> initializeApp(Environment env) async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.init(env);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  try {
    final stripeKey = AppConfig.instance.stripePublishableKey;
    if (stripeKey.isNotEmpty && !stripeKey.contains('placeholder')) {
      Stripe.publishableKey = stripeKey;
    }
  } catch (e) {
    debugPrint('Error initializing Stripe: $e');
  }
}

void main() async {
  await initializeApp(Environment.dev);
  runApp(const PhonicsKidsProApp());
}

// ── Router ────────────────────────────────────────────────────────────────────
final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    // ── Auth & onboarding ──────────────────────────────────────────────────
    GoRoute(path: '/', builder: (_, __) => const AuthGate()),

    // ── Main Dashboard ─────────────────────────────────────────────────────
    GoRoute(path: '/dashboard', builder: (_, __) => const RoleAwareDashboard()),

    // ── Textbook (deep-link supports ?page=<id>) ───────────────────────────
    GoRoute(
      path: '/textbook',
      builder: (_, state) {
        final pageId = state.uri.queryParameters['page'];
        return TextbookScreen(initialPageId: pageId);
      },
    ),

    // ── Certificate (jumps textbook to the last/cert page) ────────────────
    GoRoute(
      path: '/certificate',
      builder: (_, __) => const TextbookScreen(initialPageId: 'certificate-page'),
    ),

    // ── Lessons ────────────────────────────────────────────────────────────
    GoRoute(
      path: '/lessons',
      builder: (_, __) => const _DashBackShell(
        title: 'Lessons',
        child: LessonSelectionScreen(),
      ),
    ),

    // ── Sticker / Trophy Room ──────────────────────────────────────────────
    GoRoute(
      path: '/stickers',
      builder: (_, __) => const _DashBackShell(
        title: 'Trophy Room',
        child: StickerBookScreen(),
      ),
    ),

    // ── Analytics ──────────────────────────────────────────────────────────
    GoRoute(
      path: '/analytics',
      builder: (_, __) => const _DashBackShell(
        title: 'Analytics',
        child: ParentProgressTable(),
      ),
    ),

    // ── Classrooms list ────────────────────────────────────────────────────
    GoRoute(
      path: '/classrooms',
      builder: (_, __) => const _DashBackShell(
        title: 'Classrooms',
        child: TeacherDashboardScreen(),
      ),
    ),

    // ── Single classroom detail ────────────────────────────────────────────
    GoRoute(
      path: '/classrooms/:id',
      builder: (_, state) {
        final id = state.pathParameters['id'] ?? '';
        return _ClassroomLoader(classroomId: id);
      },
    ),

    // ── Subscription / Paywall ─────────────────────────────────────────────
    GoRoute(
      path: '/subscription',
      builder: (_, __) => const SubscriptionGateScreen(),
    ),

    // ── Settings ───────────────────────────────────────────────────────────
    GoRoute(path: '/settings', builder: (_, __) => const _SettingsLoader()),

    // ── Payment callbacks ──────────────────────────────────────────────────
    GoRoute(path: '/payment-success', builder: (_, __) => const PaymentSuccessScreen()),
    GoRoute(path: '/payment-cancel', builder: (_, __) => const PaymentCancelScreen()),
  ],
);

// ── App Root ──────────────────────────────────────────────────────────────────
class PhonicsKidsProApp extends StatelessWidget {
  const PhonicsKidsProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Phonics Kids Pro — Read Before Four',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF42A5F5),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0D1B4B),
      ),
      scrollBehavior: CustomScrollBehavior(),
      routerConfig: _router,
    );
  }
}

// ── Universal Dashboard Back Shell ────────────────────────────────────────────
/// Wraps any sub-page with a consistent AppBar that includes a
/// back-to-dashboard chevron. Replaces all Navigator.push(MaterialPageRoute)
/// patterns so every sub-page always has a clear route home.
class _DashBackShell extends StatelessWidget {
  final String title;
  final Widget child;

  const _DashBackShell({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1923),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1018),
        elevation: 0,
        leading: IconButton(
          tooltip: 'Back to Dashboard',
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white70),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/dashboard');
            }
          },
        ),
        title: Text(
          title,
          style: GoogleFonts.fredoka(color: Colors.white, fontSize: 20),
        ),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.home_rounded, color: Colors.white38, size: 18),
            label: Text('Dashboard',
                style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 12)),
            onPressed: () => context.go('/dashboard'),
          ),
        ],
      ),
      body: child,
    );
  }
}

// ── Classroom Loader ──────────────────────────────────────────────────────────
/// Fetches a Classroom from Firestore by ID then shows ClassroomDetailScreen.
class _ClassroomLoader extends StatelessWidget {
  final String classroomId;
  const _ClassroomLoader({required this.classroomId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Classroom?>(
      future: SchoolRepository().getClassroomById(classroomId),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Scaffold(
              backgroundColor: Color(0xFF0F1923),
              body: Center(child: CircularProgressIndicator(color: Color(0xFF00BCD4))));
        }
        final classroom = snap.data;
        if (classroom == null) {
          return _DashBackShell(
            title: 'Classroom',
            child: const Center(child: Text('Classroom not found.')),
          );
        }
        return ClassroomDetailScreen(classroom: classroom);
      },
    );
  }
}

// ── Settings Loader ───────────────────────────────────────────────────────────
class _SettingsLoader extends StatelessWidget {
  const _SettingsLoader();

  @override
  Widget build(BuildContext context) {
    final uid = AuthService().currentUser?.uid ?? '';
    return StreamBuilder<AppUser?>(
      stream: UserService().getUserStream(uid),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        return snap.data != null
            ? SettingsScreen(user: snap.data!)
            : const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
