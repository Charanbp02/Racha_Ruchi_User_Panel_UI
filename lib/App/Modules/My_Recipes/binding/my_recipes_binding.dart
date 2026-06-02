import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/Upload/controller/upload_controller.dart';

class MyRecipesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UploadController>(() => UploadController(), fenix: true);
  }
}
