import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

enum FoxExpression { idle, cheer, wrong }

/// PhonicFoxWidget - the mascot character sitting in the bottom-right corner.
/// Reacts to pronunciation results with animated transitions.
class PhonicFoxWidget extends StatefulWidget {
  final FoxExpression expression;

  const PhonicFoxWidget({Key? key, required this.expression}) : super(key: key);

  @override
  _PhonicFoxWidgetState createState() => _PhonicFoxWidgetState();
}

class _PhonicFoxWidgetState extends State<PhonicFoxWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  
  // Rive State Machine components
  SMITrigger? _successTrigger;
  SMITrigger? _failTrigger;
  Artboard? _riveArtboard;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(artboard, 'Fox State Machine');
    if (controller != null) {
      artboard.addController(controller);
      _successTrigger = controller.findSMI('success_trigger');
      _failTrigger = controller.findSMI('fail_trigger');
    }
  }

  @override
  void didUpdateWidget(covariant PhonicFoxWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.expression != oldWidget.expression &&
        widget.expression != FoxExpression.idle) {
      _controller.forward(from: 0.0);
      
      // Trigger Rive animation
      if (widget.expression == FoxExpression.cheer) {
        _successTrigger?.fire();
      } else if (widget.expression == FoxExpression.wrong) {
        _failTrigger?.fire();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _iconColor {
    switch (widget.expression) {
      case FoxExpression.cheer:
        return const Color(0xFF4CAF50); // Green
      case FoxExpression.wrong:
        return const Color(0xFFF44336); // Red
      case FoxExpression.idle:
        return const Color(0xFFFF9800); // Orange
    }
  }

  IconData get _icon {
    switch (widget.expression) {
      case FoxExpression.cheer:
        return Icons.sentiment_very_satisfied_rounded;
      case FoxExpression.wrong:
        return Icons.sentiment_dissatisfied_rounded;
      case FoxExpression.idle:
        return Icons.pets_rounded;
    }
  }

  String get _label {
    switch (widget.expression) {
      case FoxExpression.cheer:
        return 'Great job! 🎉';
      case FoxExpression.wrong:
        return 'Try again! 💪';
      case FoxExpression.idle:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_label.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              margin: const EdgeInsets.only(bottom: 6),
              decoration: BoxDecoration(
                color: _iconColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _iconColor.withOpacity(0.4)),
              ),
              child: Text(
                _label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _iconColor,
                ),
              ),
            ),
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: _iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: _iconColor.withOpacity(0.3), width: 3),
              boxShadow: [
                BoxShadow(
                  color: _iconColor.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 2,
                )
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Fallback Icon (Visible until Rive loads or if file missing)
                Icon(
                  _icon,
                  size: 80,
                  color: _iconColor,
                ),
                // Rive Animation Layer
                RiveAnimation.asset(
                  'assets/rive/phonic_fox.riv',
                  fit: BoxFit.contain,
                  onInit: _onRiveInit,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
