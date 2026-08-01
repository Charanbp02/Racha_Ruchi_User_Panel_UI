// lib/App/Modules/BottomNav/widgets/bottom_nav_scaffold.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/BottomNav/controller/bottom_nav_controller.dart';
import 'package:racharuchi/App/Modules/BottomNav/widgets/bottom_nav_bar.dart';
import 'package:racharuchi/App/Modules/BottomNav/widgets/nav_pages.dart';
import 'package:racharuchi/App/Modules/Upload/view/upload_type_bottom_sheet.dart';

class BottomNavScaffold extends StatelessWidget {
  const BottomNavScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BottomNavController>();

    return Obx(
      () => Scaffold(
        body: NavPages(currentIndex: controller.selectedIndex.value),
        bottomNavigationBar: BottomNavBar(
          currentIndex: controller.selectedIndex.value,
          onTap: (index) => _handleNavigation(index, controller),
        ),
      ),
    );
  }

  void _handleNavigation(int index, BottomNavController controller) {
    if (index == 1) {
      _showUploadTypeBottomSheet();
    } else {
      controller.changeTab(index);
    }
  }

  void _showUploadTypeBottomSheet() {
    Get.bottomSheet(
      const UploadTypeBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
    );
  }
}
