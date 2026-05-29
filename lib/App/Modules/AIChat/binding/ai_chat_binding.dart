import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/AIChat/controller/ai_chat_controller.dart';

class AIChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AIChatController>(() => AIChatController());
  }
}
