import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../auth/models/app_user.dart';
import 'mode_switcher_dialog.dart';

/// Wraps a child in Toddler / Practice Mode lockdown.
///
/// - Intercepts back navigation with [PopScope]
/// - Triple-tap anywhere → Parent Gate → only then can the user exit or switch mode
/// - Optionally calls [onModeChanged] when a new [UserRole] is selected
class KidsLockOverlay extends StatefulWidget {
  final Widget child;
  final UserRole currentRole;
  final void Function(UserRole)? onModeChanged;

  const KidsLockOverlay({
    super.key,
    required this.child,
    required this.currentRole,
    this.onModeChanged,
  });

  @override
  State<KidsLockOverlay> createState() => _KidsLockOverlayState();
}

class _KidsLockOverlayState extends State<KidsLockOverlay> {
  int _tapCount = 0;
  DateTime _lastTap = DateTime.now();
  bool _showHint = false;

  void _handleTripleTap() {
    final now = DateTime.now();
    if (now.difference(_lastTap).inSeconds > 2) {
      _tapCount = 1;
    } else {
      _tapCount++;
    }
    _lastTap = now;

    if (_tapCount == 1) {
      // Show subtle hint
      setState(() => _showHint = true);
      Future.delayed(const Duration(seconds: 2),
          () => mounted ? setState(() => _showHint = false) : null);
    }

    if (_tapCount >= 3) {
      _tapCount = 0;
      setState(() => _showHint = false);
      _openParentGate();
    }
  }

  Future<void> _openParentGate() async {
    HapticFeedback.mediumImpact();
    final newRole = await showModeSwitcher(
      context: context,
      currentRole: widget.currentRole,
    );
    if (newRole != null && newRole != widget.currentRole && mounted) {
      widget.onModeChanged?.call(newRole);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop) {
          // Ask parent gate before allowing pop
          await _openParentGate();
        }
      },
      child: Stack(
        children: [
          widget.child,

          // Invisible triple-tap zone at top-right corner
          Positioned(
            top: 0,
            right: 0,
            width: 90,
            height: 90,
            child: Semantics(
              label: 'Ask a grown-up to help you leave',
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _handleTripleTap,
              ),
            ),
          ),

          // Subtle hint toast
          if (_showHint)
            Positioned(
              top: 48,
              right: 16,
              child: AnimatedOpacity(
                opacity: _showHint ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Ask a grown-up 👋',
                    style: GoogleFonts.quicksand(
                        color: Colors.white, fontSize: 13),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
