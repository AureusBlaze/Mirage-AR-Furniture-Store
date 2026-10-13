import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mirage_by_aurues/app/theme/theme_provider.dart';
import 'package:mirage_by_aurues/app/theme/mirage_typography.dart';
import 'package:mirage_by_aurues/presentation/viewmodels/checkout_viewmodel.dart';
import 'package:mirage_by_aurues/presentation/viewmodels/cart_viewmodel.dart';
import 'package:mirage_by_aurues/presentation/widgets/aureus_navigation_guard.dart';

/// Checkout screen — shipping address form and order placement.
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _zipController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _addressController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().currentTheme;
    final cartVm = context.read<CartViewModel>();

    return AureusNavigationGuard(
      child: Scaffold(
      backgroundColor: theme.surface,
      appBar: AppBar(
        backgroundColor: theme.surface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'CHECKOUT',
          style: MirageTypography.labelLarge(color: theme.textPrimary)
              .copyWith(letterSpacing: 4),
        ),
        centerTitle: true,
      ),
      body: Consumer<CheckoutViewModel>(
        builder: (_, vm, __) {
          if (vm.orderPlaced) {
            return _buildSuccess(context, vm, theme);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('SHIPPING ADDRESS',
                      style: MirageTypography.labelLarge(color: theme.textPrimary)),
                  const SizedBox(height: 16),
                  _buildField('Street Address', _addressController, theme),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildField('City', _cityController, theme)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildField('Country', _countryController, theme)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildField('Postal Code', _zipController, theme),
                  const SizedBox(height: 32),
                  Text('ORDER SUMMARY',
                      style: MirageTypography.labelLarge(color: theme.textPrimary)),
                  const SizedBox(height: 12),
                  ...cartVm.items.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${item.name} x${item.quantity}',
                                style: MirageTypography.bodyMedium(color: theme.textPrimary),
                              ),
                            ),
                            Text(
                              '\$${item.total.toStringAsFixed(2)}',
                              style: MirageTypography.bodyMedium(color: theme.textPrimary)
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      )),
                  Divider(color: theme.surfaceVariant),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total',
                          style: MirageTypography.headingMedium(color: theme.textPrimary)),
                      Text(
                        '\$${cartVm.totalAmount.toStringAsFixed(2)}',
                        style: MirageTypography.price(color: theme.textPrimary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  if (vm.error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(vm.error!, style: TextStyle(color: theme.error)),
                    ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: vm.isLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                vm.placeOrder(
                                  addressLine: _addressController.text.trim(),
                                  city: _cityController.text.trim(),
                                  country: _countryController.text.trim(),
                                  postalCode: _zipController.text.trim(),
                                  items: cartVm.items,
                                );
                              }
                            },
                      child: vm.isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: theme.textOnDark,
                              ),
                            )
                          : const Text('PLACE ORDER'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ));
  }

  Widget _buildField(
      String label, TextEditingController controller, dynamic theme) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: theme.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: theme.textSecondary),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? 'Required' : null,
    );
  }

  Widget _buildSuccess(
      BuildContext context, CheckoutViewModel vm, dynamic theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: theme.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check, size: 40, color: theme.success),
            ),
            const SizedBox(height: 24),
            Text('ORDER PLACED',
                style: MirageTypography.displaySmall(color: theme.textPrimary)),
            const SizedBox(height: 8),
            Text(
              'Order #${vm.lastOrder?.id ?? ''}',
              style: MirageTypography.bodyMedium(color: theme.textSecondary),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                vm.reset();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('CONTINUE SHOPPING'),
            ),
          ],
        ),
      ),
    );
  }
}
