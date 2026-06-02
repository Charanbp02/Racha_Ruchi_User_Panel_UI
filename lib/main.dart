import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:media_kit/media_kit.dart';
import 'package:racharuchi/App/Modules/Upload/controller/upload_controller.dart';
import 'package:racharuchi/App/Routes/app_pages.dart';
import 'package:racharuchi/App/Routes/app_routes.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env file safely
  try {
    await dotenv.load();
    debugPrint('✅ .env file loaded successfully');
  } catch (e) {
    debugPrint('⚠️ .env file not found: $e');
    debugPrint(
      'Continuing without .env file. Use hardcoded keys or add .env file.',
    );
  }

  // Media Kit
  MediaKit.ensureInitialized();

  // Firebase Initialize (ONLY ONCE)
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Hive Initialize
  await Hive.initFlutter();
  await Hive.openBox('video_metadata');

  // Firebase Storage Test
  try {
    final storage = FirebaseStorage.instance;
    await storage.ref().child('test').list();
    debugPrint('✅ Firebase Storage connected successfully');
  } catch (e) {
    debugPrint('❌ Firebase Storage error: $e');
  }

  // Register globally
  Get.put(UploadController(), permanent: true);

  print(Firebase.app().options.projectId);

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
      initialRoute: AppRoutes.SPLASH,
      getPages: AppPages.routes,
    );
  }
}
