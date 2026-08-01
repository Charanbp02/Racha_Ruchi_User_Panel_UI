// lib/App/Modules/Home/widgets/home_body.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/Home/widgets/home_content.dart';
import 'package:racharuchi/App/Modules/Home/widgets/home_error.dart';
import 'package:racharuchi/App/Modules/Home/widgets/home_search_bar.dart';
import 'package:racharuchi/App/Modules/Home/widgets/home_loading.dart';
import 'package:racharuchi/App/Modules/Home/Controller/home_controller.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();

    return Obx(() {
      // Loading state
      if (controller.isLoading.value) {
        return const HomeLoading();
      }

      // Error state
      if (controller.errorMessage.value.isNotEmpty) {
        return HomeError(
          errorMessage: controller.errorMessage.value,
          onRetry: controller.refreshHome,
        );
      }

      // Normal state
      return Column(
        children: [const HomeSearchBar(), Expanded(child: const HomeContent())],
      );
    });
  }
}
