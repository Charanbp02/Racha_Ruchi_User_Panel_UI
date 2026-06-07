// lib/App/Modules/Cart/view/cart_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:racharuchi/App/Models/Cart_Model/cart_models.dart';
import 'package:racharuchi/App/Modules/Cart/controller/cart_controller.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController controller = Get.put(CartController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Obx(
          () => Text(
            'My Cart (${controller.totalItems})',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xFF2D2D2D),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left, color: Color(0xFF2D2D2D)),
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(
            () => IconButton(
              icon: const Icon(Iconsax.trash, color: Color(0xFFE53935)),
              onPressed:
                  controller.cartItems.isEmpty ? null : controller.clearCart,
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFE53935)),
          );
        }

        if (controller.cartItems.isEmpty) {
          return _buildEmptyCart();
        }

        return Column(
          children: [
            // Cart Items List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.cartItems.length,
                itemBuilder: (context, index) {
                  final item = controller.cartItems[index];
                  return _buildCartItem(item, index, controller);
                },
              ),
            ),

            // Bottom Summary
            _buildBottomSummary(controller),
          ],
        );
      }),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFE53935).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Iconsax.shopping_bag,
              size: 60,
              color: Color(0xFFE53935),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Your Cart is Empty',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D2D2D),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add items to get started',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            ),
            child: const Text('Browse Items'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(
    CartItemModel item,
    int index,
    CartController controller,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: item.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              placeholder:
                  (context, url) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey.shade100,
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
              errorWidget:
                  (context, url, error) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey.shade100,
                    child: const Icon(Iconsax.gallery, color: Colors.grey),
                  ),
            ),
          ),
          const SizedBox(width: 12),

          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Veg/Non-Veg Indicator
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: item.isVeg ? Colors.green : Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item.restaurant,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Product Name with Weight Variant
                Text(
                  item.displayName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 4),

                // Brand/Category
                if (item.brand != null && item.brand!.isNotEmpty)
                  Text(
                    item.brand!,
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                  ),
                const SizedBox(height: 4),

                // Price
                Text(
                  '₹${item.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFFE53935),
                  ),
                ),
              ],
            ),
          ),

          // Quantity Controls
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE53935).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Iconsax.minus, size: 16),
                      onPressed: () => controller.decrementQuantity(index),
                      color: const Color(0xFFE53935),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    SizedBox(
                      width: 30,
                      child: Text(
                        item.quantity.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Iconsax.add, size: 16),
                      onPressed: () => controller.incrementQuantity(index),
                      color: const Color(0xFFE53935),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => controller.removeItem(index),
                child: const Icon(Iconsax.trash, size: 18, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSummary(CartController controller) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Coupon Section
              _buildCouponSection(controller),
              const SizedBox(height: 16),

              // Price Details
              _buildPriceDetail(
                'Subtotal (${controller.totalItems} items)',
                '₹${controller.getSubtotal().toStringAsFixed(2)}',
              ),
              _buildPriceDetail(
                'Delivery Charge',
                controller.deliveryCharge.value == 0
                    ? 'Free'
                    : '₹${controller.deliveryCharge.value.toStringAsFixed(2)}',
              ),
              _buildPriceDetail(
                'Tax (${controller.taxPercentage.value}%)',
                '₹${controller.getTax().toStringAsFixed(2)}',
              ),

              // Discount section (if coupon applied)
              if (controller.discountAmount.value > 0) ...[
                const Divider(height: 16),
                _buildPriceDetail(
                  'Discount (${controller.appliedCoupon.value})',
                  '-₹${controller.discountAmount.value.toStringAsFixed(2)}',
                  isDiscount: true,
                ),
              ],

              const Divider(height: 16),
              _buildPriceDetail(
                'Total',
                '₹${controller.getTotal().toStringAsFixed(2)}',
                isTotal: true,
              ),
              const SizedBox(height: 16),

              // Checkout Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.proceedToCheckout(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Proceed to Checkout',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCouponSection(CartController controller) {
    final TextEditingController couponController = TextEditingController();

    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFE53935).withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFE53935).withValues(alpha: 0.2),
          ),
        ),
        child:
            controller.appliedCoupon.value.isNotEmpty
                ? Row(
                  children: [
                    const Icon(
                      Iconsax.discount_circle,
                      color: Color(0xFFE53935),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Coupon applied: ${controller.appliedCoupon.value}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFE53935),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: controller.removeCoupon,
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFFE53935),
                      ),
                      child: const Text('Remove'),
                    ),
                  ],
                )
                : Row(
                  children: [
                    const Icon(
                      Iconsax.discount_circle,
                      color: Color(0xFFE53935),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: couponController,
                        decoration: const InputDecoration(
                          hintText: 'Enter coupon code',
                          border: InputBorder.none,
                          hintStyle: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        controller.applyCoupon(couponController.text);
                        couponController.clear();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFFE53935),
                      ),
                      child: const Text('Apply'),
                    ),
                  ],
                ),
      ),
    );
  }

  Widget _buildPriceDetail(
    String title,
    String amount, {
    bool isTotal = false,
    bool isDiscount = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? const Color(0xFF2D2D2D) : Colors.grey.shade700,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color:
                  isDiscount
                      ? Colors.green
                      : (isTotal
                          ? const Color(0xFFE53935)
                          : Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }
}
