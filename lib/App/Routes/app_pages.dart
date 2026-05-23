import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/AIFloatingButton/binding/ai_floating_binding.dart';
import 'package:racharuchi/App/Modules/AIFloatingButton/view/ai_floating_view.dart';
import 'package:racharuchi/App/Modules/AddressBook/binding/address_binding.dart';
import 'package:racharuchi/App/Modules/AddressBook/view/address_view.dart';
import 'package:racharuchi/App/Modules/All_Videos/binding/videos_binding.dart';
import 'package:racharuchi/App/Modules/All_Videos/view/videos_view.dart';
import 'package:racharuchi/App/Modules/Auth/binding/auth_binding.dart';
import 'package:racharuchi/App/Modules/Auth/view/login_view.dart';
import 'package:racharuchi/App/Modules/Auth/view/signup_view.dart';
import 'package:racharuchi/App/Modules/Banner/binding/hero_banner_binding.dart';
import 'package:racharuchi/App/Modules/Banner/view/hero_banner_view.dart';
import 'package:racharuchi/App/Modules/BottomNav/binding/bottom_nav_binding.dart';
import 'package:racharuchi/App/Modules/BottomNav/view/bottom_nav_view.dart';
import 'package:racharuchi/App/Modules/Cart/binding/cart_binding.dart';
import 'package:racharuchi/App/Modules/Cart/view/cart_view.dart';
import 'package:racharuchi/App/Modules/Categories/binding/category_binding.dart';
import 'package:racharuchi/App/Modules/Categories/view/category_view.dart';
import 'package:racharuchi/App/Modules/Coupons/binding/coupons_binding.dart';
import 'package:racharuchi/App/Modules/Coupons/view/coupons_view.dart';
import 'package:racharuchi/App/Modules/HelpSupport/binding/help_support_binding.dart';
import 'package:racharuchi/App/Modules/HelpSupport/view/help_support_view.dart';
import 'package:racharuchi/App/Modules/Home/Binding/Home_Binding.dart';
import 'package:racharuchi/App/Modules/Home/View/Home_view.dart';
import 'package:racharuchi/App/Modules/MyOrders/binding/order_binding.dart';
import 'package:racharuchi/App/Modules/MyOrders/view/order_view.dart';
import 'package:racharuchi/App/Modules/My_Recipes/binding/my_recipes_binding.dart';
import 'package:racharuchi/App/Modules/My_Recipes/view/my_recipes_view.dart';
import 'package:racharuchi/App/Modules/Notifications/binding/notification_binding.dart';
import 'package:racharuchi/App/Modules/Notifications/view/notification_view.dart';
import 'package:racharuchi/App/Modules/Products/binding/products_binding.dart';
import 'package:racharuchi/App/Modules/Products/view/products_view.dart';
import 'package:racharuchi/App/Modules/Profile/binding/profile_binding.dart';
import 'package:racharuchi/App/Modules/Profile/view/profile_view.dart';
import 'package:racharuchi/App/Modules/Search/binding/search_binding.dart';
import 'package:racharuchi/App/Modules/Search/view/search_bar_view.dart';
import 'package:racharuchi/App/Modules/Social/binding/social_binding.dart';
import 'package:racharuchi/App/Modules/Social/view/social_view.dart';
import 'package:racharuchi/App/Modules/Splash/binding/splash_binding.dart';
import 'package:racharuchi/App/Modules/Splash/view/splash_view.dart';
import 'package:racharuchi/App/Modules/Stats/binding/stats_binding.dart';
import 'package:racharuchi/App/Modules/Stats/view/stats_view.dart';
import 'package:racharuchi/App/Modules/Upload/binding/upload_binding.dart';
import 'package:racharuchi/App/Modules/Upload/view/upload_view.dart';
import 'package:racharuchi/App/Modules/VideoPlayer/binding/video_player_binding.dart';
import 'package:racharuchi/App/Modules/VideoPlayer/view/video_player_view.dart';
import 'package:racharuchi/App/Routes/app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.CATEGORY,
      page: () => const CategorySectionView(),
      binding: CategoryBinding(),
    ),
    GetPage(
      name: Routes.BANNER,
      page: () => const HeroBannerView(),
      binding: HeroBannerBinding(),
    ),

    GetPage(
      name: Routes.BOTTOM_BAR,
      page: () => const BottomNavView(),
      binding: BottomNavBinding(),
    ),
    GetPage(
      name: Routes.SEARCH,
      page: () => const SearchBarView(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: Routes.UPLOAD,
      page: () => const UploadView(),
      binding: UploadBinding(),
    ),
    GetPage(
      name: Routes.PRODUCT,
      page: () => const ProductsView(),
      binding: ProductsBinding(),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.NOTIFICATIONS,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: Routes.CART,
      page: () => const CartView(),
      binding: CartBinding(),
    ),
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.MY_ORDERS,
      page: () => const OrderView(),
      binding: OrderBinding(),
    ),
    GetPage(
      name: Routes.MY_RECIPES,
      page: () => const MyRecipesView(),
      binding: MyRecipesBinding(),
    ),
    GetPage(
      name: Routes.COUPONS,
      page: () => const CouponsView(),
      binding: CouponsBinding(),
    ),
    GetPage(
      name: Routes.ADDRESS_BOOK,
      page: () => const AddressBookView(),
      binding: AddressBinding(),
    ),
    GetPage(
      name: Routes.HELP_SUPPORT,
      page: () => const HelpSupportView(),
      binding: HelpSupportBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.SIGNUP,
      page: () => const SignUpView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.STATS,
      page: () => const StatsView(),
      binding: StatsBinding(),
    ),
    GetPage(
      name: Routes.SOCIAL,
      page: () => const SocialView(),
      binding: SocialBinding(),
    ),
    GetPage(
      name: Routes.VIDEO_PLAYER,
      page: () => const VideoPlayerView(),
      binding: VideoPlayerBinding(),
    ),
    GetPage(
      name: Routes.AI_FLOATING,
      page: () => const AIFloatingView(),
      binding: AIFloatingBinding(),
    ),
    GetPage(
      name: Routes.ALL_VIDEOS,
      page: () => VideosView(),
      binding: VideosBinding(),
    ),
  ];
}
