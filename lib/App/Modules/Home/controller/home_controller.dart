import 'package:get/get.dart';

class HomeController extends GetxController {
  // 🔹 Dummy Product List
  var productList = <String>["Shirt 1", "Shirt 2", "Shirt 3", "Shirt 4"].obs;

  void toggleFavorite(int index) {
    Get.snackbar("Clicked", productList[index]);
  }
}
