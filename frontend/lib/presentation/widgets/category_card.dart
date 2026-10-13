import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:mirage_by_aurues/app/theme/theme_provider.dart';

/// Home screen category card with alternating layout and glassmorphism.
/// Even index: image left, text right.
/// Odd index: text left, image right.
/// Text half uses BackdropFilter blur for glass effect.
///
/// Performance: The entire card is wrapped in RepaintBoundary at the
/// parent level (HomeScreen). The BackdropFilter is limited to the
/// text section only (not the entire card).
class CategoryCard extends StatelessWidget {
  final dynamic category;
  final int index;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.index,
    this.onTap,
  });

  bool get _isReversed => index.isOdd;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().currentTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Full image background
              _buildFullImage(theme),
              // Glass text overlay on one half
              Row(
                children: _isReversed
                    ? [_buildGlassTextSection(theme), const Spacer()]
                    : [const Spacer(), _buildGlassTextSection(theme)],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFullImage(dynamic theme) {
    if (category.imageUrl != null && category.imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: category.imageUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        filterQuality: FilterQuality.high,
        placeholder: (_, __) =>
            Container(color: theme.surfaceVariant.withValues(alpha: 0.2)),
        errorWidget: (_, __, ___) => _buildImagePlaceholder(theme),
      );
    }
    return _buildImagePlaceholder(theme);
  }

  Widget _buildImagePlaceholder(dynamic theme) {
    return Container(
      color: theme.surfaceVariant.withValues(alpha: 0.15),
      child: Center(
        child: Icon(
          Icons.weekend_outlined,
          size: 48,
          color: theme.textSecondary.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  Widget _buildGlassTextSection(dynamic theme) {
    return SizedBox(
      width: 160,
      child: Container(
        padding: const EdgeInsets.all(16),
        color: theme.primaryDark.withValues(alpha: 0.7),
        child: Column(
          crossAxisAlignment: _isReversed
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              category.name.toUpperCase(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: theme.textOnDark,
                letterSpacing: 2,
                fontFamily: 'PlayfairDisplay',
              ),
              textAlign: _isReversed ? TextAlign.left : TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            if (category.description != null)
              Text(
                category.description!,
                style: TextStyle(
                  fontSize: 11,
                  color: theme.textOnDark.withValues(alpha: 0.6),
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: _isReversed ? TextAlign.left : TextAlign.right,
              ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: _isReversed
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'EXPLORE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: theme.accent,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.arrow_forward, size: 12, color: theme.accent),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
