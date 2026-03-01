import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../auth/models/app_user.dart';

/// Shows a Parent Gate challenge and, on success, calls [onRoleSelected] with
/// the newly chosen [UserRole].
///
/// Touch surfaces: sequence-tap challenge (tap 4 → 7 → 9 in order).
/// Desktop / fallback: math puzzle (8 × 2 = ?).
Future<UserRole?> showModeSwitcher({
  required BuildContext context,
  required UserRole currentRole,
}) {
  return showDialog<UserRole>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _ModeSwitcherDialog(currentRole: currentRole),
  );
}

class _ModeSwitcherDialog extends StatefulWidget {
  final UserRole currentRole;
  const _ModeSwitcherDialog({required this.currentRole});

  @override
  State<_ModeSwitcherDialog> createState() => _ModeSwitcherDialogState();
}

class _ModeSwitcherDialogState extends State<_ModeSwitcherDialog>
    with SingleTickerProviderStateMixin {
  // --- sequence tap state ---
  static const _sequence = [4, 7, 9];
  int _seqProgress = 0;
  bool _seqFailed = false;

  // --- math fallback state ---
  final _mathController = TextEditingController();
  bool _mathError = false;

  late AnimationController _shakeController;
  late Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _shakeAnim = Tween<double>(begin: 0, end: 12).chain(
        CurveTween(curve: Curves.elasticIn)).animate(_shakeController);
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _mathController.dispose();
    super.dispose();
  }

  void _onSeqTap(int digit) {
    if (digit == _sequence[_seqProgress]) {
      setState(() => _seqProgress++);
      if (_seqProgress == _sequence.length) {
        _onChallengeSuccess();
      }
    } else {
      setState(() {
        _seqProgress = 0;
        _seqFailed = true;
      });
      _shakeController.forward(from: 0);
      Future.delayed(const Duration(seconds: 1),
          () => mounted ? setState(() => _seqFailed = false) : null);
    }
  }

  void _onMathSubmit() {
    if (_mathController.text.trim() == '16') {
      _onChallengeSuccess();
    } else {
      setState(() => _mathError = true);
      _shakeController.forward(from: 0);
      Future.delayed(const Duration(seconds: 1),
          () => mounted ? setState(() => _mathError = false) : null);
    }
  }

  void _onChallengeSuccess() {
    // Show role selector
    setState(() => _seqProgress = _sequence.length + 1); // enter role-pick state
  }

  @override
  Widget build(BuildContext context) {
    final bool challengePassed = _seqProgress > _sequence.length;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: const Color(0xFF1A1F3C),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: AnimatedBuilder(
          animation: _shakeAnim,
          builder: (context, child) => Transform.translate(
            offset: Offset(_shakeAnim.value * ((_shakeController.value < 0.5) ? 1 : -1), 0),
            child: child,
          ),
          child: challengePassed ? _RolePicker(currentRole: widget.currentRole) : _Challenge(
            seqProgress: _seqProgress,
            seqFailed: _seqFailed,
            mathController: _mathController,
            mathError: _mathError,
            onSeqTap: _onSeqTap,
            onMathSubmit: _onMathSubmit,
          ),
        ),
      ),
    );
  }
}

// ── Challenge Widget ───────────────────────────────────────────────────────────
class _Challenge extends StatelessWidget {
  final int seqProgress;
  final bool seqFailed;
  final TextEditingController mathController;
  final bool mathError;
  final void Function(int) onSeqTap;
  final VoidCallback onMathSubmit;

  const _Challenge({
    required this.seqProgress,
    required this.seqFailed,
    required this.mathController,
    required this.mathError,
    required this.onSeqTap,
    required this.onMathSubmit,
  });

  static const _sequence = [4, 7, 9];
  static const _digits = [1, 2, 3, 4, 5, 6, 7, 8, 9];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _headerRow('🔒 For Parents & Teachers',
            'This area requires adult verification', Colors.amberAccent),
        const SizedBox(height: 24),
        // ── Sequence tap challenge ──────────────────────────────
        Text('Tap in order: 4 → 7 → 9',
            style: GoogleFonts.quicksand(
                color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        _SequenceIndicator(progress: seqProgress, total: _sequence.length, failed: seqFailed),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: _digits.map((d) => _DigitButton(digit: d, onTap: onSeqTap)).toList(),
        ),

        const SizedBox(height: 24),
        const Divider(color: Colors.white12),
        const SizedBox(height: 12),

        // ── Math fallback ───────────────────────────────────────
        Text('OR answer: What is 8 × 2?',
            style: GoogleFonts.quicksand(
                color: Colors.white38, fontSize: 13)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: mathController,
                keyboardType: TextInputType.number,
                style: GoogleFonts.fredoka(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  filled: true,
                  fillColor: Colors.white10,
                  errorText: mathError ? 'Try again' : null,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: onMathSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amberAccent,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('Go', style: GoogleFonts.fredoka(color: Colors.black87, fontSize: 18)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel',
              style: GoogleFonts.quicksand(color: Colors.white30, fontSize: 13)),
        ),
      ],
    );
  }
}

// ── Role Picker Widget ─────────────────────────────────────────────────────────
class _RolePicker extends StatelessWidget {
  final UserRole currentRole;
  const _RolePicker({required this.currentRole});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _headerRow('✅ Verified!', 'Choose a mode to switch to', Colors.greenAccent),
        const SizedBox(height: 24),
        _RoleCard(
          icon: '🧒',
          label: 'Student Mode',
          subtitle: 'Practice Mode — Kids Lock ON',
          color: const Color(0xFF42A5F5),
          role: UserRole.student,
          current: currentRole,
        ),
        const SizedBox(height: 12),
        _RoleCard(
          icon: '👩‍🏫',
          label: 'Teacher Mode',
          subtitle: 'Instruction Mode — Stylus & Annotations',
          color: const Color(0xFF66BB6A),
          role: UserRole.teacher,
          current: currentRole,
        ),
        const SizedBox(height: 12),
        _RoleCard(
          icon: '👨‍👩‍👧',
          label: 'Parent / Admin Mode',
          subtitle: 'Oversight Mode — Analytics & Reports',
          color: const Color(0xFFEC407A),
          role: UserRole.parent,
          current: currentRole,
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Stay in current mode',
              style: GoogleFonts.quicksand(color: Colors.white30, fontSize: 13)),
        ),
      ],
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String icon;
  final String label;
  final String subtitle;
  final Color color;
  final UserRole role;
  final UserRole current;

  const _RoleCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.role,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCurrent = role == current;
    return Semantics(
      label: '$label. $subtitle${isCurrent ? '. Currently active.' : ''}',
      button: true,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: isCurrent ? color.withOpacity(0.25) : Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: isCurrent ? color : Colors.white12,
              width: isCurrent ? 2 : 1),
        ),
        child: ListTile(
          onTap: isCurrent ? null : () => Navigator.pop(context, role),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          leading: Text(icon, style: const TextStyle(fontSize: 30)),
          title: Text(label,
              style: GoogleFonts.fredoka(color: Colors.white, fontSize: 18)),
          subtitle: Text(subtitle,
              style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12)),
          trailing: isCurrent
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color: color.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8)),
                  child: Text('Active',
                      style: GoogleFonts.quicksand(
                          color: color, fontSize: 11, fontWeight: FontWeight.w700)),
                )
              : Icon(Icons.arrow_forward_ios_rounded,
                  color: Colors.white30, size: 16),
        ),
      ),
    );
  }
}

// ── Shared helpers ─────────────────────────────────────────────────────────────
Widget _headerRow(String title, String sub, Color accent) {
  return Column(
    children: [
      Text(title,
          style: GoogleFonts.fredoka(
              color: accent, fontSize: 22, fontWeight: FontWeight.w600)),
      const SizedBox(height: 4),
      Text(sub,
          textAlign: TextAlign.center,
          style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13)),
    ],
  );
}

class _SequenceIndicator extends StatelessWidget {
  final int progress;
  final int total;
  final bool failed;
  const _SequenceIndicator(
      {required this.progress, required this.total, required this.failed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final done = i < progress;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: failed
                ? Colors.redAccent
                : done
                    ? Colors.amberAccent
                    : Colors.white24,
          ),
        );
      }),
    );
  }
}

class _DigitButton extends StatelessWidget {
  final int digit;
  final void Function(int) onTap;
  const _DigitButton({required this.digit, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Tap $digit',
      button: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => onTap(digit),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white24),
          ),
          alignment: Alignment.center,
          child: Text(
            '$digit',
            style: GoogleFonts.fredoka(color: Colors.white, fontSize: 24),
          ),
        ),
      ),
    );
  }
}
