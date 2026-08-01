// lib/App/Modules/Home/widgets/home_content.dart
import 'package:flutter/material.dart';
import 'package:racharuchi/App/Modules/Banner/view/hero_banner_view.dart';

import 'package:racharuchi/App/Modules/All_Videos/view/videos_view.dart';
import 'package:racharuchi/App/Modules/Categories/view/category_view.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Categories Section
          const CategorySectionView(),

          const SizedBox(height: 10),

          // Hero Banner
          const HeroBannerView(),

          // Videos Section
          const VideosView(embedded: true),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
