import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mirage_by_aurues/app/theme/theme_provider.dart';
import 'package:mirage_by_aurues/app/theme/mirage_typography.dart';
import 'package:mirage_by_aurues/presentation/viewmodels/catalog_viewmodel.dart';
import 'package:mirage_by_aurues/presentation/widgets/product_card.dart';
import 'package:mirage_by_aurues/presentation/widgets/shimmer_loading.dart';
import 'package:mirage_by_aurues/presentation/widgets/background_layer.dart';
import 'package:mirage_by_aurues/presentation/widgets/aureus_refresh_wrapper.dart';

/// Catalog screen — 2-column product grid with pagination on background.
/// Each product card is wrapped in RepaintBoundary for scroll perf.
class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<CatalogViewModel>();
      vm.loadCategories();
      vm.loadProducts();
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<CatalogViewModel>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ─── Filter Bottom Sheet ──────────────────────────────────────────
  void _showFilterSheet(BuildContext context) {
    final theme = context.read<ThemeProvider>().currentTheme;
    final vm = context.read<CatalogViewModel>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return _FilterSheet(
          theme: theme,
          categories: vm.categories,
          selectedCategoryId: vm.selectedCategoryId,
          isCategoriesLoading: vm.isCategoriesLoading,
          onCategorySelected: (id, name) {
            Navigator.of(context).pop();
            vm.setCategory(id, name);
          },
          onClearFilter: () {
            Navigator.of(context).pop();
            vm.clearFilter();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().currentTheme;

    return BackgroundLayer(
      child: Consumer<CatalogViewModel>(
        builder: (_, vm, __) {
          if (vm.isLoading) {
            return const ShimmerProductGrid();
          }

          if (vm.error != null && vm.products.isEmpty) {
            return _buildError(vm, theme);
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
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                vm.hasActiveFilter
                                    ? (vm.selectedCategoryName?.toUpperCase() ?? 'FILTERED')
                                    : 'FULL CATALOG',
                                style: MirageTypography.displaySmall(
                                  color: theme.textOnDark,
                                ).copyWith(letterSpacing: 4),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            _buildFilterButton(theme, vm),
                          ],
                        ),
                        // Active filter clear chip
                        if (vm.hasActiveFilter) ...[
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: vm.clearFilter,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: theme.accentWarm.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: theme.accentWarm.withValues(alpha: 0.4),
                                  width: 0.5,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    vm.selectedCategoryName?.toUpperCase() ?? 'FILTER',
                                    style: MirageTypography.labelSmall(
                                      color: theme.textOnDark,
                                    ).copyWith(letterSpacing: 1.5),
                                  ),
                                  const SizedBox(width: 6),
                                  Icon(
                                    Icons.close,
                                    size: 14,
                                    color: theme.textOnDark.withValues(alpha: 0.7),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate((_, index) {
                      final product = vm.products[index];
                      // RepaintBoundary isolates each card's blur
                      return RepaintBoundary(
                        child: ProductCard(
                          product: product,
                          onTap: () {
                            Navigator.of(
                              context,
                            ).pushNamed('/product', arguments: product.id);
                          },
                        ),
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
                if (vm.isLoadingMore)
                  SliverPadding(
                    padding: const EdgeInsets.all(24),
                    sliver: SliverToBoxAdapter(
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: theme.accent,
                        ),
                      ),
                    ),
                  ),
                const SliverPadding(
                  padding: EdgeInsets.only(bottom: 100),
                  sliver: SliverToBoxAdapter(child: SizedBox.shrink()),
                ),
              ],
          );
        },
      ),
    );
  }

  // ─── Filter Button with active indicator ──────────────────────────
  Widget _buildFilterButton(dynamic theme, CatalogViewModel vm) {
    return Stack(
      children: [
        TextButton.icon(
          onPressed: () => _showFilterSheet(context),
          icon: Icon(
            Icons.tune,
            size: 18,
            color: vm.hasActiveFilter
                ? theme.accent
                : theme.textOnDark.withValues(alpha: 0.6),
          ),
          label: Text(
            'FILTERS',
            style: MirageTypography.labelSmall(
              color: vm.hasActiveFilter
                  ? theme.accent
                  : theme.textOnDark.withValues(alpha: 0.6),
            ),
          ),
        ),
        // Active filter dot
        if (vm.hasActiveFilter)
          Positioned(
            right: 4,
            top: 4,
            child: Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: theme.accent,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: theme.accent.withValues(alpha: 0.5),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildError(CatalogViewModel vm, dynamic theme) {
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
              'Unable to load products',
              style: MirageTypography.headingMedium(color: theme.textOnDark),
            ),
            const SizedBox(height: 8),
            Text(
              vm.error!,
              style: MirageTypography.bodySmall(
                color: theme.textOnDark.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: vm.refresh,
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

// ─── Filter Bottom Sheet (stateless, receives data) ─────────────────
class _FilterSheet extends StatelessWidget {
  final dynamic theme;
  final List categories;
  final int? selectedCategoryId;
  final bool isCategoriesLoading;
  final void Function(int id, String name) onCategorySelected;
  final VoidCallback onClearFilter;

  const _FilterSheet({
    required this.theme,
    required this.categories,
    required this.selectedCategoryId,
    required this.isCategoriesLoading,
    required this.onCategorySelected,
    required this.onClearFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.55,
      ),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Padding(
            padding: const EdgeInsets.only(top: 14, bottom: 8),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.surfaceVariant.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            child: Row(
              children: [
                Text(
                  'FILTER BY CATEGORY',
                  style: MirageTypography.headingSmall(
                    color: theme.textPrimary,
                  ).copyWith(letterSpacing: 3),
                ),
                const Spacer(),
                if (selectedCategoryId != null)
                  GestureDetector(
                    onTap: onClearFilter,
                    child: Text(
                      'CLEAR',
                      style: MirageTypography.labelSmall(
                        color: theme.accent,
                      ).copyWith(letterSpacing: 1.5),
                    ),
                  ),
              ],
            ),
          ),
          // Divider
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 28),
            height: 0.5,
            color: theme.surfaceVariant.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 20),
          // Category grid
          if (isCategoriesLoading)
            Padding(
              padding: const EdgeInsets.all(32),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: theme.accent,
              ),
            )
          else
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: categories.map((cat) {
                    final isSelected = cat.id == selectedCategoryId;
                    return _buildCategoryChip(context, cat, isSelected);
                  }).toList(),
                ),
              ),
            ),
          const SizedBox(height: 28),
          // Bottom safe area
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(BuildContext context, dynamic category, bool isSelected) {
    final hasChildren = category.children != null && category.children.isNotEmpty;

    return GestureDetector(
      onTap: () => onCategorySelected(category.id, category.name),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.only(left: 20, right: 12, top: 12, bottom: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.accentWarm
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? theme.accentWarm
                : theme.surfaceVariant.withValues(alpha: 0.5),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              category.name.toUpperCase(),
              style: MirageTypography.labelSmall(
                color: isSelected
                    ? theme.textOnDark
                    : theme.textSecondary,
              ).copyWith(
                letterSpacing: 2,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            if (hasChildren) ...[
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () => _showSubCategorySheet(context, category),
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.textOnDark.withValues(alpha: 0.2)
                        : theme.accent.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add,
                    size: 14,
                    color: isSelected ? theme.textOnDark : theme.accent,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showSubCategorySheet(BuildContext context, dynamic parentCategory) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.45,
          ),
          decoration: BoxDecoration(
            color: theme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Padding(
                padding: const EdgeInsets.only(top: 14, bottom: 8),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.surfaceVariant.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back, size: 20, color: theme.textSecondary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        parentCategory.name.toUpperCase(),
                        style: MirageTypography.headingSmall(
                          color: theme.textPrimary,
                        ).copyWith(letterSpacing: 3),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              // Divider
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 28),
                height: 0.5,
                color: theme.surfaceVariant.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 20),
              // Sub-category list
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: (parentCategory.children as List).map<Widget>((sub) {
                      final isSelected = sub.id == selectedCategoryId;
                      return GestureDetector(
                        onTap: () {
                          // Close sub-category sheet
                          Navigator.pop(context);
                          // Trigger selection (parent sheet closes via onCategorySelected)
                          onCategorySelected(sub.id, sub.name);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? theme.accentWarm
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? theme.accentWarm
                                  : theme.surfaceVariant.withValues(alpha: 0.5),
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: Text(
                            sub.name.toUpperCase(),
                            style: MirageTypography.labelSmall(
                              color: isSelected
                                  ? theme.textOnDark
                                  : theme.textSecondary,
                            ).copyWith(
                              letterSpacing: 2,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        );
      },
    );
  }
}

