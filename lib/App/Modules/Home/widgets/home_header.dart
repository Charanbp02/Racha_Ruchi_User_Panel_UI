// lib/App/Modules/Home/widgets/home_header.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racharuchi/App/Custom/appBar.dart';
import 'package:racharuchi/App/Modules/Cart/controller/cart_controller.dart';

class HomeHeader extends StatelessWidget implements PreferredSizeWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    return Obx(
      () => CustomAppBar(
        title: "Racha Ruchi",
        cartItemCount: cartController.cartItemCount,
        notificationCount: 0,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
