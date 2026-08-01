// lib/App/Modules/Product_Details/widgets/product_image_gallery.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iconsax/iconsax.dart';
import '../controller/product_details_controller.dart';

class ProductImageGallery extends StatelessWidget {
  final ProductDetailsController controller;

  const ProductImageGallery({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final product = controller.productModel.product;

    return SliverAppBar(
      expandedHeight: 450,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Column(
          children: [
            // Main Image
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
                            product.images[controller
                                .selectedImageIndex], // Use getter without .value
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
            // Thumbnails
            if (product.hasMultipleImages) _buildThumbnails(product.images),
          ],
        ),
      ),
      leading: _buildBackButton(),
      actions: [_buildWishlistButton(controller)],
    );
  }

  Widget _buildThumbnails(List<String> images) {
    return Container(
      height: 70,
      color: Colors.transparent,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: images.length,
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
                        controller.selectedImageIndex ==
                                index // Use getter without .value
                            ? const Color(0xffEF4444)
                            : Colors.grey.shade300,
                    width:
                        controller.selectedImageIndex == index
                            ? 2
                            : 1, // Use getter without .value
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: CachedNetworkImage(
                    imageUrl: images[index],
                    fit: BoxFit.cover,
                    placeholder:
                        (context, url) =>
                            Container(color: Colors.grey.shade100),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBackButton() {
    return Padding(
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
    );
  }

  Widget _buildWishlistButton(ProductDetailsController controller) {
    return Padding(
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
                    : Iconsax.heart, // Use getter without .value
                size: 20,
              ),
              color:
                  controller
                          .isInWishlist // Use getter without .value
                      ? const Color(0xffEF4444)
                      : Colors.grey.shade600,
              onPressed: controller.toggleWishlist,
            ),
          ),
        ),
      ),
    );
  }
}
