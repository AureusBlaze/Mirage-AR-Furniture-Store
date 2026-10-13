/// API endpoint constants matching the Laravel API routes.
class ApiEndpoints {
  ApiEndpoints._();

  // ─── Auth ────────────────────────────────────────────────────────
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String user = '/auth/me';

  // ─── Products ────────────────────────────────────────────────────
  static const String products = '/products';
  static String product(int id) => '/products/$id';

  // ─── Categories ──────────────────────────────────────────────────
  static const String categories = '/categories';
  static String category(int id) => '/categories/$id';
  static String categoryProducts(int id) => '/categories/$id/products';

  // ─── Orders ──────────────────────────────────────────────────────
  static const String orders = '/orders';
  static String order(int id) => '/orders/$id';

  // ─── AR Models ───────────────────────────────────────────────────
  static const String arModels = '/ar-models';
  static String productArModel(int id) => '/products/$id/ar-model';

  // ─── AI ──────────────────────────────────────────────────────────
  static const String aiSuggest = '/ai/suggest';

  // ─── Search ──────────────────────────────────────────────────────
  static const String search = '/products'; // with ?search= query param
}
