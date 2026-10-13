import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mirage_by_aurues/app/theme/theme_provider.dart';
import 'package:mirage_by_aurues/app/theme/mirage_typography.dart';

/// Splash screen — full-screen background with animated MIRAGE text.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _trackingAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _trackingAnim = Tween<double>(begin: 20.0, end: 12.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/navigation');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final theme = themeProvider.currentTheme;
    final bgAsset = themeProvider.currentBackgroundAsset;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background
          Image.asset(
            bgAsset,
            fit: BoxFit.cover,
          ),
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.primaryDark.withValues(alpha: 0.3),
                  theme.primaryDark.withValues(alpha: 0.8),
                ],
              ),
            ),
          ),
          // Animated brand text
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, __) {
                return Opacity(
                  opacity: _fadeAnim.value,
                  child: Text(
                    'MIRAGE',
                    style: MirageTypography.displayLarge(
                      color: theme.textOnDark,
                    ).copyWith(
                      letterSpacing: _trackingAnim.value,
                    ),
                  ),
                );
              },
            ),
          ),
          // Subtitle
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnim,
              child: Text(
                'BY AURUES',
                textAlign: TextAlign.center,
                style: MirageTypography.labelSmall(
                  color: theme.textOnDark.withValues(alpha: 0.6),
                ).copyWith(letterSpacing: 4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
