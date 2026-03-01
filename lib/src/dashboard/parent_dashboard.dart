import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../auth/models/app_user.dart';
import '../auth/services/auth_service.dart';
import '../tracking/services/report_service.dart';
import 'mode_switcher_dialog.dart';

/// 👨‍👩‍👧 Oversight Mode Dashboard — data-driven hub for parents and admins.
class ParentDashboard extends StatefulWidget {
  final AppUser user;
  final void Function(UserRole) onModeChanged;

  const ParentDashboard({
    super.key,
    required this.user,
    required this.onModeChanged,
  });

  @override
  State<ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> {
  bool _emailSending = false;

  Future<void> _sendReport() async {
    setState(() => _emailSending = true);
    try {
      await ReportService().sendWeeklyReport(widget.user.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('📧 Weekly report sent!', style: GoogleFonts.quicksand()),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not send report. Try again later.', style: GoogleFonts.quicksand()),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _emailSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: const Color(0xFF0F1923),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _ParentHeader(user: widget.user, onModeChanged: widget.onModeChanged)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: _SubscriptionBanner(
                  hasSubscription: widget.user.hasActiveSubscription,
                  onUpgrade: () => context.push('/subscription'),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid(
                delegate: SliverChildListDelegate([
                  _ParentCard(
                    icon: Icons.bar_chart_rounded,
                    label: 'Student Progress',
                    sublabel: 'Analytics & Reports',
                    color: const Color(0xFF42A5F5),
                    onTap: () => context.push('/analytics'),
                  ),
                  _ParentCard(
                    icon: Icons.menu_book_rounded,
                    label: 'Open Textbook',
                    sublabel: 'Preview lessons',
                    color: const Color(0xFF66BB6A),
                    onTap: () => context.push('/textbook'),
                  ),
                  _ParentCard(
                    icon: Icons.workspace_premium_rounded,
                    label: 'Certificate',
                    sublabel: 'View & Download',
                    color: const Color(0xFFFFCA28),
                    onTap: () => context.push('/certificate'),
                  ),
                  _ParentCard(
                    icon: Icons.star_rounded,
                    label: 'Subscription',
                    sublabel: widget.user.hasActiveSubscription ? 'Pro Active ✓' : 'Upgrade to Pro',
                    color: const Color(0xFFEC407A),
                    onTap: () => context.push('/subscription'),
                  ),
                  _ParentCard(
                    icon: Icons.settings_rounded,
                    label: 'Settings',
                    sublabel: 'Profiles & Privacy',
                    color: Colors.white30,
                    onTap: () => context.push('/settings'),
                  ),
                  _ParentCard(
                    icon: Icons.email_outlined,
                    label: 'Email Report',
                    sublabel: 'Weekly PDF summary',
                    color: const Color(0xFF26C6DA),
                    loading: _emailSending,
                    onTap: _sendReport,
                  ),
                ]),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isTablet ? 3 : 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.05,
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: _LiteracyFormulaCard(),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 80),
                child: _ProgressPreview(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────
class _ParentHeader extends StatelessWidget {
  final AppUser user;
  final void Function(UserRole) onModeChanged;

  const _ParentHeader({required this.user, required this.onModeChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF880E4F), Color(0xFFEC407A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: const Color(0xFFEC407A).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Row(children: [
        const CircleAvatar(
          radius: 28,
          backgroundColor: Colors.white24,
          child: Icon(Icons.person_rounded, color: Colors.white, size: 30),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Oversight Mode', style: GoogleFonts.fredoka(color: Colors.white, fontSize: 22)),
            Text(user.email, style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 12)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)),
              child: Text('👨‍👩‍👧 Parent / Admin',
                  style: GoogleFonts.quicksand(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
            ),
          ]),
        ),
        Column(children: [
          IconButton(
            tooltip: 'Switch Mode',
            icon: const Icon(Icons.swap_horiz_rounded, color: Colors.white70),
            onPressed: () async {
              final role = await showModeSwitcher(context: context, currentRole: UserRole.parent);
              if (role != null && role != UserRole.parent) onModeChanged(role);
            },
          ),
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout_rounded, color: Colors.white38, size: 20),
            onPressed: () => AuthService().signOut(),
          ),
        ]),
      ]),
    );
  }
}

// ── Subscription Banner ───────────────────────────────────────────────────────
class _SubscriptionBanner extends StatelessWidget {
  final bool hasSubscription;
  final VoidCallback onUpgrade;

  const _SubscriptionBanner({required this.hasSubscription, required this.onUpgrade});

  @override
  Widget build(BuildContext context) {
    if (hasSubscription) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.greenAccent.withOpacity(0.3)),
        ),
        child: Row(children: [
          const Icon(Icons.check_circle_rounded, color: Colors.greenAccent, size: 18),
          const SizedBox(width: 8),
          Text('Pro Plan Active — All features unlocked',
              style: GoogleFonts.quicksand(color: Colors.greenAccent, fontSize: 13)),
        ]),
      );
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onUpgrade,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.amberAccent.withOpacity(0.4)),
          ),
          child: Row(children: [
            const Icon(Icons.star_rounded, color: Colors.amberAccent, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text('Free plan — Upgrade to unlock all 51 lessons',
                  style: GoogleFonts.quicksand(color: Colors.amberAccent, fontSize: 13)),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.amberAccent, size: 18),
          ]),
        ),
      ),
    );
  }
}

// ── Parent Action Card ────────────────────────────────────────────────────────
class _ParentCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final String sublabel;
  final Color color;
  final VoidCallback onTap;
  final bool loading;

  const _ParentCard({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.color,
    required this.onTap,
    this.loading = false,
  });

  @override
  State<_ParentCard> createState() => _ParentCardState();
}

class _ParentCardState extends State<_ParentCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${widget.label}. ${widget.sublabel}',
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);
          HapticFeedback.lightImpact();
          widget.onTap();
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          transform: Matrix4.identity()..scale(_pressed ? 0.95 : 1.0),
          decoration: BoxDecoration(
            color: _pressed ? widget.color.withOpacity(0.22) : widget.color.withOpacity(0.09),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _pressed ? widget.color.withOpacity(0.6) : widget.color.withOpacity(0.25),
            ),
            boxShadow: _pressed
                ? [BoxShadow(color: widget.color.withOpacity(0.2), blurRadius: 12, offset: const Offset(0, 4))]
                : [],
          ),
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.loading
                  ? SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(color: widget.color, strokeWidth: 2.5))
                  : Icon(widget.icon, color: widget.color, size: 32),
              const SizedBox(height: 10),
              Text(widget.label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.fredoka(color: Colors.white, fontSize: 15)),
              const SizedBox(height: 2),
              Text(widget.sublabel,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Literacy Formula Card ─────────────────────────────────────────────────────
class _LiteracyFormulaCard extends StatelessWidget {
  const _LiteracyFormulaCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.auto_graph_rounded, color: Color(0xFF42A5F5), size: 20),
          const SizedBox(width: 8),
          Text('Reading Comprehension Model',
              style: GoogleFonts.fredoka(color: Colors.white, fontSize: 16)),
        ]),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A237E).withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text('RC  =  Decoding  ×  Linguistic Comprehension',
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(
                  color: Colors.amberAccent, fontSize: 14, fontWeight: FontWeight.w700)),
        ),
        const SizedBox(height: 8),
        Text('Track decoding accuracy via textbook interactions.',
            style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 12)),
      ]),
    );
  }
}

// ── Progress Preview ──────────────────────────────────────────────────────────
class _ProgressPreview extends StatelessWidget {
  const _ProgressPreview();

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Recent Activity', style: GoogleFonts.fredoka(color: Colors.white70, fontSize: 18)),
        TextButton(
          onPressed: () => context.push('/analytics'),
          child: Text('View All',
              style: GoogleFonts.quicksand(color: const Color(0xFF42A5F5), fontSize: 13)),
        ),
      ]),
      const SizedBox(height: 12),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white12),
        ),
        child: Text(
          'Connect more sessions to see your child\'s phonics journey here.',
          style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 13),
          textAlign: TextAlign.center,
        ),
      ),
    ]);
  }
}
