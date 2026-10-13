import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mirage_by_aurues/app/theme/theme_provider.dart';
import 'package:mirage_by_aurues/app/theme/mirage_typography.dart';
import 'package:mirage_by_aurues/presentation/viewmodels/order_history_viewmodel.dart';
import 'package:mirage_by_aurues/presentation/widgets/background_layer.dart';
import 'package:mirage_by_aurues/presentation/widgets/bevel_container.dart';
import 'package:mirage_by_aurues/presentation/widgets/aureus_refresh_wrapper.dart';
import 'package:intl/intl.dart';

/// Order History screen — premium list of past orders.
class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderHistoryViewModel>().loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().currentTheme;

    return Scaffold(
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
              icon: Icon(Icons.arrow_back,
                  color: theme.brightness == Brightness.dark
                      ? theme.textOnDark
                      : theme.textPrimary,
                  size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: Text(
          'ORDER HISTORY',
          style: MirageTypography.labelLarge(
            color: theme.textOnDark,
          ).copyWith(letterSpacing: 4),
        ),
        centerTitle: true,
      ),
      body: BackgroundLayer(
        child: Consumer<OrderHistoryViewModel>(
          builder: (_, vm, __) {
            if (vm.isLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: theme.accent,
                  strokeWidth: 2,
                ),
              );
            }

            if (vm.error != null && vm.orders.isEmpty) {
              return _buildError(vm, theme);
            }

            if (vm.orders.isEmpty) {
              return _buildEmpty(theme);
            }

            return AureusRefreshWrapper(
              onRefresh: vm.refresh,
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 80,
                    left: 20,
                    right: 20,
                    bottom: 40,
                  ),
                  sliver: SliverList.builder(
                    itemCount: vm.orders.length,
                    itemBuilder: (_, index) {
                      final order = vm.orders[index];
                      return _buildOrderCard(order, theme);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrderCard(dynamic order, dynamic theme) {
    final dateStr = order.createdAt != null
        ? DateFormat('MMM dd, yyyy').format(order.createdAt!)
        : 'N/A';

    Color statusColor;
    switch (order.status.toLowerCase()) {
      case 'completed':
      case 'delivered':
        statusColor = theme.success;
        break;
      case 'pending':
      case 'processing':
        statusColor = theme.accent;
        break;
      case 'cancelled':
        statusColor = theme.error;
        break;
      default:
        statusColor = theme.textSecondary;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: BevelContainer(
        borderRadius: 16,
        padding: EdgeInsets.zero,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.primaryDark.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ORDER #${order.id}',
                    style: MirageTypography.labelLarge(
                      color: theme.textOnDark,
                    ).copyWith(letterSpacing: 2),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: statusColor.withValues(alpha: 0.3),
                        width: 0.5,
                      ),
                    ),
                    child: Text(
                      order.status.toUpperCase(),
                      style: MirageTypography.labelSmall(
                        color: statusColor,
                      ).copyWith(letterSpacing: 1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Date
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined, size: 14,
                      color: theme.textOnDark.withValues(alpha: 0.5)),
                  const SizedBox(width: 6),
                  Text(
                    dateStr,
                    style: MirageTypography.bodySmall(
                      color: theme.textOnDark.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Items count
              if (order.items.isNotEmpty)
                Text(
                  '${order.items.length} item${order.items.length > 1 ? 's' : ''}',
                  style: MirageTypography.bodySmall(
                    color: theme.textOnDark.withValues(alpha: 0.5),
                  ),
                ),
              const SizedBox(height: 12),
              // Divider
              Container(
                height: 0.5,
                color: theme.glassBorder,
              ),
              const SizedBox(height: 12),
              // Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: MirageTypography.bodyMedium(
                      color: theme.textOnDark.withValues(alpha: 0.6),
                    ),
                  ),
                  Text(
                    '\$${order.totalAmount.toStringAsFixed(2)}',
                    style: MirageTypography.price(
                      color: theme.accent,
                    ).copyWith(fontSize: 18),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty(dynamic theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: theme.textOnDark.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Text(
            'No orders yet',
            style: MirageTypography.headingMedium(
              color: theme.textOnDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your order history will appear here',
            style: MirageTypography.bodyMedium(
              color: theme.textOnDark.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(OrderHistoryViewModel vm, dynamic theme) {
    return Center(
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
            'Unable to load orders',
            style: MirageTypography.headingMedium(
              color: theme.textOnDark,
            ),
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
            onPressed: vm.loadOrders,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.accentWarm,
              foregroundColor: theme.textOnDark,
            ),
            child: const Text('RETRY'),
          ),
        ],
      ),
    );
  }
}
