import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';
import 'package:mirage_by_aurues/app/theme/theme_provider.dart';

/// Shimmer skeleton for loading states.
class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerLoading({
    super.key,
    this.width = double.infinity,
    this.height = 100,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().currentTheme;

    return Shimmer.fromColors(
      baseColor: theme.surfaceVariant.withValues(alpha: 0.3),
      highlightColor: theme.surface,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: theme.surfaceVariant,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// A grid of shimmer cards for catalog loading state.
class ShimmerProductGrid extends StatelessWidget {
  final int itemCount;

  const ShimmerProductGrid({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      itemCount: itemCount,
      itemBuilder: (_, __) => const ShimmerLoading(height: 220),
    );
  }
}

/// A list of shimmer cards for category loading state.
class ShimmerCategoryList extends StatelessWidget {
  final int itemCount;

  const ShimmerCategoryList({super.key, this.itemCount = 4});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: ShimmerLoading(height: 200, borderRadius: 20),
      ),
    );
  }
}
