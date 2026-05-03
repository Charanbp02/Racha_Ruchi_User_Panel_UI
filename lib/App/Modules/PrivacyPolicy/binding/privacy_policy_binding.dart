import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/PrivacyPolicy/controller/privacy_policy_controller.dart';

class PrivacyPolicyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrivacyPolicyController>(
      () => PrivacyPolicyController(),
      fenix: true,
    );
  }
}
