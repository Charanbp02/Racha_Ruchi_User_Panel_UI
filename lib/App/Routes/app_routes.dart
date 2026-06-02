// app_routes.dart
abstract class AppRoutes {
  AppRoutes._();

  static const INITIAL = Routes.SPLASH;
  static const LOGIN = Routes.LOGIN;
  static const SIGNUP = Routes.SIGNUP;
  static const BOTTOM_BAR = Routes.BOTTOM_BAR;
  static const SPLASH = Routes.SPLASH;
  static const HOME = Routes.HOME;
  static const CATEGORY = Routes.CATEGORY;
  static const BANNER = Routes.BANNER;
  static const TOP_RECIPE_VIDEO = Routes.TOP_RECIPE_VIDEO;
  static const POPULAR_RECIPES = Routes.POPULAR_RECIPES;
  static const SEARCH = Routes.SEARCH;
  static const SHORTS = Routes.SHORTS;
  static const UPLOAD = Routes.UPLOAD;
  static const PRODUCT = Routes.PRODUCT;
  static const PROFILE = Routes.PROFILE;
  static const NOTIFICATIONS = Routes.NOTIFICATIONS;
  static const CART = Routes.CART;
  static const MY_ORDERS = Routes.MY_ORDERS;
  static const MY_RECIPES = Routes.MY_RECIPES;
  static const COUPONS = Routes.COUPONS;
  static const ADDRESS_BOOK = Routes.ADDRESS_BOOK;
  static const HELP_SUPPORT = Routes.HELP_SUPPORT;
  static const STATS = Routes.STATS;
  static const SOCIAL = Routes.SOCIAL;
  static const VIDEO_PLAYER = Routes.VIDEO_PLAYER;
  static const ALL_VIDEOS = Routes.ALL_VIDEOS;
  static const AICHAT = Routes.AICHAT;
  static const SEARCH_RESULTS = Routes.SEARCH_RESULTS;
  static const ABOUT_US = Routes.ABOUT_US;
}

// routes.dart (ensure all routes are defined)
abstract class Routes {
  Routes._();

  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const SIGNUP = '/signup';
  static const BOTTOM_BAR = '/bottom-bar';
  static const HOME = '/home';
  static const CATEGORY = '/category';
  static const BANNER = '/Banner';
  static const TOP_RECIPE_VIDEO = '/top_recipe_video';
  static const POPULAR_RECIPES = '/popular_recipes';
  static const SEARCH = '/search';
  static const SHORTS = '/shorts';
  static const UPLOAD = '/upload';
  static const PRODUCT = '/product';
  static const PROFILE = '/profile';
  static const NOTIFICATIONS = '/notifications';
  static const CART = '/cart';
  static const MY_ORDERS = '/orders';
  static const MY_RECIPES = '/my-recipes';
  static const COUPONS = '/coupons';
  static const ADDRESS_BOOK = '/address-book';
  static const HELP_SUPPORT = '/help-support';
  static const STATS = '/stats';
  static const SOCIAL = '/social';
  static const VIDEO_PLAYER = '/video-player';
  static const ALL_VIDEOS = '/all-videos';
  static const AICHAT = '/ai-chat';
  static const SEARCH_RESULTS = '/search-results';
  static const ABOUT_US = '/about-us';
}
