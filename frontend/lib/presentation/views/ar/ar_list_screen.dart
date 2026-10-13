import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mirage_by_aurues/app/theme/theme_provider.dart';
import 'package:mirage_by_aurues/app/theme/mirage_typography.dart';
import 'package:mirage_by_aurues/presentation/viewmodels/ar_list_viewmodel.dart';
import 'package:mirage_by_aurues/presentation/widgets/product_card.dart';
import 'package:mirage_by_aurues/presentation/widgets/shimmer_loading.dart';
import 'package:mirage_by_aurues/presentation/widgets/background_layer.dart';
import 'package:mirage_by_aurues/presentation/widgets/aureus_refresh_wrapper.dart';

/// AR List screen — products with AR support, dynamically populated
/// from the database (only items flagged as AR-enabled).
class ArListScreen extends StatefulWidget {
  const ArListScreen({super.key});

  @override
  State<ArListScreen> createState() => _ArListScreenState();
}

class _ArListScreenState extends State<ArListScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ArListViewModel>().loadArProducts();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().currentTheme;

    return BackgroundLayer(
      child: Consumer<ArListViewModel>(
        builder: (_, vm, __) {
          if (vm.isLoading) {
            return const ShimmerProductGrid();
          }

          if (vm.error != null && vm.products.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.view_in_ar,
                    size: 48,
                    color: theme.textOnDark.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Unable to load AR products',
                    style: MirageTypography.headingMedium(
                      color: theme.textOnDark,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: vm.loadArProducts,
                    child: const Text('RETRY'),
                  ),
                ],
              ),
            );
          }

          if (vm.products.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.view_in_ar_outlined,
                    size: 64,
                    color: theme.textOnDark.withValues(alpha: 0.2),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No AR products available',
                    style: MirageTypography.headingMedium(
                      color: theme.textOnDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'AR-enabled products will appear here',
                    style: MirageTypography.bodyMedium(
                      color: theme.textOnDark.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            );
          }

          return AureusRefreshWrapper(
            onRefresh: vm.refresh,
            controller: _scrollController,
            slivers: [
              SliverPadding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                  left: 16,
                  right: 16,
                  bottom: 100,
                ),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate((_, index) {
                    final product = vm.products[index];
                    return ProductCard(
                      product: product,
                      onTap: () => Navigator.of(
                        context,
                      ).pushNamed('/product', arguments: product.id),
                    );
                  }, childCount: vm.products.length),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.6,
                      ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
