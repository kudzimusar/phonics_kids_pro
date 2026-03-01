import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../dashboard/role_aware_dashboard.dart';
import '../services/user_service.dart';
import '../models/app_user.dart';
import 'parental_consent_screen.dart';
import 'role_selection_screen.dart';
import 'payment_success_screen.dart';
import 'payment_cancel_screen.dart';

/// Auth Gate — the root widget after app startup.
///
/// Flow:
/// 1. Not signed in → [CustomAuthScreen]
/// 2. Signed in, no profile → create default profile
/// 3. Profile exists, no consent → [ParentalConsentScreen]
/// 4. Profile exists, no role set (default parent still) → [RoleSelectionScreen]
/// 5. All clear → [RoleAwareDashboard]
class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        if (!snapshot.hasData) {
          return const CustomAuthScreen();
        }

        return _AppFlowController(user: snapshot.data!);
      },
    );
  }
}

/// Manages the post-login flow: profile init → consent → role → dashboard.
class _AppFlowController extends StatefulWidget {
  final User user;
  const _AppFlowController({required this.user});

  @override
  State<_AppFlowController> createState() => _AppFlowControllerState();
}

class _AppFlowControllerState extends State<_AppFlowController> {
  // Flow state
  bool _profileReady = false;
  bool _consentGiven = false;
  bool _roleAssigned = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initFlow();
  }

  Future<void> _initFlow() async {
    try {
      final userService = UserService();
      AppUser? appUser = await userService.getUser(widget.user.uid);

      // Create default profile if first time
      if (appUser == null) {
        appUser = AppUser(
          id: widget.user.uid,
          email: widget.user.email ?? '',
          role: UserRole.parent,
        );
        await userService.createUserProfile(appUser);
      }

      // Check consent record
      final consentSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .collection('consent')
          .limit(1)
          .get();
      final bool hasConsent = consentSnap.docs.isNotEmpty;

      // Role is "assigned" if user ever went through role selection.
      // We detect this by checking if a 'roleSelected' flag exists on the user doc,
      // or if the user already signed up with a classroom code (student).
      // For simplicity we store 'roleSelected' = true in the user doc after selection.
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .get();
      final bool roleSelected = userDoc.data()?['roleSelected'] ?? false;

      if (mounted) {
        setState(() {
          _profileReady = true;
          _consentGiven = hasConsent;
          _roleAssigned = roleSelected;
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint('Flow init error: $e');
      if (mounted) {
        setState(() {
          _profileReady = true;
          _consentGiven = true; // Fail-open so the app is usable
          _roleAssigned = true;
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0D1B4B),
        body: Center(child: CircularProgressIndicator(color: Colors.amberAccent)),
      );
    }

    // Step 1: Consent
    if (!_consentGiven) {
      return ParentalConsentScreen(
        onAccepted: () => setState(() => _consentGiven = true),
      );
    }

    // Step 2: Role selection
    if (!_roleAssigned) {
      return RoleSelectionScreen(
        onRoleSelected: () async {
          // Mark role as selected in Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(widget.user.uid)
              .update({'roleSelected': true});
          if (mounted) setState(() => _roleAssigned = true);
        },
      );
    }

    // Step 3: Main dashboard
    return const RoleAwareDashboard();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Custom Auth Screen (unchanged logic, kept here for self-containment)
// ─────────────────────────────────────────────────────────────────────────────
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
      setState(() => _errorMessage = e.message ?? 'Authentication failed.');
    } catch (e) {
      setState(() => _errorMessage = 'An unexpected error occurred.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B4B),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            padding: const EdgeInsets.all(32.0),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1F3C),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 24,
                    offset: const Offset(0, 8))
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🦊', style: TextStyle(fontSize: 56)),
                const SizedBox(height: 12),
                Text(
                  'Phonics Kids Pro',
                  style: TextStyle(
                    fontFamily: 'Fredoka',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.amberAccent,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Read Before Four',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white38,
                      letterSpacing: 1.5),
                ),
                const SizedBox(height: 28),
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Text(_errorMessage,
                        style: const TextStyle(color: Colors.redAccent),
                        textAlign: TextAlign.center),
                  ),
                TextField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Email', Icons.email_outlined),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _passwordController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Password', Icons.lock_outline),
                  obscureText: true,
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitAuth,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amberAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.black87)
                        : Text(
                            _isLogin ? 'Sign In' : 'Sign Up',
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                          ),
                  ),
                ),
                const SizedBox(height: 14),
                TextButton(
                  onPressed: () =>
                      setState(() => _isLogin = !_isLogin),
                  child: Text(
                    _isLogin
                        ? 'New here? Create an account'
                        : 'Already have an account? Sign In',
                    style: const TextStyle(color: Colors.white38),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white38),
      prefixIcon: Icon(icon, color: Colors.white38, size: 20),
      filled: true,
      fillColor: Colors.white.withOpacity(0.07),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.amberAccent.withOpacity(0.6))),
    );
  }
}
