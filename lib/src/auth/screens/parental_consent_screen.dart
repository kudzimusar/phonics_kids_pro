import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

/// COPPA / GDPR-K compliant parental consent gate.
/// Shown once on first launch before any data collection begins.
/// Consent record is written to Firestore on acceptance.
class ParentalConsentScreen extends StatefulWidget {
  final VoidCallback onAccepted;

  const ParentalConsentScreen({super.key, required this.onAccepted});

  @override
  State<ParentalConsentScreen> createState() => _ParentalConsentScreenState();
}

class _ParentalConsentScreenState extends State<ParentalConsentScreen> {
  bool _agreed = false;
  bool _saving = false;

  Future<void> _acceptConsent() async {
    if (!_agreed) return;
    setState(() => _saving = true);

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('consent')
            .add({
          'accepted': true,
          'timestamp': FieldValue.serverTimestamp(),
          'version': '1.0',
        });
      }
      widget.onAccepted();
    } catch (e) {
      debugPrint('Consent write error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Could not save consent. Check your connection.')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
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
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                children: [
                  // ── Icon ────────────────────────────────────────
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.amberAccent.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.shield_rounded,
                        color: Colors.amberAccent, size: 40),
                  ),
                  const SizedBox(height: 20),

                  Text('Parent or Guardian?',
                      style: GoogleFonts.fredoka(
                          color: Colors.white, fontSize: 28)),
                  const SizedBox(height: 8),
                  Text(
                    'Phonics Kids Pro is designed for young children. '
                    'Before we collect any data, we need you — an adult — '
                    'to review and accept our privacy practices.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
                        color: Colors.white60, fontSize: 14),
                  ),
                  const SizedBox(height: 28),

                  // ── Summary Points ───────────────────────────────
                  _ConsentPoint(
                    icon: Icons.child_care_rounded,
                    text:
                        'This app is designed for children under 4 (COPPA / GDPR-K compliant).',
                  ),
                  _ConsentPoint(
                    icon: Icons.storage_rounded,
                    text:
                        'We collect reading progress data to personalise the experience. No ads are shown.',
                  ),
                  _ConsentPoint(
                    icon: Icons.no_photography_rounded,
                    text:
                        'We do not collect photos, contacts, or location data.',
                  ),
                  _ConsentPoint(
                    icon: Icons.delete_forever_rounded,
                    text:
                        'You can request deletion of all data at any time via Settings.',
                  ),
                  const SizedBox(height: 24),

                  // ── Legal Links ──────────────────────────────────
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.quicksand(
                          color: Colors.white38, fontSize: 13),
                      children: [
                        const TextSpan(text: 'By continuing you agree to our '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: const TextStyle(
                              color: Colors.amberAccent,
                              decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => _openUrl(
                                'https://phonicskidspro.com/privacy'),
                        ),
                        const TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Terms of Service',
                          style: const TextStyle(
                              color: Colors.amberAccent,
                              decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => _openUrl(
                                'https://phonicskidspro.com/terms'),
                        ),
                        const TextSpan(text: '.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Checkbox ─────────────────────────────────────
                  Semantics(
                    label:
                        'I confirm I am a parent or guardian and I agree to the privacy policy',
                    checked: _agreed,
                    child: CheckboxListTile(
                      value: _agreed,
                      onChanged: (v) => setState(() => _agreed = v ?? false),
                      activeColor: Colors.amberAccent,
                      checkColor: Colors.black87,
                      tileColor: Colors.white.withOpacity(0.05),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      title: Text(
                        'I confirm I am a parent or guardian and I understand how data is used.',
                        style: GoogleFonts.quicksand(
                            color: Colors.white70, fontSize: 13),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── CTA ──────────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: (_agreed && !_saving) ? _acceptConsent : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amberAccent,
                        disabledBackgroundColor: Colors.white12,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      child: _saving
                          ? const CircularProgressIndicator(
                              color: Colors.black87)
                          : Text('I Agree — Continue',
                              style: GoogleFonts.fredoka(
                                  color: Colors.black87, fontSize: 20)),
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

class _ConsentPoint extends StatelessWidget {
  final IconData icon;
  final String text;
  const _ConsentPoint({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.amberAccent, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: GoogleFonts.quicksand(
                    color: Colors.white60, fontSize: 13,
                    height: 1.5)),
          ),
        ],
      ),
    );
  }
}
