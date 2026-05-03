import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/Stats/controller/stats_controller.dart';

class StatsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StatsController>(() => StatsController(), fenix: true);
  }
}
