import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/Top_Recipe_Video/controller/top_recipes_controller.dart';

class TopRecipeVideosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TopRecipesController>(
      () => TopRecipesController(),
      fenix: true,
    );
  }
}
