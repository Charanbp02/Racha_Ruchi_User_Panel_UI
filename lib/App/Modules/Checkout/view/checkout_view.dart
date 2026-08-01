import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/Checkout/controller/checkout_controller.dart';
import 'package:racharuchi/App/Modules/Checkout/widgets/checkout_app_bar.dart';
import 'package:racharuchi/App/Modules/Checkout/widgets/delivery_address_section.dart';
import 'package:racharuchi/App/Modules/Checkout/widgets/order_items_section.dart';
import 'package:racharuchi/App/Modules/Checkout/widgets/payment_method_section.dart';
import 'package:racharuchi/App/Modules/Checkout/widgets/bill_details_section.dart';
import 'package:racharuchi/App/Modules/Checkout/widgets/bottom_sticky_bar.dart';
import 'package:racharuchi/App/Modules/Checkout/widgets/loading_overlay.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: CheckoutAppBar(
        itemCount: controller.itemCount,
        onBack: () => Get.back(),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  padding: const EdgeInsets.only(bottom: 120),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      const DeliveryAddressSection(),
                      const SizedBox(height: 12),
                      const OrderItemsSection(),
                      const SizedBox(height: 12),
                      const PaymentMethodSection(),
                      const SizedBox(height: 12),
                      const BillDetailsSection(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              const BottomStickyBar(),
            ],
          ),
          Obx(
            () =>
                controller.isProcessing.value
                    ? const LoadingOverlay()
                    : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
