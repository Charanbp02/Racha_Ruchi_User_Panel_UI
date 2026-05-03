import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/My_Recipes/controller/my_recipes_controller.dart';

class MyRecipesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyRecipesController>(() => MyRecipesController(), fenix: true);
  }
}
