import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/Coupons/controller/coupons_controller.dart';

class CouponsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CouponsController>(() => CouponsController(), fenix: true);
  }
}
