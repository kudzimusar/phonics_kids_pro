import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

/// Detects the primary input modality and provides it to descendants.
///
/// Usage:
/// ```dart
/// InputRouterScope(
///   child: Builder(builder: (ctx) {
///     final modality = InputRouterScope.of(ctx);
///     if (modality == InputModality.stylus) { ... }
///   }),
/// )
/// ```
enum InputModality { touch, mouse, stylus, keyboard, unknown }

class InputRouterScope extends InheritedWidget {
  final InputModality modality;
  final bool stylusDetected;

  const InputRouterScope({
    super.key,
    required this.modality,
    required this.stylusDetected,
    required super.child,
  });

  static InputRouterScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<InputRouterScope>();

  static InputModality of(BuildContext context) =>
      maybeOf(context)?.modality ?? InputModality.unknown;

  @override
  bool updateShouldNotify(InputRouterScope old) =>
      modality != old.modality || stylusDetected != old.stylusDetected;
}

/// Root widget that tracks pointer events to detect input modality.
class InputRouter extends StatefulWidget {
  final Widget child;
  const InputRouter({super.key, required this.child});

  @override
  State<InputRouter> createState() => _InputRouterState();
}

class _InputRouterState extends State<InputRouter> {
  InputModality _modality = InputModality.touch;
  bool _stylusDetected = false;

  void _onPointerDown(PointerDownEvent event) {
    InputModality detected;
    switch (event.kind) {
      case PointerDeviceKind.stylus:
      case PointerDeviceKind.invertedStylus:
        detected = InputModality.stylus;
        if (!_stylusDetected) {
          setState(() => _stylusDetected = true);
        }
        break;
      case PointerDeviceKind.mouse:
        detected = InputModality.mouse;
        break;
      case PointerDeviceKind.touch:
        detected = InputModality.touch;
        break;
      default:
        detected = InputModality.unknown;
    }
    if (detected != _modality) {
      setState(() => _modality = detected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _onPointerDown,
      behavior: HitTestBehavior.translucent,
      child: InputRouterScope(
        modality: _modality,
        stylusDetected: _stylusDetected,
        child: widget.child,
      ),
    );
  }
}

/// Convenient widget that shows different children based on modality.
class AdaptiveInputBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, InputModality modality) builder;
  const AdaptiveInputBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    final modality = InputRouterScope.of(context);
    return builder(context, modality);
  }
}

/// Wraps a child with a [MouseRegion] hover effect only on desktop/web.
class HoverEffect extends StatefulWidget {
  final Widget child;
  final Widget Function(BuildContext, bool hovering, Widget child) builder;

  const HoverEffect({
    super.key,
    required this.child,
    required this.builder,
  });

  @override
  State<HoverEffect> createState() => _HoverEffectState();
}

class _HoverEffectState extends State<HoverEffect> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: widget.builder(context, _hovering, widget.child),
    );
  }
}
