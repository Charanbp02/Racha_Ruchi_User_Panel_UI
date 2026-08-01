// lib/app/modules/checkout/bindings/checkout_binding.dart

import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/Checkout/controller/checkout_controller.dart';

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CheckoutController>(() => CheckoutController());
  }
}
