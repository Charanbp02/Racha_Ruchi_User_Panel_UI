import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/Profile/controller/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
  }
}
