import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mirage_by_aurues/app/theme/theme_provider.dart';

/// Floating bottom navigation bar — separated solid containers with bevels.
/// Layout: [Home | Catalog | AR]  (gap)  [Profile]
///
/// Performance: Uses solid opaque containers instead of BackdropFilter
/// to avoid GPU-heavy blur compositing during scrolling.
class MirageBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const MirageBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  // Tab order: Home(0), Catalog(1), AR(2), --gap--, Profile(3)
  static const _leftItems = [
    _NavItem(Icons.home_outlined, Icons.home, 'Home', 0),
    _NavItem(Icons.grid_view_outlined, Icons.grid_view, 'Catalog', 1),
    _NavItem(Icons.view_in_ar_outlined, Icons.view_in_ar, 'AR', 2),
  ];

  static const _rightItem =
      _NavItem(Icons.person_outline, Icons.person, 'Profile', 3);

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().currentTheme;

    return RepaintBoundary(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 24, left: 20, right: 20),
          child: Row(
            children: [
              // Left group: Home, Catalog, AR
              ..._leftItems.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: _buildNavItem(theme, item),
                );
              }),
              // Spacer
              const Spacer(),
              // Right: Profile (separated)
              _buildNavItem(theme, _rightItem),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(dynamic theme, _NavItem item) {
    final isActive = item.index == currentIndex;
    final isDark = theme.brightness == Brightness.dark;
    final navColor = isDark ? theme.primaryDark : theme.surface;
    final iconColor = isDark ? theme.textOnDark : theme.textPrimary;
    final borderColor = isDark ? Colors.white.withValues(alpha: 0.08) : theme.surfaceVariant;

    return GestureDetector(
      onTap: () => onTap(item.index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          // Solid opaque background — no BackdropFilter needed
          color: isActive
              ? navColor
              : navColor.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive
                ? theme.accent.withValues(alpha: 0.5)
                : borderColor,
            width: isActive ? 1.0 : 0.5,
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
            if (isActive)
              BoxShadow(
                color: theme.accent.withValues(alpha: 0.2),
                blurRadius: 8,
                spreadRadius: 1,
              ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? item.activeIcon : item.icon,
              size: 22,
              color: isActive
                  ? theme.accent
                  : iconColor.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 2),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isActive ? 4 : 0,
              height: isActive ? 4 : 0,
              decoration: BoxDecoration(
                color: theme.accent,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int index;
  const _NavItem(this.icon, this.activeIcon, this.label, this.index);
}
