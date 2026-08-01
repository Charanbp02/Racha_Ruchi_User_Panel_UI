// lib/App/Modules/Home/Controller/home_controller.dart
import 'package:get/get.dart';

class HomeController extends GetxController {
  // Observables
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt selectedCategoryIndex = 0.obs;

  // Methods
  void onCategorySelected(int index) {
    selectedCategoryIndex.value = index;
  }

  void refreshHome() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Add your refresh logic here
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToAIChat() {
    // Navigation logic handled in view
  }
}
