import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Custom/appBar.dart';
import 'package:racharuchi/App/Modules/Banner/view/hero_banner_view.dart';
import 'package:racharuchi/App/Modules/Categories/view/category_view.dart';
import 'package:racharuchi/App/Modules/Home/Controller/Home_Controller.dart';
import 'package:racharuchi/App/Modules/Popular_Recipes/view/popular_recipes_view.dart';
import 'package:racharuchi/App/Modules/Search/view/search_bar_view.dart';
import 'package:racharuchi/App/Modules/Top_Recipe_Video/view/top_recipes_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: const CustomAppBar(title: "Racha Ruchi"),
      body: Column(
        children: [
          // SearchBar - Fixed (doesn't scroll)
          const SearchBarView(),
          const SizedBox(height: 5),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  const CategorySectionView(),
                  const SizedBox(height: 16),
                  const HeroBannerView(),
                  const SizedBox(height: 16),
                  const TopRecipeVideosSection(),
                  const SizedBox(height: 16),
                  const PopularRecipesSection(),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your AI functionality here
          Get.snackbar(
            'AI Assistant',
            'AI feature coming soon!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.black87,
            colorText: Colors.white,
            icon: const Icon(Iconsax.cpu, color: Colors.white),
            duration: const Duration(seconds: 2),
          );
        },
        backgroundColor: const Color(0xFFE53935),
        elevation: 4,
        child: const Icon(Iconsax.magicpen, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
