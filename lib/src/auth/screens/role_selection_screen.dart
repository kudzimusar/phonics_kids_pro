import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/app_user.dart';
import '../services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Role selection screen shown after first sign-up.
/// Allows the user to identify themselves as Parent, Teacher, or Student.
/// Students require a classroom join code.
class RoleSelectionScreen extends StatefulWidget {
  final VoidCallback onRoleSelected;

  const RoleSelectionScreen({super.key, required this.onRoleSelected});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  UserRole? _selected;
  final _codeController = TextEditingController();
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    if (_selected == null) return;
    if (_selected == UserRole.student && _codeController.text.trim().isEmpty) {
      setState(() => _error = 'Please enter your classroom code.');
      return;
    }
    setState(() { _saving = true; _error = null; });

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        await UserService().updateUserRole(uid, _selected!);
        // TODO: if student, validate & store classroom join code
      }
      widget.onRoleSelected();
    } catch (e) {
      setState(() => _error = 'Could not save. Please try again.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B4B),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                children: [
                  Text('Who are you?',
                      style: GoogleFonts.fredoka(
                          color: Colors.white, fontSize: 32)),
                  const SizedBox(height: 8),
                  Text(
                    'Select your role so we can personalise your experience.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
                        color: Colors.white54, fontSize: 14),
                  ),
                  const SizedBox(height: 32),

                  // ── Role Cards ─────────────────────────────────
                  _RoleTile(
                    emoji: '👨‍👩‍👧',
                    label: "I'm a Parent",
                    sublabel: 'Manage your child\'s learning journey',
                    role: UserRole.parent,
                    selected: _selected,
                    onTap: () => setState(() => _selected = UserRole.parent),
                  ),
                  const SizedBox(height: 12),
                  _RoleTile(
                    emoji: '👩‍🏫',
                    label: "I'm a Teacher",
                    sublabel: 'Manage classrooms and track progress',
                    role: UserRole.teacher,
                    selected: _selected,
                    onTap: () => setState(() => _selected = UserRole.teacher),
                  ),
                  const SizedBox(height: 12),
                  _RoleTile(
                    emoji: '🧒',
                    label: "I'm a Student",
                    sublabel: 'Start learning phonics!',
                    role: UserRole.student,
                    selected: _selected,
                    onTap: () => setState(() => _selected = UserRole.student),
                  ),

                  // ── Classroom code for students ─────────────────
                  if (_selected == UserRole.student) ...[
                    const SizedBox(height: 20),
                    TextField(
                      controller: _codeController,
                      textCapitalization: TextCapitalization.characters,
                      style: GoogleFonts.fredoka(
                          color: Colors.white, fontSize: 20),
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(8),
                        FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
                      ],
                      decoration: InputDecoration(
                        hintText: 'CLASS CODE',
                        hintStyle: GoogleFonts.fredoka(
                            color: Colors.white30, fontSize: 20),
                        filled: true,
                        fillColor: Colors.white10,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none),
                        errorText: _error,
                      ),
                    ),
                  ],

                  if (_error != null && _selected != UserRole.student)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(_error!,
                          style: const TextStyle(color: Colors.redAccent)),
                    ),

                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: (_selected != null && !_saving) ? _confirm : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF42A5F5),
                        disabledBackgroundColor: Colors.white12,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      child: _saving
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text("Let's Go!",
                              style: GoogleFonts.fredoka(
                                  color: Colors.white, fontSize: 22)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleTile extends StatelessWidget {
  final String emoji;
  final String label;
  final String sublabel;
  final UserRole role;
  final UserRole? selected;
  final VoidCallback onTap;

  const _RoleTile({
    required this.emoji,
    required this.label,
    required this.sublabel,
    required this.role,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool active = selected == role;
    return Semantics(
      label: '$label. $sublabel',
      button: true,
      selected: active,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: active
                ? const Color(0xFF42A5F5).withOpacity(0.15)
                : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: active
                  ? const Color(0xFF42A5F5)
                  : Colors.white12,
              width: active ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: GoogleFonts.fredoka(
                            color: Colors.white, fontSize: 18)),
                    Text(sublabel,
                        style: GoogleFonts.quicksand(
                            color: Colors.white54, fontSize: 12)),
                  ],
                ),
              ),
              if (active)
                const Icon(Icons.check_circle_rounded,
                    color: Color(0xFF42A5F5)),
            ],
          ),
        ),
      ),
    );
  }
}
