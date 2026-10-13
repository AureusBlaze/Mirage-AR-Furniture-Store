import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mirage_by_aurues/app/theme/theme_provider.dart';
import 'package:mirage_by_aurues/app/theme/mirage_typography.dart';
import 'package:mirage_by_aurues/presentation/viewmodels/home_viewmodel.dart';
import 'package:mirage_by_aurues/presentation/viewmodels/catalog_viewmodel.dart';
import 'package:mirage_by_aurues/presentation/widgets/category_card.dart';
import 'package:mirage_by_aurues/presentation/widgets/shimmer_loading.dart';
import 'package:mirage_by_aurues/presentation/widgets/background_layer.dart';
import 'package:mirage_by_aurues/presentation/widgets/aureus_refresh_wrapper.dart';

/// Home screen — vertical list of alternating category cards on background.
/// Each category card is wrapped in RepaintBoundary for scroll perf.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().loadCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().currentTheme;

    return BackgroundLayer(
      child: Consumer<HomeViewModel>(
        builder: (_, vm, __) {
          if (vm.isLoading) {
            return const ShimmerCategoryList();
          }

          if (vm.error != null) {
            return _buildError(vm, theme);
          }

          return AureusRefreshWrapper(
            onRefresh: vm.loadCategories,
            slivers: [
              SliverPadding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                  left: 16,
                  right: 16,
                  bottom: 100,
                ),
                sliver: SliverList.builder(
                  // +1 for header
                  itemCount: vm.categories.length + 1,
                  itemBuilder: (_, index) {
                    // Header
                if (index == 0) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'COLLECTIONS',
                        style: MirageTypography.displaySmall(
                          color: theme.textOnDark,
                        ).copyWith(letterSpacing: 6),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Curated categories for your space',
                        style: MirageTypography.bodyMedium(
                          color: theme.textOnDark.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  );
                }

                final catIndex = index - 1;
                // RepaintBoundary isolates each card's BackdropFilter
                return RepaintBoundary(
                  child: CategoryCard(
                    category: vm.categories[catIndex],
                    index: catIndex,
                    onTap: () {
                      final cat = vm.categories[catIndex];
                      context.read<CatalogViewModel>().setCategory(
                        cat.id,
                        cat.name,
                      );
                      Navigator.of(
                        context,
                      ).pushReplacementNamed('/shell', arguments: 1);
                    },
                  ),
                );
              },
            ),
          ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildError(HomeViewModel vm, dynamic theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off,
              size: 48,
              color: theme.textOnDark.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Unable to load categories',
              style: MirageTypography.headingMedium(color: theme.textOnDark),
            ),
            const SizedBox(height: 8),
            Text(
              vm.error!,
              style: MirageTypography.bodySmall(
                color: theme.textOnDark.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: vm.loadCategories,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.accentWarm,
                foregroundColor: theme.textOnDark,
              ),
              child: const Text('RETRY'),
            ),
          ],
        ),
      ),
    );
  }
}
