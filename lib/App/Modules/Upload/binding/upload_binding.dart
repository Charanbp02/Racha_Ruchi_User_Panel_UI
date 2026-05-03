import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/Upload/controller/upload_controller.dart';

class UploadBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UploadController>(() => UploadController());
  }
}
