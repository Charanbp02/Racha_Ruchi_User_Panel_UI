import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/HelpSupport/controller/help_support_controller.dart';

class HelpSupportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HelpSupportController>(
      () => HelpSupportController(),
      fenix: true,
    );
  }
}
