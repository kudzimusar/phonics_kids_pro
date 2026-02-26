import 'package:flutter/material.dart';
import 'dart:math' as math;

class ParticleReward extends StatefulWidget {
  final bool trigger;
  final VoidCallback? onComplete;

  const ParticleReward({
    Key? key,
    required this.trigger,
    this.onComplete,
  }) : super(key: key);

  @override
  State<ParticleReward> createState() => _ParticleRewardState();
}

class _ParticleRewardState extends State<ParticleReward> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _controller.addListener(() {
      if (mounted) setState(() {});
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });
  }

  @override
  void didUpdateWidget(ParticleReward oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger && !oldWidget.trigger) {
      _burst();
    }
  }

  void _burst() {
    _particles.clear();
    for (int i = 0; i < 100; i++) {
      _particles.add(_Particle(
        color: Colors.primaries[_random.nextInt(Colors.primaries.length)],
        position: const Offset(0.5, 0.4), // Center-ish
        velocity: Offset(
          (_random.nextDouble() - 0.5) * 0.2,
          (_random.nextDouble() - 0.7) * 0.3,
        ),
        size: _random.nextDouble() * 10 + 5,
        rotation: _random.nextDouble() * math.pi * 2,
      ));
    }
    _controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.isAnimating) return const SizedBox.shrink();

    return IgnorePointer(
      child: CustomPaint(
        painter: _ConfettiPainter(
          particles: _particles,
          progress: _controller.value,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _Particle {
  final Color color;
  final Offset position;
  final Offset velocity;
  final double size;
  final double rotation;

  _Particle({
    required this.color,
    required this.position,
    required this.velocity,
    required this.size,
    required this.rotation,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;

  _ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final particle in particles) {
      final x = (particle.position.dx + particle.velocity.dx * progress * 5) * size.width;
      final y = (particle.position.dy + particle.velocity.dy * progress * 5 + 0.5 * 9.8 * progress * progress) * size.height;
      
      if (y > size.height) continue;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(particle.rotation + progress * 5);
      paint.color = particle.color.withOpacity(1.0 - progress);
      
      canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: particle.size, height: particle.size * 0.6),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
