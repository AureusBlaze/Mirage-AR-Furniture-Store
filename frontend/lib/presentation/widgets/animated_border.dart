import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mirage_by_aurues/app/theme/theme_provider.dart';

/// A widget that draws an animated gradient border around its child.
/// The border color follows the current theme's accent and glass colors,
/// creating a shimmer/sweep effect via a rotating gradient.
class AnimatedBorder extends StatefulWidget {
  final Widget child;
  final double borderRadius;
  final double borderWidth;
  final EdgeInsetsGeometry? padding;
  final Duration duration;

  const AnimatedBorder({
    super.key,
    required this.child,
    this.borderRadius = 20,
    this.borderWidth = 2,
    this.padding,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<AnimatedBorder> createState() => _AnimatedBorderState();
}

class _AnimatedBorderState extends State<AnimatedBorder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().currentTheme;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _AnimatedBorderPainter(
            progress: _controller.value,
            borderRadius: widget.borderRadius,
            borderWidth: widget.borderWidth,
            colors: [
              theme.accent.withValues(alpha: 0.8),
              theme.glassBorder.withValues(alpha: 0.2),
              theme.accentWarm.withValues(alpha: 0.6),
              theme.accent.withValues(alpha: 0.8),
            ],
          ),
          child: Padding(
            padding: widget.padding ??
                EdgeInsets.all(widget.borderWidth + 2),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

class _AnimatedBorderPainter extends CustomPainter {
  final double progress;
  final double borderRadius;
  final double borderWidth;
  final List<Color> colors;

  _AnimatedBorderPainter({
    required this.progress,
    required this.borderRadius,
    required this.borderWidth,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      borderWidth / 2,
      borderWidth / 2,
      size.width - borderWidth,
      size.height - borderWidth,
    );
    final rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(borderRadius),
    );

    // Rotating sweep gradient for the animated shimmer effect
    final sweepGradient = SweepGradient(
      startAngle: 0,
      endAngle: math.pi * 2,
      colors: colors,
      transform: GradientRotation(progress * math.pi * 2),
    );

    final paint = Paint()
      ..shader = sweepGradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(_AnimatedBorderPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
