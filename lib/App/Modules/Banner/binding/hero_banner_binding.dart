import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/Banner/controller/hero_banner_controller.dart';

class HeroBannerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HeroBannerController>(
      () => HeroBannerController(),
      fenix: true,
    );
  }
}
