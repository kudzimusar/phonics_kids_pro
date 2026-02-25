import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../learning/screens/lesson_selection_screen.dart';
import '../../school/screens/teacher_dashboard_screen.dart';
import '../services/user_service.dart';
import '../models/app_user.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        
        // If the snapshot has user data, then they're already signed in.
        if (snapshot.hasData) {
          return ProfileInitializer(
            user: snapshot.data!,
            child: const _RoleWrapper(),
          );
        }

        // Otherwise, they are NOT signed in. Show custom production login screen.
        return const CustomAuthScreen();
      },
    );
  }
}

class CustomAuthScreen extends StatefulWidget {
  const CustomAuthScreen({Key? key}) : super(key: key);

  @override
  _CustomAuthScreenState createState() => _CustomAuthScreenState();
}

class _CustomAuthScreenState extends State<CustomAuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _submitAuth() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final auth = FirebaseAuth.instance;
      if (_isLogin) {
        await auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        await auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'Authentication failed.';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE1F5FE), // Light sky blue
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(32.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 15,
                  offset: Offset(0, 5),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.menu_book_rounded,
                  size: 64,
                  color: Colors.blueAccent,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Phonics Kids Pro',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF37474F),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isLogin ? 'Welcome back! Please sign in.' : 'Welcome! Please create an account.',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitAuth,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            _isLogin ? 'Sign In' : 'Sign Up',
                            style: const TextStyle(fontSize: 18, color: Colors.white),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                      _errorMessage = '';
                    });
                  },
                  child: Text(
                    _isLogin ? 'Need an account? Sign Up' : 'Already have an account? Sign In',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileInitializer extends StatefulWidget {
  final User user;
  final Widget child;

  const ProfileInitializer({Key? key, required this.user, required this.child}) : super(key: key);

  @override
  _ProfileInitializerState createState() => _ProfileInitializerState();
}

class _ProfileInitializerState extends State<ProfileInitializer> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeProfile();
  }

  Future<void> _initializeProfile() async {
    try {
      final userService = UserService();
      final existingUser = await userService.getUser(widget.user.uid);

      if (existingUser == null) {
        // Create new robust profile
        final newUser = AppUser(
          id: widget.user.uid,
          email: widget.user.email ?? '',
          role: UserRole.parent, // Defaulting to parent/student account
        );
        await userService.createUserProfile(newUser);
      }
    } catch (e, stackTrace) {
      debugPrint('Error initializing user profile: $e');
      debugPrint(stackTrace.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return widget.child;
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
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.logout, size: 16, color: Colors.red),
                    onPressed: () => FirebaseAuth.instance.signOut(),
                    tooltip: 'Logout',
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
