import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/Categories/controller/category_controller.dart';

class CategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CategoryController());
  }
}
