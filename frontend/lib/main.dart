import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'app/app.dart';
import 'app/theme/theme_provider.dart';
import 'core/di/service_locator.dart';
import 'core/dev/dev_settings_provider.dart';
import 'core/network/connection_status_service.dart';
import 'presentation/viewmodels/auth_viewmodel.dart';
import 'presentation/viewmodels/home_viewmodel.dart';
import 'presentation/viewmodels/catalog_viewmodel.dart';
import 'presentation/viewmodels/product_detail_viewmodel.dart';
import 'presentation/viewmodels/cart_viewmodel.dart';
import 'presentation/viewmodels/checkout_viewmodel.dart';
import 'presentation/viewmodels/search_viewmodel.dart';
import 'presentation/viewmodels/ar_list_viewmodel.dart';
import 'presentation/viewmodels/camera_viewmodel.dart';
import 'presentation/viewmodels/order_history_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Transparent status bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      // statusBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize DI
  await initServiceLocator();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider.value(value: sl<DevSettingsProvider>()),
        ChangeNotifierProvider.value(value: sl<ConnectionStatusService>()),
        ChangeNotifierProvider(
          create: (_) => sl<AuthViewModel>()..checkAuthStatus(),
        ),
        ChangeNotifierProvider(create: (_) => sl<HomeViewModel>()),
        ChangeNotifierProvider(create: (_) => sl<CatalogViewModel>()),
        ChangeNotifierProvider(create: (_) => sl<ProductDetailViewModel>()),
        ChangeNotifierProvider(create: (_) => sl<CartViewModel>()..loadCart()),
        ChangeNotifierProvider(create: (_) => sl<CheckoutViewModel>()),
        ChangeNotifierProvider(create: (_) => sl<SearchViewModel>()),
        ChangeNotifierProvider(create: (_) => sl<ArListViewModel>()),
        ChangeNotifierProvider(create: (_) => sl<CameraViewModel>()),
        ChangeNotifierProvider(create: (_) => sl<OrderHistoryViewModel>()),
      ],
      child: const MirageApp(),
    ),
  );
}
