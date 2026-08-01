// lib/App/Modules/BottomNav/view/bottom_nav_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/BottomNav/controller/bottom_nav_controller.dart';
import 'package:racharuchi/App/Modules/BottomNav/widgets/bottom_nav_scaffold.dart';

class BottomNavView extends StatelessWidget {
  const BottomNavView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(BottomNavController(), permanent: true);

    return const BottomNavScaffold();
  }
}
