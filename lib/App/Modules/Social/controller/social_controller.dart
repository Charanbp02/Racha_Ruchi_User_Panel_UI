import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:racharuchi/App/Models/Social_Model/social_model.dart';

class SocialController extends GetxController {
  var isLoading = false.obs;

  var selectedTab = 0.obs; // 0 = Followers, 1 = Following

  var followers = <UserModel>[].obs;
  var following = <UserModel>[].obs;
  var filteredUsers = <UserModel>[].obs;
  var searchQuery = ''.obs;

  final int initialTab;
  final RxSet<String> myFollowersSet = <String>{}.obs;

  SocialController({required this.initialTab});

  @override
  void onInit() {
    super.onInit();

    selectedTab.value = initialTab;

    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      loadFollowers(userId);
      loadFollowing(userId);
      loadMyFollowers(userId); // 🔥 ADD THIS
    }
  }

  Future<void> loadMyFollowers(String myUserId) async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(myUserId)
            .collection('followers')
            .get();

    myFollowersSet.value = snapshot.docs.map((e) => e.id).toSet();
  }

  Future<void> loadFollowers(String userId) async {
    isLoading.value = true;

    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('followers')
            .get();

    List<UserModel> temp = [];

    for (var doc in snapshot.docs) {
      final followerId = doc.id;

      final userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(followerId)
              .get();

      final data = userDoc.data();

      if (data == null) continue;

      // 🔥 CHECK: does THIS user follow me back?
      final myFollowingDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUserId)
              .collection('following')
              .doc(followerId)
              .get();

      bool isFollowingBack = myFollowingDoc.exists;

      temp.add(
        UserModel(
          id: followerId,
          name: data['name'] ?? '',
          username: data['username'] ?? '',
          imageUrl: data['imageUrl'] ?? '',
          bio: data['bio'] ?? '',
          recipes: (data['recipes_video'] ?? 0) as int,
          followers: data['followers']?.toString() ?? '0',

          // 🔥 IMPORTANT FIX
          isFollowing: isFollowingBack,
        ),
      );
    }

    followers.value = temp;
    applyFilter();
    isLoading.value = false;
  }

  Future<void> loadFollowing(String userId) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('following')
            .get();

    List<UserModel> temp = [];

    for (var doc in snapshot.docs) {
      final followingId = doc.id;

      final userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(followingId)
              .get();

      final data = userDoc.data();

      if (data == null) continue;

      // 🔥 CHECK: does THIS user follow me back?
      final isFollowedBackDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(followingId)
              .collection('followers')
              .doc(currentUserId)
              .get();

      bool isFollowedBack = isFollowedBackDoc.exists;

      temp.add(
        UserModel(
          id: followingId,
          name: data['name'] ?? '',
          username: data['username'] ?? '',
          imageUrl: data['imageUrl'] ?? '',
          bio: data['bio'] ?? '',
          recipes: data['recipes'] ?? 0,
          followers: data['followers']?.toString() ?? '0',

          // 🔥 OPTIONAL (you can use for UI badge)
          isFollowing: true,
        ),
      );
    }

    following.value = temp;
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

  Future<void> toggleFollow(String targetUserId) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    final followingRef = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('following')
        .doc(targetUserId);

    final followerRef = FirebaseFirestore.instance
        .collection('users')
        .doc(targetUserId)
        .collection('followers')
        .doc(currentUserId);

    final doc = await followingRef.get();

    if (doc.exists) {
      await followingRef.delete();
      await followerRef.delete();
    } else {
      try {
        await followingRef.set({
          'followingId': targetUserId,
          'createdAt': FieldValue.serverTimestamp(),
        });

        await followerRef.set({
          'followerId': currentUserId,
          'createdAt': FieldValue.serverTimestamp(),
        });

        print("FOLLOW SUCCESS");
      } catch (e) {
        print("FOLLOW ERROR => $e");
      }
    }
    await loadFollowers(currentUserId);
    await loadFollowing(currentUserId);
    await loadMyFollowers(currentUserId);

    applyFilter();
    update();

    print("Followers count => ${followers.length}");
    print("Following count => ${following.length}");
    print("My followers => ${myFollowersSet.length}");
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
