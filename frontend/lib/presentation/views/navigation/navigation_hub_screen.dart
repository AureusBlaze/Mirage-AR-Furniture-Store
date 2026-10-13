import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:mirage_by_aurues/app/theme/theme_provider.dart';
import 'package:mirage_by_aurues/app/theme/mirage_typography.dart';
import 'package:mirage_by_aurues/core/network/connection_status_service.dart';
import 'package:mirage_by_aurues/presentation/widgets/background_layer.dart';

/// Navigation Hub — central hub with circular navigation.
/// Performance: Removed all BackdropFilter from nav buttons and bottom
/// section. Uses solid opaque containers instead.
class NavigationHubScreen extends StatefulWidget {
  const NavigationHubScreen({super.key});

  @override
  State<NavigationHubScreen> createState() => _NavigationHubScreenState();
}

class _NavigationHubScreenState extends State<NavigationHubScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Trigger an immediate status check when the screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ConnectionStatusService>().checkNow();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  // Navigation items arranged in a circle
  static const _navItems = [
    _NavItem(Icons.home_outlined, 'Home', 0),
    _NavItem(Icons.search_outlined, 'Search', -1),
    _NavItem(Icons.grid_view_outlined, 'Catalog', 1),
    _NavItem(Icons.shopping_bag_outlined, 'Cart', -2),
    _NavItem(Icons.person_outline, 'Profile', 3),
    _NavItem(Icons.camera_alt_outlined, 'Camera', -3),
    _NavItem(Icons.view_in_ar_outlined, 'AR', 2),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().currentTheme;

    return Scaffold(
      body: BackgroundLayer(
        child: FadeTransition(
          opacity: _fadeController,
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildStatusBar(theme),
                const Spacer(),
                _buildCentralHUD(context, theme),
                const Spacer(),
                _buildBottomSection(context, theme),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBar(dynamic theme) {
    final status = context.watch<ConnectionStatusService>();
    final isOnline = status.isOnline;
    final isChecking = status.isChecking;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: theme.primaryDark.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.glassBorder, width: 0.5),
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
        ),
        child: Row(
          children: [
            // Brand name on the left
            Text(
              'MIRAGE',
              style: GoogleFonts.playfairDisplay(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 5,
                color: theme.textOnDark.withValues(alpha: 0.7),
              ),
            ),
            const Spacer(),
            // Status indicator on the right
            if (isChecking)
              SizedBox(
                width: 10,
                height: 10,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: theme.textOnDark.withValues(alpha: 0.5),
                ),
              )
            else
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isOnline ? theme.success : theme.error,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (isOnline ? theme.success : theme.error)
                          .withValues(alpha: 0.4),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            const SizedBox(width: 6),
            Text(
              isChecking
                  ? 'CHECKING'
                  : (isOnline ? 'ONLINE' : 'OFFLINE'),
              style: MirageTypography.labelSmall(
                color: isChecking
                    ? theme.textOnDark.withValues(alpha: 0.6)
                    : (isOnline
                        ? theme.success.withValues(alpha: 0.8)
                        : theme.error.withValues(alpha: 0.8)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCentralHUD(BuildContext context, dynamic theme) {
    const double circleSize = 280;
    const double buttonSize = 52;
    const double radius = circleSize / 2 - buttonSize / 2 + 6;

    return SizedBox(
      width: circleSize,
      height: circleSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer circle border
          Container(
            width: circleSize,
            height: circleSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: theme.glassBorder, width: 0.5),
            ),
          ),
          // Center pulsing knob
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (_, __) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: theme.accent,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: theme.accent.withValues(alpha: 0.4),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          // Nav items arranged in a circle
          ...List.generate(_navItems.length, (index) {
            final item = _navItems[index];
            final angle =
                -math.pi / 2 + (2 * math.pi * index / _navItems.length);
            final dx = radius * math.cos(angle);
            final dy = radius * math.sin(angle);

            return Transform.translate(
              offset: Offset(dx, dy),
              child: _buildNavButton(context, theme, item, buttonSize),
            );
          }),
        ],
      ),
    );
  }

  /// Nav button — solid opaque container, no BackdropFilter.
  Widget _buildNavButton(
    BuildContext context,
    dynamic theme,
    _NavItem item,
    double size,
  ) {
    return GestureDetector(
      onTap: () => _navigateToItem(context, item),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: theme.primaryDark.withValues(alpha: 0.88),
          shape: BoxShape.circle,
          border: Border.all(color: theme.glassBorder, width: 0.5),
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
        ),
        child: Icon(item.icon, color: theme.textOnDark, size: 22),
      ),
    );
  }

  void _navigateToItem(BuildContext context, _NavItem item) {
    switch (item.tabIndex) {
      case -1:
        Navigator.of(context).pushNamed('/search');
        break;
      case -2:
        Navigator.of(context).pushNamed('/cart');
        break;
      case -3:
        Navigator.of(context).pushNamed('/camera');
        break;
      default:
        Navigator.of(context).pushReplacementNamed(
          '/shell',
          arguments: item.tabIndex,
        );
    }
  }

  Widget _buildBottomSection(BuildContext context, dynamic theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacementNamed(
                  '/shell',
                  arguments: 0,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.accentWarm,
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(16),
                  ),
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
                ),
                child: Text(
                  'EXPLORE',
                  textAlign: TextAlign.center,
                  style: MirageTypography.labelSmall(
                    color: theme.textOnDark,
                  ).copyWith(letterSpacing: 3),
                ),
              ),
            ),
          ),
          const SizedBox(width: 2),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacementNamed(
                  '/shell',
                  arguments: 1,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.primaryDark.withValues(alpha: 0.9),
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(16),
                  ),
                  border: Border.all(
                    color: theme.glassBorder,
                    width: 0.5,
                  ),
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
                ),
                child: Text(
                  'DISCOVER',
                  textAlign: TextAlign.center,
                  style: MirageTypography.labelSmall(
                    color: theme.textOnDark.withValues(alpha: 0.7),
                  ).copyWith(letterSpacing: 3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final int tabIndex;
  const _NavItem(this.icon, this.label, this.tabIndex);
}
