import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/Cart/controller/cart_controller.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CartController>(() => CartController(), fenix: true);
  }
}
