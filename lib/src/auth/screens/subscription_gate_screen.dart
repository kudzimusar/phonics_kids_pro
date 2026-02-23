import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../auth/services/payment_gateway.dart';

/// SubscriptionGate - shown when a user on the Free tier tries to access
/// premium content. Full-screen paywall with plan cards.
class SubscriptionGateScreen extends StatefulWidget {
  const SubscriptionGateScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionGateScreen> createState() => _SubscriptionGateScreenState();
}

class _SubscriptionGateScreenState extends State<SubscriptionGateScreen> {
  bool _isLoading = false;
  String? _selectedPlan;

  Future<void> _subscribe(String planId, String email) async {
    setState(() {
      _isLoading = true;
      _selectedPlan = planId;
    });
    try {
      await PaymentGateway().initiateSubscription(email: email, tierId: planId);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A237E), // Deep Indigo night sky
      body: SafeArea(
        child: Column(
          children: [
            // ── HEADER ────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
              child: Column(
                children: [
                  Text(
                    '⭐  Go Pro!',
                    style: GoogleFonts.fredoka(
                      fontSize: 40,
                      color: Colors.amberAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Unlock every lesson, unlimited practice,\nand real-time AI pronunciation coaching.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
                      fontSize: 18,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // ── PLAN CARDS ────────────────────────────────────────────────
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _PlanCard(
                    title: 'Pro Monthly',
                    price: r'$4.99',
                    period: '/ month',
                    color: const Color(0xFF42A5F5),
                    perks: const [
                      'Access all 51 phonics sections',
                      'AI voice grading after every attempt',
                      'Parent progress dashboard',
                    ],
                    isHighlighted: false,
                    isLoading: _isLoading && _selectedPlan == 'pro_monthly',
                    onTap: () => _subscribe('pro_monthly', 'user@example.com'),
                  ),
                  const SizedBox(height: 16),
                  _PlanCard(
                    title: 'Pro Annual',
                    price: r'$39.99',
                    period: '/ year  — Save 33%',
                    color: const Color(0xFF66BB6A),
                    perks: const [
                      'Everything in Pro Monthly',
                      'Priority AI grading queue',
                      'Offline lesson downloads',
                    ],
                    isHighlighted: true,
                    isLoading: _isLoading && _selectedPlan == 'pro_annual',
                    onTap: () => _subscribe('pro_annual', 'user@example.com'),
                  ),
                  const SizedBox(height: 16),
                  _PlanCard(
                    title: 'School / Family',
                    price: r'$99',
                    period: '/ year, up to 10 children',
                    color: const Color(0xFFEC407A),
                    perks: const [
                      'Everything in Pro Annual',
                      'Classroom group dashboard',
                      'CSV export & reporting',
                    ],
                    isHighlighted: false,
                    isLoading: _isLoading && _selectedPlan == 'school',
                    onTap: () => _subscribe('school', 'user@example.com'),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Maybe later — continue with Free',
                        style: GoogleFonts.quicksand(
                          color: Colors.white38,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Internal plan card widget
// ─────────────────────────────────────────────────────────────────────────────
class _PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String period;
  final Color color;
  final List<String> perks;
  final bool isHighlighted;
  final bool isLoading;
  final VoidCallback onTap;

  const _PlanCard({
    required this.title,
    required this.price,
    required this.period,
    required this.color,
    required this.perks,
    required this.isHighlighted,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isHighlighted
            ? color.withOpacity(0.2)
            : Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isHighlighted ? color : Colors.white24,
          width: isHighlighted ? 2.5 : 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (isHighlighted)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'BEST VALUE',
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                const Spacer(),
                Text(
                  price,
                  style: GoogleFonts.fredoka(
                    fontSize: 32,
                    color: color,
                  ),
                ),
              ],
            ),
            Text(
              title,
              style: GoogleFonts.fredoka(fontSize: 22, color: Colors.white),
            ),
            Text(
              period,
              style: GoogleFonts.quicksand(
                  fontSize: 13, color: Colors.white54),
            ),
            const SizedBox(height: 14),
            ...perks.map((perk) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_rounded,
                          size: 18, color: color),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          perk,
                          style: GoogleFonts.quicksand(
                              color: Colors.white70, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child:
                            CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : Text(
                        'Subscribe',
                        style: GoogleFonts.fredoka(
                            fontSize: 20, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
