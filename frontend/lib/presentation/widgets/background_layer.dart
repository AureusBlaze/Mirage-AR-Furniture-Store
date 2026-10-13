import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mirage_by_aurues/app/theme/theme_provider.dart';

/// Full-screen background image layer with gradient overlay.
/// Uses the current theme's background asset at the active index.
/// Wraps the background in RepaintBoundary so the static image doesn't
/// get re-composited when the scrollable content above it changes.
class BackgroundLayer extends StatelessWidget {
  final Widget child;
  final bool showGradient;

  const BackgroundLayer({
    super.key,
    required this.child,
    this.showGradient = true,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final theme = themeProvider.currentTheme;
    final bgAsset = themeProvider.currentBackgroundAsset;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image — isolated from content repaints
        RepaintBoundary(
          child: Image.asset(
            bgAsset,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            // Cache decoded image in memory
            cacheWidth: (MediaQuery.sizeOf(context).width *
                    MediaQuery.devicePixelRatioOf(context))
                .toInt(),
          ),
        ),
        // Gradient overlay
        if (showGradient)
          RepaintBoundary(
            child: Container(
              decoration: BoxDecoration(
                gradient: theme.overlayGradient,
              ),
            ),
          ),
        // Content
        child,
      ],
    );
  }
}
