import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/All_Videos/controller/videos_controller.dart';

class VideosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VideosController>(() => VideosController());
  }
}
