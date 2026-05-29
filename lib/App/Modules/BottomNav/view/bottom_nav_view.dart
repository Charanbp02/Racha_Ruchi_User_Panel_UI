import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Modules/BottomNav/controller/bottom_nav_controller.dart';
import 'package:racharuchi/App/Modules/Home/View/Home_view.dart';
import 'package:racharuchi/App/Modules/Products/view/products_view.dart';
import 'package:racharuchi/App/Modules/Profile/view/profile_view.dart';
import 'package:racharuchi/App/Modules/Upload/view/upload_type_bottom_sheet.dart';

class BottomNavView extends StatelessWidget {
  const BottomNavView({super.key});

  @override
  Widget build(BuildContext context) {
    final BottomNavController controller = Get.put(BottomNavController());

    final pages = [
      const HomeView(),
      Container(), // Placeholder for Upload
      const ProductsView(),
      const ProfileView(),
    ];

    return Obx(
      () => Scaffold(
        body: pages[controller.selectedIndex.value],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
            onTap: (index) {
              if (index == 1) {
                // Show upload type bottom sheet (now at index 1 since Shorts is removed)
                _showUploadTypeBottomSheet();
              } else {
                controller.changeTab(index);
              }
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFFE53935),
            unselectedItemColor: Colors.grey.shade500,
            selectedFontSize: 11,
            unselectedFontSize: 11,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Iconsax.home),
                activeIcon: Icon(Iconsax.home5),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Iconsax.gallery_add),
                activeIcon: Icon(Iconsax.gallery_add5),
                label: 'Upload',
              ),
              BottomNavigationBarItem(
                icon: Icon(Iconsax.shopping_bag),
                activeIcon: Icon(Iconsax.shopping_bag5),
                label: 'Products',
              ),
              BottomNavigationBarItem(
                icon: Icon(Iconsax.profile_circle),
                activeIcon: Icon(Iconsax.profile_circle5),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
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
