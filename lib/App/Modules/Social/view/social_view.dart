import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:racharuchi/App/Models/Social_Model/social_model.dart';
import 'package:racharuchi/App/Modules/Social/controller/social_controller.dart';

class SocialView extends StatelessWidget {
  final bool showFollowers;

  const SocialView({super.key, this.showFollowers = true});

  @override
  Widget build(BuildContext context) {
    final SocialController controller = Get.put(SocialController());

    // Set initial tab based on parameter
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (showFollowers) {
        controller.selectedTab.value = 0;
      } else {
        controller.selectedTab.value = 1;
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Obx(
          () => Text(
            controller.selectedTab.value == 0 ? 'Followers' : 'Following',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xFF2D2D2D),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left, color: Color(0xFF2D2D2D)),
          onPressed: () => Get.back(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Column(
            children: [
              // Search Bar
              _buildSearchBar(controller),
              const SizedBox(height: 8),
              // Tab Bar
              _buildTabBar(controller),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFE53935)),
          );
        }

        if (controller.filteredUsers.isEmpty) {
          return _buildEmptyState(controller);
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.filteredUsers.length,
          itemBuilder: (context, index) {
            final user = controller.filteredUsers[index];
            return _buildUserCard(user, controller);
          },
        );
      }),
    );
  }

  Widget _buildSearchBar(SocialController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        onChanged: (value) => controller.searchUsers(value),
        decoration: InputDecoration(
          hintText: 'Search users...',
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          prefixIcon: const Icon(
            Iconsax.search_normal,
            size: 20,
            color: Colors.grey,
          ),
          suffixIcon:
              controller.searchQuery.value.isNotEmpty
                  ? IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () => controller.clearSearch(),
                  )
                  : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFE53935), width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildTabBar(SocialController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          _buildTabItem(controller, 'Followers', 0),
          _buildTabItem(controller, 'Following', 1),
        ],
      ),
    );
  }

  Widget _buildTabItem(SocialController controller, String title, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeTab(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color:
                controller.selectedTab.value == index
                    ? const Color(0xFFE53935)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color:
                    controller.selectedTab.value == index
                        ? Colors.white
                        : Colors.grey.shade600,
                fontWeight:
                    controller.selectedTab.value == index
                        ? FontWeight.w600
                        : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard(UserModel user, SocialController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => controller.viewUserProfile(user),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: CachedNetworkImage(
                    imageUrl: user.imageUrl,
                    width: 55,
                    height: 55,
                    fit: BoxFit.cover,
                    placeholder:
                        (context, url) => Container(
                          width: 55,
                          height: 55,
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                    errorWidget:
                        (context, url, error) => Container(
                          width: 55,
                          height: 55,
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.person,
                            size: 30,
                            color: Colors.grey,
                          ),
                        ),
                  ),
                ),
                const SizedBox(width: 12),

                // User Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF2D2D2D),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user.username,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.bio,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF666666),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Iconsax.document,
                            size: 10,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${user.recipes}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Iconsax.heart,
                            size: 10,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            user.followers,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Follow Button
                SizedBox(
                  width: 85,
                  height: 32,
                  child: ElevatedButton(
                    onPressed: () => controller.toggleFollow(user.id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          user.isFollowing
                              ? Colors.grey.shade200
                              : const Color(0xFFE53935),
                      foregroundColor:
                          user.isFollowing
                              ? Colors.grey.shade700
                              : Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(
                      user.isFollowing ? 'Following' : 'Follow',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(SocialController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFE53935).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              controller.selectedTab.value == 0
                  ? Iconsax.profile_2user
                  : Iconsax.user_add,
              size: 60,
              color: const Color(0xFFE53935),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            controller.selectedTab.value == 0
                ? 'No Followers Yet'
                : 'No Following Yet',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D2D2D),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            controller.selectedTab.value == 0
                ? 'When someone follows you, they\'ll appear here'
                : 'When you follow someone, they\'ll appear here',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          if (controller.selectedTab.value == 1)
            ElevatedButton(
              onPressed: () {
                Get.toNamed('/discover');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE53935),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Discover People'),
            ),
        ],
      ),
    );
  }
}
