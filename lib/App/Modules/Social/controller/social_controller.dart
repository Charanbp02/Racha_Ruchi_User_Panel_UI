import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racharuchi/App/Models/Social_Model/social_model.dart';

class SocialController extends GetxController {
  var isLoading = false.obs;
  var selectedTab = 0.obs; // 0 = Followers, 1 = Following

  var followers = <UserModel>[].obs;
  var following = <UserModel>[].obs;
  var filteredUsers = <UserModel>[].obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadFollowers();
    loadFollowing();
  }

  void loadFollowers() {
    isLoading.value = true;

    // Simulate API call
    Future.delayed(const Duration(milliseconds: 500), () {
      followers.value = [
        UserModel(
          id: '1',
          name: 'Chef Sanjeev Kapoor',
          username: '@sanjeevkapoor',
          imageUrl: 'https://randomuser.me/api/portraits/men/11.jpg',
          bio: 'Master Chef | Food Blogger | 2M+ Followers',
          recipes: 245,
          followers: '2.1M',
          isFollowing: true,
        ),
        UserModel(
          id: '2',
          name: 'Priya Reddy',
          username: '@priya_cooks',
          imageUrl: 'https://randomuser.me/api/portraits/women/12.jpg',
          bio: 'South Indian Food Specialist | Recipe Creator',
          recipes: 89,
          followers: '45.2K',
          isFollowing: true,
        ),
        UserModel(
          id: '3',
          name: 'Vikas Khanna',
          username: '@vikaskhanna',
          imageUrl: 'https://randomuser.me/api/portraits/men/13.jpg',
          bio: 'Michelin Star Chef | Author | Restaurateur',
          recipes: 156,
          followers: '3.4M',
          isFollowing: false,
        ),
        UserModel(
          id: '4',
          name: 'Tarla Dalal',
          username: '@tarladalal',
          imageUrl: 'https://randomuser.me/api/portraits/women/14.jpg',
          bio: 'Iconic Indian Chef | Cookbook Author',
          recipes: 1200,
          followers: '5.2M',
          isFollowing: true,
        ),
        UserModel(
          id: '5',
          name: 'Ranveer Brar',
          username: '@ranveerbrar',
          imageUrl: 'https://randomuser.me/api/portraits/men/15.jpg',
          bio: 'Chef | TV Host | Food Storyteller',
          recipes: 234,
          followers: '2.8M',
          isFollowing: false,
        ),
      ];
      applyFilter();
      isLoading.value = false;
    });
  }

  void loadFollowing() {
    following.value = [
      UserModel(
        id: '1',
        name: 'Chef Sanjeev Kapoor',
        username: '@sanjeevkapoor',
        imageUrl: 'https://randomuser.me/api/portraits/men/11.jpg',
        bio: 'Master Chef | Food Blogger | 2M+ Followers',
        recipes: 245,
        followers: '2.1M',
        isFollowing: true,
      ),
      UserModel(
        id: '2',
        name: 'Priya Reddy',
        username: '@priya_cooks',
        imageUrl: 'https://randomuser.me/api/portraits/women/12.jpg',
        bio: 'South Indian Food Specialist | Recipe Creator',
        recipes: 89,
        followers: '45.2K',
        isFollowing: true,
      ),
      UserModel(
        id: '4',
        name: 'Tarla Dalal',
        username: '@tarladalal',
        imageUrl: 'https://randomuser.me/api/portraits/women/14.jpg',
        bio: 'Iconic Indian Chef | Cookbook Author',
        recipes: 1200,
        followers: '5.2M',
        isFollowing: true,
      ),
    ];
    applyFilter();
  }

  void changeTab(int index) {
    selectedTab.value = index;
    applyFilter();
  }

  void searchUsers(String query) {
    searchQuery.value = query;
    applyFilter();
  }

  void clearSearch() {
    searchQuery.value = '';
    applyFilter();
  }

  void applyFilter() {
    if (selectedTab.value == 0) {
      if (searchQuery.value.isEmpty) {
        filteredUsers.value = followers.toList();
      } else {
        filteredUsers.value =
            followers
                .where(
                  (user) =>
                      user.name.toLowerCase().contains(
                        searchQuery.value.toLowerCase(),
                      ) ||
                      user.username.toLowerCase().contains(
                        searchQuery.value.toLowerCase(),
                      ),
                )
                .toList();
      }
    } else {
      if (searchQuery.value.isEmpty) {
        filteredUsers.value = following.toList();
      } else {
        filteredUsers.value =
            following
                .where(
                  (user) =>
                      user.name.toLowerCase().contains(
                        searchQuery.value.toLowerCase(),
                      ) ||
                      user.username.toLowerCase().contains(
                        searchQuery.value.toLowerCase(),
                      ),
                )
                .toList();
      }
    }
  }

  void toggleFollow(String userId) {
    if (selectedTab.value == 0) {
      final index = followers.indexWhere((user) => user.id == userId);
      if (index != -1) {
        followers[index].isFollowing = !followers[index].isFollowing;
        if (followers[index].isFollowing) {
          followers[index].followers = _incrementCount(
            followers[index].followers,
          );
        } else {
          followers[index].followers = _decrementCount(
            followers[index].followers,
          );
        }
        followers.refresh(); // ✅ Fixed: Call refresh on RxList
        applyFilter();

        Get.snackbar(
          followers[index].isFollowing ? 'Following' : 'Unfollowed',
          followers[index].isFollowing
              ? 'You are now following ${followers[index].name}'
              : 'You unfollowed ${followers[index].name}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor:
              followers[index].isFollowing ? Colors.green : Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
      final index = following.indexWhere((user) => user.id == userId);
      if (index != -1) {
        following[index].isFollowing = !following[index].isFollowing;
        if (following[index].isFollowing) {
          following[index].followers = _incrementCount(
            following[index].followers,
          );
        } else {
          following[index].followers = _decrementCount(
            following[index].followers,
          );
        }
        following.refresh(); // ✅ Fixed: Call refresh on RxList
        applyFilter();

        Get.snackbar(
          following[index].isFollowing ? 'Following' : 'Unfollowed',
          following[index].isFollowing
              ? 'You are now following ${following[index].name}'
              : 'You unfollowed ${following[index].name}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor:
              following[index].isFollowing ? Colors.green : Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  String _incrementCount(String count) {
    if (count.contains('K')) {
      int num = int.parse(count.replaceAll('K', ''));
      return '${num + 1}K';
    } else if (count.contains('M')) {
      double num = double.parse(count.replaceAll('M', ''));
      return '${(num + 0.001).toStringAsFixed(1)}M';
    }
    return '${int.parse(count) + 1}';
  }

  String _decrementCount(String count) {
    if (count.contains('K')) {
      int num = int.parse(count.replaceAll('K', ''));
      return '${num - 1}K';
    } else if (count.contains('M')) {
      double num = double.parse(count.replaceAll('M', ''));
      return '${(num - 0.001).toStringAsFixed(1)}M';
    }
    return '${int.parse(count) - 1}';
  }

  void viewUserProfile(UserModel user) {
    Get.toNamed('/user-profile', arguments: user);
  }
}

