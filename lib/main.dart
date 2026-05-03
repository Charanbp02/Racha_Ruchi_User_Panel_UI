import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racharuchi/App/Routes/app_pages.dart';
import 'package:racharuchi/App/Routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Racha Ruchi',

      // Initial Route
      initialRoute: AppRoutes.INITIAL,

      // App Pages
      getPages: AppPages.routes,
    );
  }
}