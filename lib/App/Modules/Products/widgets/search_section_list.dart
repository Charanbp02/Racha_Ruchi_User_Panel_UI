// lib/App/Modules/Products/widgets/search_section_list.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Modules/Products/controller/products_controller.dart';
import 'package:racharuchi/App/Modules/Products/widgets/search_section_header.dart';

class SearchSectionList extends StatelessWidget {
  final ProductsController controller;

  const SearchSectionList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.searchQuery.value.isEmpty) {
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      }

      final sections = <Widget>[];

      if (controller.exactMatchProducts.isNotEmpty) {
        sections.add(
          SearchSectionHeader(
            title: 'Exact Matches',
            icon: Iconsax.star1,
            color: Colors.green,
            count: controller.exactMatchProducts.length,
          ),
        );
      }

      if (controller.startsWithProducts.isNotEmpty) {
        sections.add(
          SearchSectionHeader(
            title: 'Starts With',
            icon: Iconsax.direct_right,
            color: Colors.orange,
            count: controller.startsWithProducts.length,
          ),
        );
      }

      if (controller.containsProducts.isNotEmpty) {
        sections.add(
          SearchSectionHeader(
            title: 'Contains',
            icon: Iconsax.search_normal,
            color: Colors.purple,
            count: controller.containsProducts.length,
          ),
        );
      }

      return SliverList(delegate: SliverChildListDelegate(sections));
    });
  }
}
