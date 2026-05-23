// main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:media_kit/media_kit.dart';
import 'package:racharuchi/App/Routes/app_pages.dart';
import 'package:racharuchi/App/Routes/app_routes.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize MediaKit (MUST be called before any video playback)
  MediaKit.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize Hive for caching
  await Hive.initFlutter();
  await Hive.openBox('video_metadata');

  // Initialize Firebase with options
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Test Firebase Storage connection
  try {
    final storage = FirebaseStorage.instance;
    await storage.ref().child('test').list();
    print('✅ Firebase Storage connected successfully');
  } catch (e) {
    print('❌ Firebase Storage error: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Racha Ruchi',

      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF2D2D2D)),
        ),
      ),

      initialRoute: AppRoutes.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
