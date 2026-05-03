import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/Products/controller/products_controller.dart';

class ProductsBinding extends Bindings {
  @override
  void dependencies() {
    // Use Get.put instead of Get.lazyPut for immediate initialization
    if (!Get.isRegistered<ProductsController>()) {
      Get.put(ProductsController(), permanent: false);
    }
  }
}
