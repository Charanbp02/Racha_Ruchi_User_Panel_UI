// lib/App/Modules/Home/widgets/home_search_bar.dart
import 'package:flutter/material.dart';
import 'package:racharuchi/App/Modules/Search/view/search_bar_view.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: SearchBarView(),
    );
  }
}
