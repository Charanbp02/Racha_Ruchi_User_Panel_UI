// lib/App/Modules/Profile/view/profile_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/Profile/controller/profile_controller.dart';
import 'package:racharuchi/App/Modules/Profile/widgets/profile_app_bar.dart';
import 'package:racharuchi/App/Modules/Profile/widgets/profile_loading.dart';
import 'package:racharuchi/App/Modules/Profile/widgets/profile_header.dart';
import 'package:racharuchi/App/Modules/Profile/widgets/stats_section.dart';
import 'package:racharuchi/App/Modules/Profile/widgets/menu_list.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller if not already registered
    if (!Get.isRegistered<ProfileController>()) {
      Get.put(ProfileController());
    }

    final controller = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: const ProfileAppBar(),
      body: Obx(
        () =>
            controller.isLoading.value
                ? const ProfileLoading()
                : SingleChildScrollView(
                  child: Column(
                    children: [
                      ProfileHeader(controller: controller),
                      const SizedBox(height: 16),
                      StatsSection(controller: controller),
                      const SizedBox(height: 16),
                      MenuList(controller: controller),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
      ),
    );
  }
}
