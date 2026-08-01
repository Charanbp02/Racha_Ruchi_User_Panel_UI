import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/Cart/controller/cart_controller.dart';
import 'package:racharuchi/App/Modules/Home/Controller/Home_Controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CartController(), permanent: true);
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
