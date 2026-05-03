import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/Splash/controller/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController(), fenix: true);
  }
}
