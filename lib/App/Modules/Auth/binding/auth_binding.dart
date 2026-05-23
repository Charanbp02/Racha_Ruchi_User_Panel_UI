import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/Auth/controller/login_controller.dart';
import 'package:racharuchi/App/Modules/Auth/controller/signup_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
    Get.lazyPut<SignUpController>(() => SignUpController(), fenix: true);
    Get.lazyPut<CacheManager>(() => CacheManager(), fenix: true);
  }
}
