// lib/App/Modules/BottomNav/widgets/nav_pages.dart
import 'package:flutter/material.dart';
import 'package:racharuchi/App/Modules/Home/View/Home_view.dart';
import 'package:racharuchi/App/Modules/Products/view/products_view.dart';
import 'package:racharuchi/App/Modules/Profile/view/profile_view.dart';

class NavPages extends StatelessWidget {
  final int currentIndex;

  const NavPages({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: currentIndex,
      children: const [
        HomeView(),
        SizedBox.shrink(), // Placeholder for Upload (handled by bottom sheet)
        ProductsView(),
        ProfileView(),
      ],
    );
  }
}
