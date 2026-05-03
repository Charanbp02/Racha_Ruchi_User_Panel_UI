import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/BottomNav/controller/bottom_nav_controller.dart';

class BottomNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomNavController>(() => BottomNavController(), fenix: true);
  }
}
