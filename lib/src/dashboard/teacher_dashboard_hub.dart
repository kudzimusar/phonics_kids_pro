import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../auth/models/app_user.dart';
import '../auth/services/auth_service.dart';
import '../school/repositories/school_repository.dart';
import '../school/models/classroom.dart';
import '../core/input/input_router.dart';
import 'mode_switcher_dialog.dart';

/// 👩‍🏫 Instruction Mode Dashboard — professional hub for teachers.
class TeacherDashboardHub extends StatefulWidget {
  final AppUser user;
  final void Function(UserRole) onModeChanged;

  const TeacherDashboardHub({
    super.key,
    required this.user,
    required this.onModeChanged,
  });

  @override
  State<TeacherDashboardHub> createState() => _TeacherDashboardHubState();
}

class _TeacherDashboardHubState extends State<TeacherDashboardHub> {
  int _selectedIndex = 0;

  static const _bgColor = Color(0xFF0F1923);
  static const _accentColor = Color(0xFF00BCD4);

  static const _tabs = [
    _TabInfo(Icons.dashboard_rounded, Icons.dashboard_outlined, 'Hub'),
    _TabInfo(Icons.class_rounded, Icons.class_outlined, 'Classes'),
    _TabInfo(Icons.bar_chart_rounded, Icons.bar_chart_outlined, 'Analytics'),
    _TabInfo(Icons.menu_book_rounded, Icons.menu_book_outlined, 'Textbook'),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 800;
    final modality = InputRouterScope.of(context);
    final stylusActive = modality == InputModality.stylus;

    return Scaffold(
      backgroundColor: _bgColor,
      body: Row(
        children: [
          if (isWide)
            _SideRail(
              tabs: _tabs,
              selected: _selectedIndex,
              onSelected: (i) => setState(() => _selectedIndex = i),
              stylusActive: stylusActive,
              onModeChanged: widget.onModeChanged,
            ),
          Expanded(
            child: Column(
              children: [
                _TeacherTopBar(
                  user: widget.user,
                  stylusActive: stylusActive,
                  onModeChanged: widget.onModeChanged,
                  currentTabTitle: _tabs[_selectedIndex].label,
                ),
                Expanded(child: _body()),
              ],
            ),
          ),
        ],
      ),
      // ── Bottom nav bar — only on narrow screens ──────────────────────────
      bottomNavigationBar: isWide
          ? null
          : Theme(
              // Override indicator colour so it never covers icon
              data: Theme.of(context).copyWith(
                navigationBarTheme: NavigationBarThemeData(
                  indicatorColor: _accentColor.withOpacity(0.22),
                  iconTheme: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return const IconThemeData(color: Color(0xFF00BCD4), size: 24);
                    }
                    return const IconThemeData(color: Colors.white38, size: 22);
                  }),
                  labelTextStyle: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return GoogleFonts.quicksand(
                          color: _accentColor, fontSize: 11, fontWeight: FontWeight.w700);
                    }
                    return GoogleFonts.quicksand(color: Colors.white38, fontSize: 11);
                  }),
                ),
              ),
              child: NavigationBar(
                backgroundColor: const Color(0xFF0A1018),
                surfaceTintColor: Colors.transparent,
                shadowColor: Colors.black,
                elevation: 8,
                selectedIndex: _selectedIndex,
                onDestinationSelected: (i) => setState(() => _selectedIndex = i),
                destinations: _tabs
                    .map((t) => NavigationDestination(
                          icon: Icon(t.outlinedIcon),
                          selectedIcon: Icon(t.icon),
                          label: t.label,
                        ))
                    .toList(),
              ),
            ),
    );
  }

  Widget _body() {
    switch (_selectedIndex) {
      case 0:
        return _TeacherHubHome(
          user: widget.user,
          onModeChanged: widget.onModeChanged,
          onSwitchTab: (i) => setState(() => _selectedIndex = i),
        );
      case 1:
        return _ClassroomsPanel(userId: widget.user.id);
      case 2:
        return _AnalyticsPanel(userId: widget.user.id);
      case 3:
        return _TextbookPanel();
      default:
        return const SizedBox.shrink();
    }
  }
}

class _TabInfo {
  final IconData icon;
  final IconData outlinedIcon;
  final String label;
  const _TabInfo(this.icon, this.outlinedIcon, this.label);
}

// ── Side Rail ─────────────────────────────────────────────────────────────────
class _SideRail extends StatelessWidget {
  final List<_TabInfo> tabs;
  final int selected;
  final ValueChanged<int> onSelected;
  final bool stylusActive;
  final void Function(UserRole) onModeChanged;

  const _SideRail({
    required this.tabs,
    required this.selected,
    required this.onSelected,
    required this.stylusActive,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      decoration: const BoxDecoration(
        color: Color(0xFF0A1018),
        border: Border(right: BorderSide(color: Colors.white10)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 52),
          const CircleAvatar(
            radius: 20,
            backgroundColor: Color(0xFF00BCD4),
            child: Text('P', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 20),
          ...tabs.asMap().entries.map((e) => _RailItem(
                icon: e.value.outlinedIcon,
                activeIcon: e.value.icon,
                label: e.value.label,
                index: e.key,
                selected: selected,
                onTap: onSelected,
              )),
          const Spacer(),
          if (stylusActive)
            Tooltip(
              message: 'Stylus Active',
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Icon(Icons.draw_rounded, color: Colors.cyanAccent.withOpacity(0.7), size: 22),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: IconButton(
              tooltip: 'Switch Mode',
              icon: const Icon(Icons.swap_horiz_rounded, color: Colors.white38),
              onPressed: () async {
                final role = await showModeSwitcher(context: context, currentRole: UserRole.teacher);
                if (role != null && role != UserRole.teacher) onModeChanged(role);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RailItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int index;
  final int selected;
  final ValueChanged<int> onTap;

  const _RailItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.index,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool active = index == selected;
    return Semantics(
      label: label,
      button: true,
      selected: active,
      child: Tooltip(
        message: label,
        child: InkWell(
          onTap: () => onTap(index),
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: active ? const Color(0xFF00BCD4).withOpacity(0.15) : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
              border: active ? Border.all(color: const Color(0xFF00BCD4).withOpacity(0.4)) : null,
            ),
            child: Icon(
              active ? activeIcon : icon,
              color: active ? const Color(0xFF00BCD4) : Colors.white38,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Top Bar ───────────────────────────────────────────────────────────────────
class _TeacherTopBar extends StatelessWidget {
  final AppUser user;
  final bool stylusActive;
  final void Function(UserRole) onModeChanged;
  final String currentTabTitle;

  const _TeacherTopBar({
    required this.user,
    required this.stylusActive,
    required this.onModeChanged,
    required this.currentTabTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0A1018),
      padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 12, 20, 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(currentTabTitle,
                    style: GoogleFonts.fredoka(color: const Color(0xFF00BCD4), fontSize: 22)),
                Text(user.email,
                    style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 12)),
              ],
            ),
          ),
          if (stylusActive)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.cyanAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.draw_rounded, color: Colors.cyanAccent, size: 14),
                const SizedBox(width: 4),
                Text('Stylus',
                    style: GoogleFonts.quicksand(color: Colors.cyanAccent, fontSize: 11, fontWeight: FontWeight.w700)),
              ]),
            ),
          TextButton.icon(
            icon: const Icon(Icons.swap_horiz_rounded, color: Color(0xFF00BCD4), size: 18),
            label: Text('Switch',
                style: GoogleFonts.quicksand(color: const Color(0xFF00BCD4), fontSize: 13)),
            onPressed: () async {
              final role = await showModeSwitcher(context: context, currentRole: UserRole.teacher);
              if (role != null && role != UserRole.teacher) onModeChanged(role);
            },
          ),
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout_rounded, color: Colors.white30, size: 20),
            onPressed: () => AuthService().signOut(),
          ),
        ],
      ),
    );
  }
}

// ── Hub Home ──────────────────────────────────────────────────────────────────
class _TeacherHubHome extends StatelessWidget {
  final AppUser user;
  final void Function(UserRole) onModeChanged;
  final ValueChanged<int> onSwitchTab;

  const _TeacherHubHome({
    required this.user,
    required this.onModeChanged,
    required this.onSwitchTab,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome back, Teacher!',
              style: GoogleFonts.fredoka(color: Colors.white, fontSize: 26)),
          const SizedBox(height: 4),
          Text('Here\'s your classroom at a glance.',
              style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 14)),
          const SizedBox(height: 24),

          FutureBuilder<List<Classroom>>(
            future: SchoolRepository().getTeacherClassrooms(user.id),
            builder: (context, snap) {
              final classrooms = snap.data ?? [];
              final studentCount = classrooms.fold(0, (sum, c) => sum + c.studentIds.length);
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _StatChip(icon: Icons.class_rounded, label: '${classrooms.length}', sub: 'Classes'),
                  _StatChip(icon: Icons.people_rounded, label: '$studentCount', sub: 'Students'),
                  _StatChip(icon: Icons.menu_book_rounded, label: '51', sub: 'Pages'),
                ],
              );
            },
          ),

          const SizedBox(height: 30),
          Text('Quick Actions',
              style: GoogleFonts.fredoka(color: Colors.white70, fontSize: 18)),
          const SizedBox(height: 16),

          LayoutBuilder(builder: (ctx, constraints) {
            final crossAxis = constraints.maxWidth > 500 ? 3 : 2;
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: crossAxis,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.1,
              children: [
                _TeacherCard(
                  icon: Icons.menu_book_rounded,
                  label: 'Open Textbook',
                  color: const Color(0xFF00BCD4),
                  onTap: () => context.push('/textbook'),
                ),
                _TeacherCard(
                  icon: Icons.class_rounded,
                  label: 'My Classrooms',
                  color: const Color(0xFF66BB6A),
                  onTap: () => onSwitchTab(1),
                ),
                _TeacherCard(
                  icon: Icons.bar_chart_rounded,
                  label: 'Analytics',
                  color: const Color(0xFFFF7043),
                  onTap: () => onSwitchTab(2),
                ),
                _TeacherCard(
                  icon: Icons.draw_rounded,
                  label: 'Annotate',
                  color: const Color(0xFFAB47BC),
                  onTap: () => context.push('/textbook'),
                ),
                _TeacherCard(
                  icon: Icons.workspace_premium_rounded,
                  label: 'Certificates',
                  color: const Color(0xFFFFCA28),
                  onTap: () => context.push('/certificate'),
                ),
                _TeacherCard(
                  icon: Icons.settings_rounded,
                  label: 'Settings',
                  color: Colors.white30,
                  onTap: () => context.push('/settings'),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

// ── Inline Classrooms Panel ────────────────────────────────────────────────────
class _ClassroomsPanel extends StatelessWidget {
  final String userId;
  const _ClassroomsPanel({required this.userId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Classroom>>(
      future: SchoolRepository().getTeacherClassrooms(userId),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF00BCD4)));
        }
        final classrooms = snap.data ?? [];
        if (classrooms.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.class_outlined, color: Colors.white24, size: 64),
                const SizedBox(height: 16),
                Text('No classrooms yet.', style: GoogleFonts.fredoka(color: Colors.white54, fontSize: 20)),
                const SizedBox(height: 8),
                Text('Create one from the School section.',
                    style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 13)),
              ],
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: classrooms.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, i) {
            final c = classrooms[i];
            return Material(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => context.push('/classrooms/${c.id}'),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(children: [
                    const Icon(Icons.class_rounded, color: Color(0xFF66BB6A), size: 32),
                    const SizedBox(width: 16),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(c.name, style: GoogleFonts.fredoka(color: Colors.white, fontSize: 18)),
                      Text('${c.studentIds.length} students',
                          style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 12)),
                    ])),
                    const Icon(Icons.chevron_right_rounded, color: Colors.white24),
                  ]),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// ── Inline Analytics Panel ────────────────────────────────────────────────────
class _AnalyticsPanel extends StatelessWidget {
  final String userId;
  const _AnalyticsPanel({required this.userId});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Student Analytics', style: GoogleFonts.fredoka(color: Colors.white, fontSize: 22)),
          const SizedBox(height: 4),
          Text('Track phonics mastery across your class.',
              style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 13)),
          const SizedBox(height: 24),
          // Literacy Formula
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1A237E).withOpacity(0.3),
              borderRadius: BorderRadius.circular(18),
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
              Center(
                child: Text('RC = Decoding × Linguistic Comprehension',
                    style: GoogleFonts.quicksand(
                        color: Colors.amberAccent, fontSize: 14, fontWeight: FontWeight.w700)),
              ),
            ]),
          ),
          const SizedBox(height: 24),
          // Full progress table
          const _ProgressTableWrapper(),
        ],
      ),
    );
  }
}

class _ProgressTableWrapper extends StatelessWidget {
  const _ProgressTableWrapper();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Text(
        'Progress data loads here from Firestore sessions.\nConnect students to a classroom to see tracking data.',
        style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 13),
        textAlign: TextAlign.center,
      ),
    );
  }
}

// ── Textbook Panel ────────────────────────────────────────────────────────────
class _TextbookPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.menu_book_rounded, color: Color(0xFF00BCD4), size: 64),
          const SizedBox(height: 16),
          Text('Interactive Textbook', style: GoogleFonts.fredoka(color: Colors.white, fontSize: 22)),
          const SizedBox(height: 8),
          Text('51 pages with phonics activities, annotation support, and auto-read.',
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 13)),
          const SizedBox(height: 28),
          ElevatedButton.icon(
            onPressed: () => context.push('/textbook'),
            icon: const Icon(Icons.open_in_new_rounded),
            label: Text('Open Textbook', style: GoogleFonts.fredoka(fontSize: 20)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00BCD4),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared Widgets ────────────────────────────────────────────────────────────
class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sub;
  const _StatChip({required this.icon, required this.label, required this.sub});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: const Color(0xFF00BCD4), size: 18),
        const SizedBox(width: 8),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: GoogleFonts.fredoka(color: Colors.white, fontSize: 18)),
          Text(sub, style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 11)),
        ]),
      ]),
    );
  }
}

class _TeacherCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _TeacherCard({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  State<_TeacherCard> createState() => _TeacherCardState();
}

class _TeacherCardState extends State<_TeacherCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.label,
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);
          HapticFeedback.selectionClick();
          widget.onTap();
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          transform: Matrix4.identity()..scale(_pressed ? 0.95 : 1.0),
          decoration: BoxDecoration(
            color: _pressed
                ? widget.color.withOpacity(0.25)
                : widget.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: _pressed
                    ? widget.color.withOpacity(0.7)
                    : widget.color.withOpacity(0.3)),
            boxShadow: _pressed
                ? [BoxShadow(color: widget.color.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))]
                : [],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, color: widget.color, size: 36),
              const SizedBox(height: 10),
              Text(widget.label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                      color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
