import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/Home/Controller/Home_Controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
