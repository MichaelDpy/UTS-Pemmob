import 'package:flutter/material.dart';

/// Animations utility untuk aplikasi Quizify.
/// Menyediakan reusable animations dan transitions.
class AppAnimations {
  // ─── Durations ─────────────────────────────────────────────────

  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 400);

  // ─── Curves ────────────────────────────────────────────────────

  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve bounce = Curves.elasticOut;
  static const Curve smooth = Curves.easeOutCubic;

  // ─── Page Transitions ──────────────────────────────────────────

  /// Slide transition dari kanan
  static Route slideFromRight(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: normal,
    );
  }

  /// Fade transition
  static Route fadeTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: fast,
    );
  }

  /// Scale transition
  static Route scaleTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          ),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      transitionDuration: normal,
    );
  }

  // ─── Widgets Animations ────────────────────────────────────────

  /// Fade in animation widget
  static Widget fadeIn({
    required Widget child,
    Duration duration = normal,
    Duration delay = Duration.zero,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      curve: defaultCurve,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: child,
    );
  }

  /// Slide in from bottom animation widget
  static Widget slideInFromBottom({
    required Widget child,
    Duration duration = normal,
    Duration delay = Duration.zero,
  }) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween(begin: const Offset(0, 0.3), end: Offset.zero),
      duration: duration,
      curve: smooth,
      builder: (context, value, child) {
        return Transform.translate(
          offset: value * 100,
          child: Opacity(
            opacity: 1 - (value.dy / 0.3),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  /// Scale in animation widget
  static Widget scaleIn({
    required Widget child,
    Duration duration = normal,
    Duration delay = Duration.zero,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.0),
      duration: duration,
      curve: bounce,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  /// Staggered animation untuk list
  static Widget staggeredListItem({
    required Widget child,
    required int index,
    Duration delay = const Duration(milliseconds: 50),
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: normal,
      curve: smooth,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  // ─── Shimmer Effect ────────────────────────────────────────────

  /// Shimmer loading effect
  static Widget shimmer({
    required Widget child,
    bool enabled = true,
    Duration duration = const Duration(milliseconds: 1500),
  }) {
    if (!enabled) return child;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: -1.0, end: 2.0),
      duration: duration,
      builder: (context, value, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [
                (value - 0.3).clamp(0.0, 1.0),
                value.clamp(0.0, 1.0),
                (value + 0.3).clamp(0.0, 1.0),
              ],
              colors: [
                Colors.grey.shade300,
                Colors.grey.shade100,
                Colors.grey.shade300,
              ],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: child,
    );
  }

  // ─── Button Press Animation ────────────────────────────────────

  /// Animasi scale saat button ditekan
  static Widget pressAnimation({
    required Widget child,
    required VoidCallback onPressed,
    double scale = 0.95,
  }) {
    return _PressAnimationWidget(
      onPressed: onPressed,
      scale: scale,
      child: child,
    );
  }
}

/// Widget untuk press animation
class _PressAnimationWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final double scale;

  const _PressAnimationWidget({
    required this.child,
    required this.onPressed,
    this.scale = 0.95,
  });

  @override
  State<_PressAnimationWidget> createState() => _PressAnimationWidgetState();
}

class _PressAnimationWidgetState extends State<_PressAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}
