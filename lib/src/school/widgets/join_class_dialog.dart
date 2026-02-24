import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../repositories/school_repository.dart';

class JoinClassDialog extends StatefulWidget {
  final String userId;
  const JoinClassDialog({Key? key, required this.userId}) : super(key: key);

  @override
  _JoinClassDialogState createState() => _JoinClassDialogState();
}

class _JoinClassDialogState extends State<JoinClassDialog> {
  final TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  void _handleJoin() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final success = await SchoolRepository().joinClassroom(
      widget.userId,
      _codeController.text.trim().toUpperCase(),
    );

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        Navigator.pop(context, true);
      } else {
        setState(() => _error = 'Invalid code. Please try again.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: Rounded_Corner_Border(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Join a Classroom',
              style: GoogleFonts.fredoka(fontSize: 22, color: const Color(0xFF37474F)),
            ),
            const SizedBox(height: 12),
            Text(
              'Enter the 6-digit code provided by your teacher.',
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _codeController,
              textAlign: TextAlign.center,
              maxLength: 6,
              style: GoogleFonts.fredoka(fontSize: 28, letterSpacing: 8, color: Colors.blueAccent),
              decoration: InputDecoration(
                counterText: '',
                filled: true,
                fillColor: Colors.blueAccent.withOpacity(0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                hintText: 'ABCDEF',
                hintStyle: TextStyle(color: Colors.blueAccent.withOpacity(0.2)),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 13)),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleJoin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: _isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text('JOIN NOW', style: GoogleFonts.fredoka(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Rounded_Corner_Border extends RoundedRectangleBorder {
  const Rounded_Corner_Border({required BorderRadiusGeometry borderRadius}) : super(borderRadius: borderRadius);
}
