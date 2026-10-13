import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mirage_by_aurues/app/theme/theme_provider.dart';

/// A glassmorphic container matching the Mirage design system.
/// Frosted glass panel with subtle border, blur, and optional bevel.
class GlassmorphicContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? opacity;
  final double? blur;
  final bool showBevel;

  const GlassmorphicContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.borderRadius = 20,
    this.padding,
    this.margin,
    this.opacity,
    this.blur,
    this.showBevel = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().currentTheme;
    final effectiveOpacity = opacity ?? theme.glassOpacity;
    final effectiveBlur = blur ?? theme.glassBlur;

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: showBevel
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: [
                BoxShadow(
                  color: theme.bevelHighlight,
                  offset: const Offset(-1, -1),
                  blurRadius: 2,
                ),
                BoxShadow(
                  color: theme.bevelShadow,
                  offset: const Offset(1, 1),
                  blurRadius: 2,
                ),
              ],
            )
          : null,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: effectiveBlur,
            sigmaY: effectiveBlur,
          ),
          child: Container(
            padding: padding ?? const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.glassColor.withValues(alpha: effectiveOpacity),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: theme.glassBorder,
                width: 0.5,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
