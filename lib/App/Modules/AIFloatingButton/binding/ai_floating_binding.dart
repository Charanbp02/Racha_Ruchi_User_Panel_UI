import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/AIFloatingButton/controller/ai_floating_controller.dart';

class AIFloatingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AIFloatingController>(() => AIFloatingController());
  }
}
