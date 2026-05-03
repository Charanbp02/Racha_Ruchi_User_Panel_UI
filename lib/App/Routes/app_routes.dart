abstract class AppRoutes {
  AppRoutes._();

  static const INITIAL = Routes.SPLASH;
  static const BOTTOM_BAR = Routes.BOTTOM_BAR; // ✅ Add this line
  static const SPLASH = Routes.SPLASH; // ✅ Add this line
}

abstract class Routes {
  Routes._();

  static const HOME = '/home';
  static const CATEGORY = '/category';
  static const BANNER = '/Banner';
  static const TOP_RECIPE_VIDEO = '/top_recipe_video';
  static const POPULAR_RECIPES = '/popular_recipes';
  static const BOTTOM_BAR = '/bottom-bar';
  static const SEARCH = '/search';
  static const SHORTS = '/shorts';
  static const UPLOAD = '/upload';
  static const PRODUCT = '/product';
  static const PROFILE = '/profile';
  static const NOTIFICATIONS = '/notifications';
  static const CART = '/cart';
  static const SPLASH = '/splash';
  static const MY_ORDERS = '/orders';
  static const MY_RECIPES = '/my-recipes';
  static const COUPONS = '/coupons';
  static const ADDRESS_BOOK = '/address-book';
  static const HELP_SUPPORT = '/help-support';
  static const LOGIN = '/login';
  static const SIGNUP = '/signup';
  static const STATS = '/stats';
  static const SOCIAL = '/social';
  static const VIDEO_PLAYER = '/video-player';
  static const AI_FLOATING = '/ai-floating';
}
