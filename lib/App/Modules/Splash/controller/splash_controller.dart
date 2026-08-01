import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:racharuchi/App/Routes/app_routes.dart';

class SplashController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    checkLogin();
  }

  Future<void> checkLogin() async {
    await Future.delayed(const Duration(seconds: 3));

    final user = _auth.currentUser;

    if (user != null) {
      Get.offAllNamed(AppRoutes.BOTTOM_BAR);
    } else {
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }
}
