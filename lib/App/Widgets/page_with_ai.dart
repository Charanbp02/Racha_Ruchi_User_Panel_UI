import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/AIFloatingButton/binding/ai_floating_binding.dart';
import 'package:racharuchi/App/Modules/AIFloatingButton/controller/ai_floating_controller.dart';
import 'package:racharuchi/App/Modules/AIFloatingButton/view/ai_floating_view.dart';

class PageWithAI extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final Color? backgroundColor;
  final Widget? bottomNavigationBar;
  final bool resizeToAvoidBottomInset;

  const PageWithAI({
    super.key,
    required this.child,
    this.appBar,
    this.backgroundColor,
    this.bottomNavigationBar,
    this.resizeToAvoidBottomInset = true,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize AI Floating Button binding for this page
    if (!Get.isRegistered<AIFloatingController>()) {
      AIFloatingBinding().dependencies();
    }

    return Scaffold(
      appBar: appBar,
      backgroundColor: backgroundColor ?? Colors.white,
      body: child,
      bottomNavigationBar: bottomNavigationBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      floatingActionButton: const AIFloatingView(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
