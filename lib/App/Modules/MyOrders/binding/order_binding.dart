// lib/app/Modules/Orders/binding/order_binding.dart
import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/MyOrders/controller/order_controller.dart';

class OrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderController>(() => OrderController());
  }
}
