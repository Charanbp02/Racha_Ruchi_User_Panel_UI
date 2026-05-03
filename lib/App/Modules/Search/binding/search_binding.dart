import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/Search/controller/search_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchBarController>(() => SearchBarController(), fenix: true);
  }
}
