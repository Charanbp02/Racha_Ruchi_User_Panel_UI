// lib/App/Modules/Cart/view/cart_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/Cart/controller/cart_controller.dart';
import 'package:racharuchi/App/Modules/Cart/widgets/cart_app_bar.dart';
import 'package:racharuchi/App/Modules/Cart/widgets/cart_loading_indicator.dart';
import 'package:racharuchi/App/Modules/Cart/widgets/cart_item_list.dart';
import 'package:racharuchi/App/Modules/Cart/widgets/cart_summary.dart';
import 'package:racharuchi/App/Modules/Cart/widgets/empty_cart.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller if not already registered
    if (!Get.isRegistered<CartController>()) {
      Get.put(CartController());
    }

    final controller = Get.find<CartController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: const CartAppBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const CartLoadingIndicator();
        }

        if (controller.cartItems.isEmpty) {
          return const EmptyCart();
        }

        return Column(
          children: [
            CartItemList(controller: controller),
            CartSummary(controller: controller),
          ],
        );
      }),
    );
  }
}
