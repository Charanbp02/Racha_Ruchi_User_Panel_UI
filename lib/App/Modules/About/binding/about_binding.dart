import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/About/controller/about_controller.dart';

class AboutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AboutController>(() => AboutController());
  }
}
