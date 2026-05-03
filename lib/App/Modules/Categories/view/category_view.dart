import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/Categories/controller/category_controller.dart';

class CategorySectionView extends StatelessWidget {
  const CategorySectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final CategoryController controller = Get.put(CategoryController());

    return Obx(
      () => SizedBox(
        height: 50,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: controller.categories.length,
          itemBuilder: (context, index) {
            final category = controller.categories[index];
            final isSelected = controller.selectedIndex.value == index;

            return GestureDetector(
              onTap: () => controller.selectCategory(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFE53935) : Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color:
                        isSelected ? Colors.transparent : Colors.grey.shade200,
                    width: 1,
                  ),
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(
                        color: const Color(0xFFE53935).withOpacity(0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      )
                    else
                      BoxShadow(
                        color: Colors.grey.shade100,
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                  ],
                ),
                child: Row(
                  children: [
                    Text(
                      category['icon']!,
                      style: TextStyle(
                        fontSize: 18,
                        color:
                            isSelected ? Colors.white : const Color(0xFFE53935),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      category['name']!,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
