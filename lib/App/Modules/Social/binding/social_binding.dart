import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/Social/controller/social_controller.dart';

class SocialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SocialController>(
      () => SocialController(initialTab: 0),
      fenix: true,
    );
  }
}
