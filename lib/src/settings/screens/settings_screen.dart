import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../auth/models/app_user.dart';
import '../../auth/services/auth_service.dart';
import '../../tracking/services/report_service.dart';

/// Settings screen — multi-profile management, privacy, and feedback.
class SettingsScreen extends StatefulWidget {
  final AppUser user;
  const SettingsScreen({super.key, required this.user});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1923),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1018),
        elevation: 0,
        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white70),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/dashboard');
            }
          },
        ),
        title: Text('Settings',
            style: GoogleFonts.fredoka(color: Colors.white, fontSize: 22)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF42A5F5),
          labelColor: const Color(0xFF42A5F5),
          unselectedLabelColor: Colors.white38,
          tabs: const [
            Tab(text: 'Account'),
            Tab(text: 'Privacy'),
            Tab(text: 'Feedback'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _AccountTab(user: widget.user),
          const _PrivacyTab(),
          _FeedbackTab(user: widget.user),
        ],
      ),
    );
  }
}

// ── Account Tab ───────────────────────────────────────────────────────────────
class _AccountTab extends StatelessWidget {
  final AppUser user;
  const _AccountTab({required this.user});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const _SectionHeader('Profile'),
        _InfoTile(icon: Icons.email_outlined, label: 'Email', value: user.email),
        _InfoTile(
          icon: Icons.person_rounded,
          label: 'Role',
          value: user.role.name[0].toUpperCase() + user.role.name.substring(1),
        ),
        _InfoTile(
          icon: Icons.workspace_premium_rounded,
          label: 'Subscription',
          value: user.hasActiveSubscription ? 'Pro — Active' : 'Free',
        ),
        const SizedBox(height: 24),
        const _SectionHeader('Child Profiles (up to 5)'),
        const _ChildProfilesPlaceholder(),
        const SizedBox(height: 24),
        _DangerButton(
          label: 'Sign Out',
          icon: Icons.logout_rounded,
          color: Colors.redAccent,
          onTap: () => AuthService().signOut(),
        ),
      ],
    );
  }
}

// ── Privacy Tab ───────────────────────────────────────────────────────────────
class _PrivacyTab extends StatelessWidget {
  const _PrivacyTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const _SectionHeader('Data & Compliance'),
        const _PolicyTile(
          icon: Icons.shield_rounded,
          label: 'Privacy Policy',
          url: 'https://phonicskidspro.com/privacy',
        ),
        const _PolicyTile(
          icon: Icons.gavel_rounded,
          label: 'Terms of Service',
          url: 'https://phonicskidspro.com/terms',
        ),
        const SizedBox(height: 20),
        const _SectionHeader('Your Rights'),
        const _ConsentInfo(),
        const SizedBox(height: 20),
        _DangerButton(
          label: 'Request Data Deletion',
          icon: Icons.delete_forever_rounded,
          color: Colors.orangeAccent,
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                backgroundColor: const Color(0xFF1A1F3C),
                title: Text('Request Data Deletion',
                    style: GoogleFonts.fredoka(color: Colors.white)),
                content: Text(
                  'To delete all your data, email privacy@phonicskidspro.com with your account email. We will process it within 30 days per GDPR.',
                  style: GoogleFonts.quicksand(color: Colors.white70),
                ),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK')),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

// ── Feedback Tab ──────────────────────────────────────────────────────────────
class _FeedbackTab extends StatefulWidget {
  final AppUser user;
  const _FeedbackTab({required this.user});
  @override
  State<_FeedbackTab> createState() => _FeedbackTabState();
}

class _FeedbackTabState extends State<_FeedbackTab> {
  final _controller = TextEditingController();
  bool _sending = false;
  bool _sent = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final msg = _controller.text.trim();
    if (msg.isEmpty) return;
    setState(() => _sending = true);
    try {
      await ReportService().sendFeedback(
        userId: widget.user.id,
        message: msg,
        role: widget.user.role.name,
      );
      if (mounted) setState(() => _sent = true);
      _controller.clear();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Could not send feedback. Try again later.')));
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader('Share Your Feedback'),
          const SizedBox(height: 4),
          Text(
            'A real human reads every message. We\'ll respond within 48 hours via your registered email.',
            style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13),
          ),
          const SizedBox(height: 20),
          if (_sent)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.greenAccent.withOpacity(0.3)),
              ),
              child: Row(children: [
                const Icon(Icons.check_circle_rounded,
                    color: Colors.greenAccent),
                const SizedBox(width: 10),
                Text('Thank you! Your feedback has been sent.',
                    style: GoogleFonts.quicksand(
                        color: Colors.greenAccent, fontSize: 13)),
              ]),
            )
          else ...[
            TextField(
              controller: _controller,
              maxLines: 6,
              style: GoogleFonts.quicksand(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'What would you like to improve or suggest?',
                hintStyle:
                    GoogleFonts.quicksand(color: Colors.white30),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _sending ? null : _submit,
                icon: _sending
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.send_rounded),
                label: Text('Send Feedback',
                    style: GoogleFonts.fredoka(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF42A5F5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Shared Widgets ────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader(this.label);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(label,
            style: GoogleFonts.fredoka(color: Colors.white70, fontSize: 18)),
      );
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoTile(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(children: [
        Icon(icon, color: const Color(0xFF42A5F5), size: 20),
        const SizedBox(width: 12),
        Text(label,
            style: GoogleFonts.quicksand(
                color: Colors.white54, fontSize: 13)),
        const Spacer(),
        Text(value,
            style: GoogleFonts.quicksand(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

class _PolicyTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String url;
  const _PolicyTile(
      {required this.icon, required this.label, required this.url});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: const Color(0xFF42A5F5)),
      title: Text(label,
          style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 14)),
      trailing: const Icon(Icons.open_in_new_rounded,
          color: Colors.white30, size: 16),
      onTap: () {
        // URLs gated behind parent settings — children cannot reach this
      },
    );
  }
}

class _ConsentInfo extends StatelessWidget {
  const _ConsentInfo();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Text(
        'Parental consent was recorded when you first set up this account. '
        'All data collection is COPPA and GDPR-K compliant. '
        'No advertising data is collected or sold.',
        style: GoogleFonts.quicksand(
            color: Colors.white54, fontSize: 13, height: 1.5),
      ),
    );
  }
}

class _ChildProfilesPlaceholder extends StatelessWidget {
  const _ChildProfilesPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: const Color(0xFF42A5F5).withOpacity(0.2)),
      ),
      child: Row(children: [
        const Icon(Icons.add_circle_outline_rounded,
            color: Color(0xFF42A5F5)),
        const SizedBox(width: 12),
        Text('Add child profile (coming soon)',
            style: GoogleFonts.quicksand(
                color: Colors.white54, fontSize: 13)),
      ]),
    );
  }
}

class _DangerButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _DangerButton(
      {required this.label,
      required this.icon,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: color, size: 18),
      label: Text(label, style: GoogleFonts.quicksand(color: color)),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color.withOpacity(0.4)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      ),
    );
  }
}
