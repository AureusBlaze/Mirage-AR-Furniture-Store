import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mirage_by_aurues/app/theme/theme_provider.dart';

/// A standardized bevel container that applies a subtle 3D relief effect.
/// Uses two box shadows — a light highlight (top-left) and a dark shadow
/// (bottom-right) — to simulate a physical bevel. Reads bevel tokens
/// from the current theme.
class BevelContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final double? width;
  final double? height;
  final bool isCircular;
  final double? customIntensity;

  const BevelContainer({
    super.key,
    required this.child,
    this.borderRadius = 16,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.width,
    this.height,
    this.isCircular = false,
    this.customIntensity,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().currentTheme;
    final intensity = customIntensity ?? theme.bevelIntensity;

    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding ?? const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.transparent,
        borderRadius: isCircular ? null : BorderRadius.circular(borderRadius),
        shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
        boxShadow: [
          // Light highlight — top-left
          BoxShadow(
            color: theme.bevelHighlight.withValues(alpha:
                (theme.bevelHighlight.a * intensity).clamp(0.0, 1.0)),
            offset: const Offset(-1, -1),
            blurRadius: 2,
            spreadRadius: 0,
          ),
          // Dark shadow — bottom-right
          BoxShadow(
            color: theme.bevelShadow.withValues(alpha:
                (theme.bevelShadow.a * intensity).clamp(0.0, 1.0)),
            offset: const Offset(1, 1),
            blurRadius: 2,
            spreadRadius: 0,
          ),
        ],
      ),
      child: child,
    );
  }
}
