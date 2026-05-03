import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:racharuchi/App/Modules/Products/controller/products_controller.dart';

class ProductsView extends StatelessWidget {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductsController controller = Get.put(ProductsController());

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Products',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                controller.isGridView.value ? Iconsax.menu_1 : Iconsax.grid_5,
              ),
              onPressed: () => controller.toggleView(),
            ),
          ),
        ],
      ),
      body: Obx(
        () => Column(
          children: [
            // Categories
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.categories.length,
                itemBuilder: (context, index) {
                  final category = controller.categories[index];
                  final isSelected =
                      controller.selectedCategory.value == category;

                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (_) => controller.changeCategory(category),
                      backgroundColor: Colors.white,
                      selectedColor: Colors.red.shade50,
                      side: BorderSide(
                        color: isSelected ? Colors.red : Colors.grey.shade300,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Products
            Expanded(
              child:
                  controller.filteredProducts.isEmpty
                      ? const Center(child: Text('No products found'))
                      : controller.isGridView.value
                      ? GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.7,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                        itemCount: controller.filteredProducts.length,
                        itemBuilder:
                            (context, index) => _buildProductCard(
                              controller.filteredProducts[index],
                              controller,
                            ),
                      )
                      : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: controller.filteredProducts.length,
                        itemBuilder:
                            (context, index) => _buildProductListTile(
                              controller.filteredProducts[index],
                              controller,
                            ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(
    Map<String, dynamic> product,
    ProductsController controller,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: CachedNetworkImage(
                imageUrl: product['image'],
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder:
                    (context, url) => Container(
                      color: Colors.grey.shade200,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                errorWidget:
                    (context, url, error) => Container(
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.error, color: Colors.red),
                    ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Iconsax.star1, color: Colors.amber, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      product['rating'].toString(),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  product['price'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.snackbar(
                        'Added',
                        '${product['name']} added to cart',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        duration: const Duration(seconds: 1),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Add to Cart',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductListTile(
    Map<String, dynamic> product,
    ProductsController controller,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 4)],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: product['image'],
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              placeholder:
                  (context, url) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey.shade200,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              errorWidget:
                  (context, url, error) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.error),
                  ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Iconsax.star1, color: Colors.amber, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      product['rating'].toString(),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  product['price'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.snackbar(
                'Added',
                '${product['name']} added to cart',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
                duration: const Duration(seconds: 1),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Buy'),
          ),
        ],
      ),
    );
  }
}
