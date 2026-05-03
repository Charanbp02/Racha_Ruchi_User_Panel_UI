import 'package:get/get.dart';

class StatsController extends GetxController {
  var isLoading = false.obs;

  // User Stats
  var totalRecipes = '24'.obs;
  var totalFollowers = '1.2k'.obs;
  var totalFollowing = '345'.obs;
  var totalLikes = '2.3k'.obs;
  var totalViews = '45.6k'.obs;
  var totalComments = '1.8k'.obs;
  var totalShares = '892'.obs;
  var totalSaved = '456'.obs;

  @override
  void onInit() {
    super.onInit();
    loadStats();
  }

  void loadStats() {
    isLoading.value = true;

    Future.delayed(const Duration(milliseconds: 500), () {
      isLoading.value = false;
    });
  }

  void refreshStats() {
    loadStats();
  }
}
