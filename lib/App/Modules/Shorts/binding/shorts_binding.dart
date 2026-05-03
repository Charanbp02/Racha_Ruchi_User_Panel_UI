import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/Shorts/controller/shorts_controller.dart';

class ShortsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShortsController>(() => ShortsController(), fenix: true);
  }
}
