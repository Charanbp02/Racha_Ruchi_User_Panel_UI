// lib/App/Modules/Home/view/home_view.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/Home/Controller/home_controller.dart';
import 'package:racharuchi/App/Modules/Home/widgets/ai_chat_button.dart';
import 'package:racharuchi/App/Modules/Home/widgets/home_body.dart';
import 'package:racharuchi/App/Modules/Home/widgets/home_header.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is initialized
    if (!Get.isRegistered<HomeController>()) {
      Get.put(HomeController());
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: const HomeHeader(),
        body: const HomeBody(),
        floatingActionButton: const AIChatButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
