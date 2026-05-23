import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/VideoPlayer/controller/video_player_controller.dart';

class VideoPlayerBinding extends Bindings {
  @override
  void dependencies() {
    // Don't lazy put here because we need to pass parameters
    // The controller will be created in the view with parameters
    Get.lazyPut<VideoPlayerControllerX>(
      () => VideoPlayerControllerX(
        videoUrl: '',
        videoTitle: '',
        channelName: '',
        channelImage: '',
        videoId: '',
        description: '',
        ingredients: [],
        userId: '',
      ),
      fenix: true,
    );
  }
}
