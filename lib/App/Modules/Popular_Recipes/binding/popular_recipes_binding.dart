import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/Popular_Recipes/controller/popular_recipes_controller.dart';

class PopularRecipesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PopularRecipesController>(
      () => PopularRecipesController(),
      fenix: true,
    );
  }
}
