import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:mirage_by_aurues/app/theme/theme_provider.dart';
import 'package:mirage_by_aurues/presentation/viewmodels/cart_viewmodel.dart';
import 'package:mirage_by_aurues/presentation/widgets/bevel_container.dart';

/// Mirage top bar — circular nav button + cart on left, "MIRAGE" center,
/// search + camera on right.
///
/// Performance: Removed BackdropFilter from cart and right containers;
/// uses solid opaque containers instead.
class MirageTopBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onNavHubTap;
  final VoidCallback? onCartTap;
  final VoidCallback? onSearchTap;
  final VoidCallback? onCameraTap;

  const MirageTopBar({
    super.key,
    this.onNavHubTap,
    this.onCartTap,
    this.onSearchTap,
    this.onCameraTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().currentTheme;
    final isDark = theme.brightness == Brightness.dark;

    return RepaintBoundary(
      child: SafeArea(
        child: Container(
          height: 60,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              // Left: Circular Nav Button + Cart
              _buildLeftSection(context, theme, isDark),
              const Spacer(),
              // Center: "MIRAGE" brand name
              Text(
                'MIRAGE',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 6,
                  color: isDark
                      ? theme.textOnDark.withValues(alpha: 0.7)
                      : theme.textPrimary.withValues(alpha: 0.7),
                ),
              ),
              const Spacer(),
              // Right: Search + Camera
              _buildRightSection(theme, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeftSection(BuildContext context, dynamic theme, bool isDark) {
    final iconColor = isDark ? theme.textOnDark : theme.textPrimary;
    return Row(
      children: [
        // Circular nav hub button
        BevelContainer(
          isCircular: true,
          backgroundColor: isDark
              ? theme.primaryDark.withValues(alpha: 0.85)
              : theme.surface.withValues(alpha: 0.9),
          padding: EdgeInsets.zero,
          child: SizedBox(
            width: 44,
            height: 44,
            child: IconButton(
              icon: Icon(Icons.blur_circular_outlined,
                  color: theme.accent, size: 20),
              onPressed: onNavHubTap ??
                  () => Navigator.of(context)
                      .pushReplacementNamed('/navigation'),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Cart button — solid container, no BackdropFilter
        Container(
          decoration: BoxDecoration(
            color: isDark
                ? theme.primaryDark.withValues(alpha: 0.92)
                : theme.surface.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(16),
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
          child: _buildCartButton(context, theme, iconColor),
        ),
      ],
    );
  }

  Widget _buildRightSection(dynamic theme, bool isDark) {
    final iconColor = isDark ? theme.textOnDark : theme.textPrimary;
    // Solid container — no BackdropFilter
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? theme.primaryDark.withValues(alpha: 0.92)
            : theme.surface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(16),
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
          IconButton(
            icon: Icon(Icons.search,
                color: iconColor, size: 20),
            onPressed: onSearchTap,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt_outlined,
                color: iconColor, size: 20),
            onPressed: onCameraTap,
          ),
        ],
      ),
    );
  }

  Widget _buildCartButton(BuildContext context, dynamic theme, Color iconColor) {
    return Selector<CartViewModel, int>(
      selector: (_, vm) => vm.itemCount,
      builder: (_, count, __) {
        return Stack(
          children: [
            IconButton(
              icon: Icon(Icons.shopping_bag_outlined,
                  color: iconColor, size: 20),
              onPressed: onCartTap,
            ),
            if (count > 0)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: theme.accent,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$count',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: theme.primaryDark,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

