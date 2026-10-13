import 'package:get_it/get_it.dart';
import 'package:mirage_by_aurues/core/network/api_client.dart';
import 'package:mirage_by_aurues/core/network/connection_status_service.dart';
import 'package:mirage_by_aurues/core/storage/secure_storage.dart';
import 'package:mirage_by_aurues/core/dev/dev_settings_provider.dart';
import 'package:mirage_by_aurues/data/datasources/remote/auth_remote_data_source.dart';
import 'package:mirage_by_aurues/data/datasources/remote/product_remote_data_source.dart';
import 'package:mirage_by_aurues/data/datasources/remote/category_remote_data_source.dart';
import 'package:mirage_by_aurues/data/datasources/remote/order_remote_data_source.dart';
import 'package:mirage_by_aurues/data/datasources/remote/ai_remote_data_source.dart';
import 'package:mirage_by_aurues/data/datasources/local/cart_local_data_source.dart';
import 'package:mirage_by_aurues/data/repositories/auth_repository_impl.dart';
import 'package:mirage_by_aurues/data/repositories/product_repository_impl.dart';
import 'package:mirage_by_aurues/data/repositories/category_repository_impl.dart';
import 'package:mirage_by_aurues/data/repositories/order_repository_impl.dart';
import 'package:mirage_by_aurues/data/repositories/ai_repository_impl.dart';
import 'package:mirage_by_aurues/data/repositories/cart_repository_impl.dart';
import 'package:mirage_by_aurues/domain/repositories/auth_repository.dart';
import 'package:mirage_by_aurues/domain/repositories/product_repository.dart';
import 'package:mirage_by_aurues/domain/repositories/category_repository.dart';
import 'package:mirage_by_aurues/domain/repositories/order_repository.dart';
import 'package:mirage_by_aurues/domain/repositories/ai_repository.dart';
import 'package:mirage_by_aurues/domain/repositories/cart_repository.dart';
import 'package:mirage_by_aurues/presentation/viewmodels/auth_viewmodel.dart';
import 'package:mirage_by_aurues/presentation/viewmodels/home_viewmodel.dart';
import 'package:mirage_by_aurues/presentation/viewmodels/catalog_viewmodel.dart';
import 'package:mirage_by_aurues/presentation/viewmodels/product_detail_viewmodel.dart';
import 'package:mirage_by_aurues/presentation/viewmodels/cart_viewmodel.dart';
import 'package:mirage_by_aurues/presentation/viewmodels/checkout_viewmodel.dart';
import 'package:mirage_by_aurues/presentation/viewmodels/search_viewmodel.dart';
import 'package:mirage_by_aurues/presentation/viewmodels/ar_list_viewmodel.dart';
import 'package:mirage_by_aurues/presentation/viewmodels/camera_viewmodel.dart';
import 'package:mirage_by_aurues/presentation/viewmodels/order_history_viewmodel.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  // ─── Core ────────────────────────────────────────────────────────
  sl.registerLazySingleton<SecureStorageService>(() => SecureStorageService());
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(secureStorage: sl<SecureStorageService>()),
  );

  // ─── Connection Status (uses ApiClient, so must be registered after it) ──
  sl.registerLazySingleton<ConnectionStatusService>(
    () => ConnectionStatusService(sl<ApiClient>()),
  );

  // Wire the status interceptor into Dio (two-phase init to break circular dep)
  sl<ApiClient>().attachStatusInterceptor(sl<ConnectionStatusService>());

  // ─── Dev Settings ────────────────────────────────────────────────
  sl.registerLazySingleton<DevSettingsProvider>(
    () => DevSettingsProvider(sl<ApiClient>()),
  );

  // ─── Data Sources ────────────────────────────────────────────────
  sl.registerLazySingleton(() => AuthRemoteDataSource(sl<ApiClient>()));
  sl.registerLazySingleton(() => ProductRemoteDataSource(sl<ApiClient>()));
  sl.registerLazySingleton(() => CategoryRemoteDataSource(sl<ApiClient>()));
  sl.registerLazySingleton(() => OrderRemoteDataSource(sl<ApiClient>()));
  sl.registerLazySingleton(() => AiRemoteDataSource(sl<ApiClient>()));
  sl.registerLazySingleton(() => CartLocalDataSource());

  // ─── Repositories ────────────────────────────────────────────────
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      sl<AuthRemoteDataSource>(),
      sl<SecureStorageService>(),
    ),
  );
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl<ProductRemoteDataSource>()),
  );
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(sl<CategoryRemoteDataSource>()),
  );
  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(sl<OrderRemoteDataSource>()),
  );
  sl.registerLazySingleton<AiRepository>(
    () => AiRepositoryImpl(sl<AiRemoteDataSource>()),
  );
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(sl<CartLocalDataSource>()),
  );

  // ─── ViewModels ──────────────────────────────────────────────────
  sl.registerFactory(() => AuthViewModel(sl<AuthRepository>()));
  sl.registerFactory(() => HomeViewModel(sl<CategoryRepository>()));
  sl.registerFactory(() => CatalogViewModel(sl<ProductRepository>(), sl<CategoryRepository>()));
  sl.registerFactory(() => ProductDetailViewModel(sl<ProductRepository>()));
  sl.registerFactory(() => CartViewModel(sl<CartRepository>()));
  sl.registerFactory(
    () => CheckoutViewModel(sl<OrderRepository>(), sl<CartRepository>()),
  );
  sl.registerFactory(() => SearchViewModel(sl<ProductRepository>()));
  sl.registerFactory(() => ArListViewModel(sl<ProductRepository>()));
  sl.registerFactory(() => CameraViewModel(sl<AiRepository>()));
  sl.registerFactory(() => OrderHistoryViewModel(sl<OrderRepository>()));
}
