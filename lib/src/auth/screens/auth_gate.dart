import 'package:flutter/material.dart';
import '../../learning/screens/lesson_selection_screen.dart';
import '../../school/screens/teacher_dashboard_screen.dart';
import '../services/auth_service.dart';
import '../models/app_user.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder(
      stream: authService.userStream,
      builder: (context, snapshot) {
        // If the snapshot has user data, then they're already signed in.
        if (snapshot.hasData) {
          // For now, we allow the user to toggle between Kid and Teacher mode
          // in the dashboard for testing. In production, this would be
          // driven by the AppUser.role fetched from Firestore.
          
          return const _RoleWrapper();
        }

        // Otherwise, they are NOT signed in. Show a simple login screen.
        return Scaffold(
          backgroundColor: const Color(0xFFE1F5FE), // Light Sky Blue
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome to Phonics Kids Pro!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF37474F),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    await authService.signInAnonymously();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Start Learning (Guest)',
                    style: TextStyle(fontSize: 20, color: Colors.white),
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

class _RoleWrapper extends StatefulWidget {
  const _RoleWrapper({Key? key}) : super(key: key);

  @override
  _RoleWrapperState createState() => _RoleWrapperState();
}

class _RoleWrapperState extends State<_RoleWrapper> {
  bool _isTeacherMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _isTeacherMode ? const TeacherDashboardScreen() : const LessonSelectionScreen(),
          Positioned(
            top: 50,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.swap_horiz_rounded, size: 16, color: Colors.blueAccent),
                  const SizedBox(width: 4),
                  TextButton(
                    onPressed: () => setState(() => _isTeacherMode = !_isTeacherMode),
                    child: Text(
                      _isTeacherMode ? 'Switch to Kid' : 'Switch to Teacher',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
