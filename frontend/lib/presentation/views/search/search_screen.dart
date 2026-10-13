import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mirage_by_aurues/app/theme/theme_provider.dart';
import 'package:mirage_by_aurues/app/theme/mirage_typography.dart';
import 'package:mirage_by_aurues/presentation/viewmodels/search_viewmodel.dart';
import 'package:mirage_by_aurues/presentation/widgets/product_card.dart';
import 'package:mirage_by_aurues/presentation/widgets/background_layer.dart';
import 'package:mirage_by_aurues/presentation/widgets/animated_border.dart';
import 'package:mirage_by_aurues/presentation/widgets/bevel_container.dart';
import 'package:mirage_by_aurues/presentation/widgets/aureus_navigation_guard.dart';

/// Full-screen search overlay with animated themed border.
/// Consistent bevel containers that match the design system.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().currentTheme;

    return AureusNavigationGuard(
      child: Scaffold(
      extendBodyBehindAppBar: true,
      body: BackgroundLayer(
        child: SafeArea(
          child: Column(
            children: [
              // Search header with consistent bevel containers
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Back button — same style as rest of app
                    BevelContainer(
                      isCircular: true,
                      backgroundColor:
                          (theme.brightness == Brightness.dark ? theme.primaryDark : theme.surface).withValues(alpha: 0.85),
                      padding: EdgeInsets.zero,
                      child: SizedBox(
                        width: 44,
                        height: 44,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back,
                              color: theme.brightness == Brightness.dark ? theme.textOnDark : theme.textPrimary, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Search input with animated border
                    Expanded(
                      child: AnimatedBorder(
                        borderRadius: 16,
                        borderWidth: 1.5,
                        child: BevelContainer(
                          borderRadius: 14,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          backgroundColor:
                              theme.primaryDark.withValues(alpha: 0.85),
                          child: Row(
                            children: [
                              Icon(Icons.search,
                                  color:
                                      theme.textOnDark.withValues(alpha: 0.5),
                                  size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  focusNode: _focusNode,
                                  style: TextStyle(
                                      color: theme.textOnDark, fontSize: 16),
                                  decoration: InputDecoration(
                                    hintText: 'Search furniture...',
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    hintStyle: TextStyle(
                                        color: theme.textOnDark
                                            .withValues(alpha: 0.4)),
                                    contentPadding: EdgeInsets.zero,
                                    filled: false,
                                    isDense: true,
                                  ),
                                  onChanged: (query) {
                                    context
                                        .read<SearchViewModel>()
                                        .search(query);
                                  },
                                ),
                              ),
                              // Clear button — listens to controller text changes only
                              ValueListenableBuilder<TextEditingValue>(
                                valueListenable: _searchController,
                                builder: (_, value, __) {
                                  if (value.text.isEmpty) return const SizedBox.shrink();
                                  return GestureDetector(
                                    onTap: () {
                                      _searchController.clear();
                                      context.read<SearchViewModel>().clear();
                                    },
                                    child: Icon(Icons.close,
                                        color: theme.textOnDark
                                            .withValues(alpha: 0.5),
                                        size: 18),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Results
              Expanded(
                child: Consumer<SearchViewModel>(
                  builder: (_, vm, __) {
                    if (vm.query.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.search,
                                size: 64,
                                color: theme.textOnDark
                                    .withValues(alpha: 0.15)),
                            const SizedBox(height: 16),
                            Text(
                              'Search for furniture',
                              style: MirageTypography.bodyMedium(
                                color: theme.textOnDark
                                    .withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (vm.isLoading) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: theme.accent,
                          strokeWidth: 2,
                        ),
                      );
                    }

                    if (vm.results.isEmpty) {
                      return Center(
                        child: Text(
                          'No results for "${vm.query}"',
                          style: MirageTypography.bodyMedium(
                            color:
                                theme.textOnDark.withValues(alpha: 0.5),
                          ),
                        ),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.6,
                      ),
                      itemCount: vm.results.length,
                      itemBuilder: (_, index) {
                        final product = vm.results[index];
                        return RepaintBoundary(
                          child: ProductCard(
                            product: product,
                            onTap: () => Navigator.of(context).pushNamed(
                              '/product',
                              arguments: product.id,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
