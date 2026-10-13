// Performance: Removed dart:ui (BackdropFilter) — solid containers used instead.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mirage_by_aurues/app/theme/theme_provider.dart';
import 'package:mirage_by_aurues/app/theme/mirage_typography.dart';
import 'package:mirage_by_aurues/domain/entities/cart_item.dart';
import 'package:mirage_by_aurues/presentation/viewmodels/cart_viewmodel.dart';
import 'package:mirage_by_aurues/presentation/widgets/background_layer.dart';
import 'package:mirage_by_aurues/presentation/widgets/bevel_container.dart';
import 'package:mirage_by_aurues/presentation/widgets/aureus_navigation_guard.dart';
import 'package:mirage_by_aurues/presentation/widgets/aureus_refresh_wrapper.dart';

/// Cart screen — full Mirage aesthetic: glass background, beveled containers,
/// solid color buttons, consistent typography.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().currentTheme;

    return AureusNavigationGuard(
      child: Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: BevelContainer(
            isCircular: true,
            backgroundColor: (theme.brightness == Brightness.dark ? theme.primaryDark : theme.surface).withValues(alpha: 0.85),
            padding: EdgeInsets.zero,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: theme.brightness == Brightness.dark ? theme.textOnDark : theme.textPrimary, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: Text(
          'YOUR CART',
          style: MirageTypography.labelLarge(
            color: theme.textOnDark,
          ).copyWith(letterSpacing: 4),
        ),
        centerTitle: true,
      ),
      body: BackgroundLayer(
        child: Consumer<CartViewModel>(
          builder: (_, vm, __) {
            if (vm.items.isEmpty) {
              return _buildEmptyCart(context, theme);
            }

            return Column(
              children: [
                Expanded(
                  child: AureusRefreshWrapper(
                    onRefresh: () async => context.read<CartViewModel>().loadCart(),
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top + kToolbarHeight + 16,
                          left: 20,
                          right: 20,
                          bottom: 16,
                        ),
                        sliver: SliverList.builder(
                          itemCount: vm.items.length,
                          itemBuilder: (_, index) {
                            return RepaintBoundary(
                              child: _buildCartItem(
                                context,
                                vm,
                                vm.items[index],
                                theme,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                _buildBottomTotal(context, vm, theme),
              ],
            );
          },
        ),
      ),
    ));
  }

  Widget _buildEmptyCart(BuildContext context, dynamic theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 64,
            color: theme.textOnDark.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: MirageTypography.headingMedium(color: theme.textOnDark),
          ),
          const SizedBox(height: 8),
          Text(
            'Add items to get started',
            style: MirageTypography.bodyMedium(
              color: theme.textOnDark.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.of(
              context,
            ).pushReplacementNamed('/shell', arguments: 1),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.accentWarm,
              foregroundColor: theme.textOnDark,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('BROWSE CATALOG'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(
    BuildContext context,
    CartViewModel vm,
    CartItem item,
    dynamic theme,
  ) {
    return Dismissible(
      key: Key('cart_${item.productId}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: theme.error.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.delete_outline, color: theme.error),
      ),
      onDismissed: (_) => vm.removeItem(item.productId),
      child: BevelContainer(
        borderRadius: 16,
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.only(bottom: 12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            // Solid opaque container — replaces BackdropFilter for performance.
            // Visually identical on dark backgrounds, zero GPU compositing cost.
            color: theme.primaryDark.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.glassBorder, width: 0.5),
          ),
          child: Row(
            children: [
              // Image
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: theme.surfaceVariant.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: item.imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(item.imageUrl!, fit: BoxFit.cover),
                      )
                    : Icon(
                        Icons.image_outlined,
                        color: theme.textOnDark.withValues(alpha: 0.3),
                      ),
              ),
              const SizedBox(width: 12),
              // Info
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: theme.textOnDark,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: theme.accent,
                      ),
                    ),
                  ],
                ),
              ),
              // Quantity controls
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _quantityButton(
                    icon: Icons.add,
                    theme: theme,
                    onTap: () =>
                        vm.updateQuantity(item.productId, item.quantity + 1),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      '${item.quantity}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: theme.textOnDark,
                      ),
                    ),
                  ),
                  _quantityButton(
                    icon: Icons.remove,
                    theme: theme,
                    onTap: () {
                      if (item.quantity > 1) {
                        vm.updateQuantity(item.productId, item.quantity - 1);
                      } else {
                        vm.removeItem(item.productId);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quantityButton({
    required IconData icon,
    required dynamic theme,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: theme.accentWarm.withValues(alpha: 0.2),
          border: Border.all(
            color: theme.accentWarm.withValues(alpha: 0.5),
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: theme.bevelHighlight,
              offset: const Offset(-0.5, -0.5),
              blurRadius: 1,
            ),
            BoxShadow(
              color: theme.bevelShadow,
              offset: const Offset(0.5, 0.5),
              blurRadius: 1,
            ),
          ],
        ),
        child: Icon(icon, size: 14, color: theme.textOnDark),
      ),
    );
  }

  Widget _buildBottomTotal(
    BuildContext context,
    CartViewModel vm,
    dynamic theme,
  ) {
    // Solid opaque container — replaces BackdropFilter for performance.
    return Container(
      decoration: BoxDecoration(
        color: theme.primaryDark.withValues(alpha: 0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(top: BorderSide(color: theme.glassBorder, width: 0.5)),
        boxShadow: [
          BoxShadow(
            color: theme.bevelHighlight,
            offset: const Offset(0, -1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: MirageTypography.headingMedium(
                      color: theme.textOnDark,
                    ),
                  ),
                  Text(
                    '\$${vm.totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: theme.accent,
                      fontFamily: 'SpaceGrotesk',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/checkout');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.accentWarm,
                    foregroundColor: theme.textOnDark,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('PROCEED TO CHECKOUT'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
