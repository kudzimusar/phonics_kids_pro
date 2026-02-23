import 'package:flutter/material.dart';
import '../../learning/screens/lesson_selection_screen.dart';
import '../services/auth_service.dart';

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
          // Send them to the Lesson Selection Hub
          return const LessonSelectionScreen();
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
