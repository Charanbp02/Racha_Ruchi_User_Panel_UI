import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/VideoPlayer/controller/video_player_controller.dart';

class VideoPlayerBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VideoPlayerControllerX());
  }
}
