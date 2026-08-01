import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/Splash/controller/splash_controller.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());

    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.cover, // Full screen image
        ),
      ),
    );
  }
}
