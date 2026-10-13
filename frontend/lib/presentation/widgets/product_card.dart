import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';
import 'package:mirage_by_aurues/app/theme/theme_provider.dart';
import 'package:mirage_by_aurues/domain/entities/product.dart';

/// Product card for the catalog grid.
/// Shows image with glassmorphic text overlay, optional AR badge, and bevel.
///
/// Performance: BackdropFilter is constrained to only the bottom text
/// section (not the full card). Parent wraps in RepaintBoundary.
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().currentTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Full image background
              _buildImage(theme),
              // AR Badge
              if (product.hasArModel) _buildArBadge(theme),
              // Glassmorphic info section at bottom
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(16),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.primaryDark.withValues(alpha: 0.55),
                        border: Border(
                          top: BorderSide(
                            color: theme.glassBorder,
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            product.name,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: theme.textOnDark,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          if (product.categoryName != null)
                            Text(
                              product.categoryName!,
                              style: TextStyle(
                                fontSize: 10,
                                color:
                                    theme.textOnDark.withValues(alpha: 0.5),
                                letterSpacing: 0.5,
                              ),
                              maxLines: 1,
                            ),
                          const SizedBox(height: 4),
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: theme.accent,
                              fontFamily: 'SpaceGrotesk',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(dynamic theme) {
    if (product.imageUrl != null && product.imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: product.imageUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        filterQuality: FilterQuality.high,
        placeholder: (_, __) => _buildShimmer(theme),
        errorWidget: (_, __, ___) => _buildPlaceholder(theme),
      );
    }
    return _buildPlaceholder(theme);
  }

  Widget _buildShimmer(dynamic theme) {
    return Shimmer.fromColors(
      baseColor: theme.surfaceVariant.withValues(alpha: 0.3),
      highlightColor: theme.surface,
      child: Container(color: theme.surfaceVariant),
    );
  }

  Widget _buildPlaceholder(dynamic theme) {
    return Container(
      color: theme.surfaceVariant.withValues(alpha: 0.2),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 40,
          color: theme.textSecondary.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  Widget _buildArBadge(dynamic theme) {
    final isDark = theme.brightness == Brightness.dark;
    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isDark
              ? theme.primaryDark.withValues(alpha: 0.85)
              : Colors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 4,
            ),
          ],
        ),
        child: Icon(
          Icons.view_in_ar,
          size: 16,
          color: theme.accent,
        ),
      ),
    );
  }
}
