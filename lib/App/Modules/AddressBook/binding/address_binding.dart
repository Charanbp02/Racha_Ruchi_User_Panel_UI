import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/AddressBook/controller/address_controller.dart';

class AddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddressController>(() => AddressController(), fenix: true);
  }
}
