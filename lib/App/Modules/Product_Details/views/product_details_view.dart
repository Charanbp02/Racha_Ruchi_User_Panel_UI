// lib/App/Modules/Product_Details/views/product_details_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/Product_Details/controller/product_details_controller.dart';
import 'package:racharuchi/App/Modules/Product_Details/widgets/bottom_add_to_cart_bar.dart';
import 'package:racharuchi/App/Modules/Product_Details/widgets/product_description.dart';
import 'package:racharuchi/App/Modules/Product_Details/widgets/product_image_gallery.dart';
import 'package:racharuchi/App/Modules/Product_Details/widgets/product_info_card.dart';
import 'package:racharuchi/App/Modules/Product_Details/widgets/product_specifications.dart';
import 'package:racharuchi/App/Modules/Product_Details/widgets/quantity_selector.dart';
import 'package:racharuchi/App/Modules/Product_Details/widgets/weight_variants_selector.dart';

class ProductDetailsView extends GetView<ProductDetailsController> {
  const ProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final product = controller.productModel.product;

    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
      extendBodyBehindAppBar: true,
      bottomNavigationBar: BottomAddToCartBar(controller: controller),
      body: CustomScrollView(
        slivers: [
          ProductImageGallery(controller: controller),
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
                    ProductInfoCard(
                      name: product.name,
                      brand: product.brand,
                      sku: product.sku,
                      price: product.price,
                      originalPrice: product.originalPrice,
                      discount: product.discount,
                      rating: product.rating,
                      reviews: product.reviews,
                      stock: product.stock,
                    ),
                    const SizedBox(height: 24),
                    if (product.hasWeightVariants) ...[
                      WeightVariantsSelector(controller: controller),
                      const SizedBox(height: 24),
                    ],
                    ProductDescription(description: product.description),
                    const SizedBox(height: 24),
                    QuantitySelector(controller: controller),
                    const SizedBox(height: 24),
                    ProductSpecifications(
                      category: product.category,
                      brand: product.brand,
                      sku: product.sku,
                      rating: product.rating,
                      reviews: product.reviews,
                      hasWeightVariants: product.hasWeightVariants,
                      weightVariantsDisplay: product.weightVariantsDisplay,
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
}
