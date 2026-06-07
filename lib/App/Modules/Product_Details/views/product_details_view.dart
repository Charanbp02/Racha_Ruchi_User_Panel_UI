// lib/App/Modules/Product_Details/views/product_details_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Modules/Product_Details/controller/product_details_controller.dart';

class ProductDetailsView extends GetView<ProductDetailsController> {
  const ProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final product = controller.productModel.product;

    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
      extendBodyBehindAppBar: true,

      // Update the bottomNavigationBar section (around line 100-135)
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withValues(alpha: 0.08),
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Total Amount",
                      style: TextStyle(
                        color: Color(0xff9CA3AF),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Obx(
                      () => Text(
                        "₹${(product.price * controller.quantity).toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffEF4444),
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Obx(
                  () => Container(
                    height: 56,
                    decoration: BoxDecoration(
                      gradient:
                          product.stock <= 0
                              ? const LinearGradient(
                                colors: [Colors.grey, Colors.grey],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              )
                              : const LinearGradient(
                                colors: [Color(0xffEF4444), Color(0xffDC2626)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        if (product.stock > 0)
                          BoxShadow(
                            color: const Color(
                              0xffEF4444,
                            ).withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      icon:
                          controller
                                  .isAddingToCart // Remove .value
                              ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : Icon(
                                product.stock <= 0
                                    ? Iconsax.close_circle
                                    : Iconsax.shopping_bag,
                                size: 22,
                              ),
                      label: Text(
                        product.stock <= 0
                            ? 'Out of Stock'
                            : controller
                                .isAddingToCart // Remove .value
                            ? 'Adding...'
                            : 'Add to Cart',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed:
                          (product.stock > 0 &&
                                  !controller.isAddingToCart) // Remove .value
                              ? () async => await controller.addToCart()
                              : null,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          /// Image Gallery Section with Thumbnails
          SliverAppBar(
            expandedHeight: 450,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                children: [
                  /// Main Image
                  Expanded(
                    flex: 3,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Hero(
                          tag: '${product.id}_${controller.selectedImageIndex}',
                          child: Obx(
                            () => CachedNetworkImage(
                              imageUrl:
                                  product.images[controller.selectedImageIndex],
                              fit: BoxFit.cover,
                              placeholder:
                                  (context, url) => Container(
                                    color: Colors.grey.shade100,
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        color: Color(0xffEF4444),
                                      ),
                                    ),
                                  ),
                              errorWidget:
                                  (context, url, error) => Container(
                                    color: Colors.grey.shade100,
                                    child: const Icon(
                                      Iconsax.image,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  ),
                            ),
                          ),
                        ),
                        // Gradient overlay for better visibility
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.center,
                              colors: [
                                Color.fromRGBO(0, 0, 0, .45),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 80,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Colors.white],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Thumbnail Images (if multiple images)
                  if (product.hasMultipleImages)
                    Container(
                      height: 70,
                      color: Colors.transparent,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        itemCount: product.images.length,
                        itemBuilder: (context, index) {
                          return Obx(
                            () => GestureDetector(
                              onTap: () => controller.selectImage(index),
                              child: Container(
                                width: 55,
                                height: 55,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color:
                                        controller.selectedImageIndex == index
                                            ? const Color(0xffEF4444)
                                            : Colors.grey.shade300,
                                    width:
                                        controller.selectedImageIndex == index
                                            ? 2
                                            : 1,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(7),
                                  child: CachedNetworkImage(
                                    imageUrl: product.images[index],
                                    fit: BoxFit.cover,
                                    placeholder:
                                        (context, url) => Container(
                                          color: Colors.grey.shade100,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
            leading: Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Center(
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 18),
                    color: Colors.black87,
                    onPressed: () => Get.back(),
                  ),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.95),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Obx(
                      () => IconButton(
                        icon: Icon(
                          controller.isInWishlist
                              ? Iconsax.heart5
                              : Iconsax.heart,
                          size: 20,
                        ),
                        color:
                            controller.isInWishlist
                                ? const Color(0xffEF4444)
                                : Colors.grey.shade600,
                        onPressed: controller.toggleWishlist,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          /// Product Details Card
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 25, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Discount & Rating Row
                    Row(
                      children: [
                        if (product.discount > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xff10B981), Color(0xff059669)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.local_offer,
                                  size: 14,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "${product.discount.toInt()}% OFF",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xffFEF3C7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                size: 18,
                                color: Color(0xffF59E0B),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                product.rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xff92400E),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "(${product.reviews})",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Product Name
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                        letterSpacing: -0.5,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Brand & SKU
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xffF3F4F6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Iconsax.tag,
                                size: 14,
                                color: Color(0xff6B7280),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                product.brand,
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xffF3F4F6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Iconsax.barcode,
                                size: 14,
                                color: Color(0xff6B7280),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                product.sku,
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Price Section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xffFEF2F2), Color(0xffFEE2E2)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Price",
                                style: TextStyle(
                                  color: Color(0xff9CA3AF),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    "₹${product.price}",
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xffEF4444),
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  if (product.originalPrice > product.price)
                                    Text(
                                      "₹${product.originalPrice}",
                                      style: const TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        color: Color(0xff9CA3AF),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Iconsax.discount_shape,
                              color: Color(0xffEF4444),
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Stock Status
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color:
                            product.stock > 0
                                ? const Color(0xffF0FDF4)
                                : const Color(0xffFEF2F2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color:
                              product.stock > 0
                                  ? const Color(0xff86EFAC)
                                  : const Color(0xffFECACA),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color:
                                  product.stock > 0
                                      ? const Color(0xff86EFAC)
                                      : const Color(0xffFECACA),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              product.stock > 0
                                  ? Iconsax.tick_circle
                                  : Iconsax.close_circle,
                              color:
                                  product.stock > 0
                                      ? const Color(0xff166534)
                                      : const Color(0xff991B1B),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.stock > 0
                                      ? "In Stock"
                                      : "Out of Stock",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color:
                                        product.stock > 0
                                            ? const Color(0xff166534)
                                            : const Color(0xff991B1B),
                                  ),
                                ),
                                if (product.stock > 0)
                                  Text(
                                    "${product.stock} items available",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xff6B7280),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Weight Variants Section
                    if (product.hasWeightVariants) ...[
                      const SizedBox(height: 24),
                      const Text(
                        "Select Weight",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Obx(
                        () => Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children:
                              product.weightVariants.map((weight) {
                                final isSelected =
                                    controller.selectedWeight == weight;
                                return GestureDetector(
                                  onTap: () => controller.selectWeight(weight),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          isSelected
                                              ? const Color(0xffEF4444)
                                              : Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color:
                                            isSelected
                                                ? const Color(0xffEF4444)
                                                : Colors.grey.shade300,
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      weight,
                                      style: TextStyle(
                                        color:
                                            isSelected
                                                ? Colors.white
                                                : Colors.grey.shade700,
                                        fontWeight:
                                            isSelected
                                                ? FontWeight.bold
                                                : FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Description Section
                    const Text(
                      "Product Description",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xffF9FAFB),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        product.description,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          height: 1.6,
                          fontSize: 15,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Quantity Selector
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xffF9FAFB),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Quantity",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                "Select number of items",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xff9CA3AF),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: controller.decreaseQty,
                                  icon: const Icon(
                                    Icons.remove,
                                    color: Color(0xffEF4444),
                                    size: 20,
                                  ),
                                  style: IconButton.styleFrom(
                                    backgroundColor: const Color(0xffFEF2F2),
                                    shape: const CircleBorder(),
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
                                  child: Obx(
                                    () => Text(
                                      controller.quantity.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: controller.increaseQty,
                                  icon: const Icon(
                                    Icons.add,
                                    color: Color(0xff10B981),
                                    size: 20,
                                  ),
                                  style: IconButton.styleFrom(
                                    backgroundColor: const Color(0xffF0FDF4),
                                    shape: const CircleBorder(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Product Specifications
                    const Text(
                      "Product Specifications",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffF9FAFB),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          buildSpecTile(
                            icon: Iconsax.category,
                            title: "Category",
                            value: product.category,
                          ),
                          const Divider(height: 1, indent: 60),
                          buildSpecTile(
                            icon: Iconsax.bag,
                            title: "Brand",
                            value: product.brand,
                          ),
                          const Divider(height: 1, indent: 60),
                          buildSpecTile(
                            icon: Iconsax.barcode,
                            title: "SKU",
                            value: product.sku,
                          ),
                          const Divider(height: 1, indent: 60),
                          buildSpecTile(
                            icon: Iconsax.star,
                            title: "Rating",
                            value:
                                "${product.rating.toStringAsFixed(1)} / 5.0 (${product.reviews} reviews)",
                          ),
                          if (product.hasWeightVariants) ...[
                            const Divider(height: 1, indent: 60),
                            buildSpecTile(
                              icon: Iconsax.weight,
                              title: "Available Weights",
                              value: product.weightVariantsDisplay,
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSpecTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Icon(icon, size: 20, color: const Color(0xffEF4444)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xff9CA3AF),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
