import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:racharuchi/App/Modules/About/view/about_view.dart';
import 'package:racharuchi/App/Modules/AddressBook/view/address_view.dart';
import 'package:racharuchi/App/Modules/Coupons/view/coupons_view.dart';
import 'package:racharuchi/App/Modules/HelpSupport/view/help_support_view.dart';
import 'package:racharuchi/App/Modules/MyOrders/view/order_view.dart';
import 'package:racharuchi/App/Modules/My_Recipes/view/my_recipes_view.dart';
import 'package:racharuchi/App/Modules/Notifications/view/notification_view.dart';
import 'package:racharuchi/App/Modules/PrivacyPolicy/view/privacy_policy_view.dart';
import 'package:racharuchi/App/Modules/Profile/controller/profile_controller.dart';
import 'package:racharuchi/App/Modules/Social/view/social_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Color(0xFF2D2D2D),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                controller.isEditing.value ? Iconsax.save_2 : Iconsax.edit_2,
                color: const Color(0xFFE53935),
              ),
              onPressed: () => controller.toggleEditMode(),
            ),
          ),
        ],
      ),
      body: Obx(
        () =>
            controller.isLoading.value
                ? const Center(
                  child: CircularProgressIndicator(color: Color(0xFFE53935)),
                )
                : SingleChildScrollView(
                  child: Column(
                    children: [
                      // Profile Header
                      _buildProfileHeader(controller),
                      const SizedBox(height: 16),

                      // Stats Section
                      _buildStatsSection(controller),
                      const SizedBox(height: 16),

                      // Menu Items
                      _buildMenuItems(controller),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
      ),
    );
  }

  Widget _buildProfileHeader(ProfileController controller) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 20),

          // Profile Image
          GestureDetector(
            onTap: () => _showImagePickerDialog(controller),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: CachedNetworkImage(
                      imageUrl: controller.userImage.value,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      placeholder:
                          (context, url) => Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFFE53935),
                              ),
                            ),
                          ),
                      errorWidget:
                          (context, url, error) => Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey.shade200,
                            child: const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53935),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Iconsax.camera,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // User Name
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.userName.value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D2D2D),
                  ),
                ),
                if (controller.isEditing.value)
                  IconButton(
                    icon: const Icon(
                      Iconsax.edit,
                      size: 18,
                      color: Color(0xFFE53935),
                    ),
                    onPressed:
                        () => controller.editField(
                          'Name',
                          controller.userName.value,
                        ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),

          // User Email
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.userEmail.value,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                if (controller.isEditing.value)
                  IconButton(
                    icon: const Icon(
                      Iconsax.edit,
                      size: 16,
                      color: Color(0xFFE53935),
                    ),
                    onPressed:
                        () => controller.editField(
                          'Email',
                          controller.userEmail.value,
                        ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),

          // User Phone
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.userPhone.value,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                if (controller.isEditing.value)
                  IconButton(
                    icon: const Icon(
                      Iconsax.edit,
                      size: 16,
                      color: Color(0xFFE53935),
                    ),
                    onPressed:
                        () => controller.editField(
                          'Phone',
                          controller.userPhone.value,
                        ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Edit Profile Button
          if (!controller.isEditing.value)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => controller.toggleEditMode(),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE53935)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(color: Color(0xFFE53935)),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStatsSection(ProfileController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Recipes - Navigate to My Recipes
          _buildStatItemWithTap(
            controller.recipes.value,
            'Recipes',
            Iconsax.document,
            onTap: () => Get.to(() => const MyRecipesView()),
          ),
          _buildDivider(),

          // Followers - Navigate to Followers page
          _buildStatItemWithTap(
            controller.followers.value,
            'Followers',
            Iconsax.user,
            onTap: () => Get.to(() => const SocialView(showFollowers: true)),
          ),
          _buildDivider(),

          // Following - Navigate to Following page
          _buildStatItemWithTap(
            controller.following.value,
            'Following',
            Iconsax.user_add,
            onTap: () => Get.to(() => const SocialView(showFollowers: false)),
          ),
        ],
      ),
    );
  }

  // ✅ Single _buildStatItemWithTap method (with onTap)
  Widget _buildStatItemWithTap(
    String value,
    String label,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 24, color: const Color(0xFFE53935)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D2D2D),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 40, color: Colors.grey.shade200);
  }

  Widget _buildMenuItems(ProfileController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Settings',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D2D2D),
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.menuItems.length,
            itemBuilder: (context, index) {
              final item = controller.menuItems[index];
              final isLogout = item['title'] == 'Logout';

              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      _handleMenuItemTap(item, controller);
                    },
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color:
                              isLogout
                                  ? Colors.red.withValues(alpha: 0.1)
                                  : const Color(
                                    0xFFE53935,
                                  ).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          _getIconForMenuItem(item['title']),
                          size: 20,
                          color:
                              isLogout ? Colors.red : const Color(0xFFE53935),
                        ),
                      ),
                      title: Text(
                        item['title'],
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color:
                              isLogout ? Colors.red : const Color(0xFF2D2D2D),
                        ),
                      ),
                      trailing: Icon(
                        Iconsax.arrow_right_3,
                        size: 18,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _handleMenuItemTap(
    Map<String, dynamic> item,
    ProfileController controller,
  ) {
    final String title = item['title'];

    switch (title) {
      case 'My Orders':
        Get.to(() => const OrderView());
        break;
      case 'My Recipes':
        Get.to(() => const MyRecipesView());
        break;
      case 'Coupons':
        Get.to(() => const CouponsView());
        break;
      case 'Address Book':
        Get.to(() => const AddressBookView());
        break;
      case 'Notifications':
        Get.to(() => const NotificationView());
        break;
      case 'Help & Support':
        Get.to(() => const HelpSupportView());
        break;
      case 'Privacy Policy':
        Get.to(() => const PrivacyPolicyView());
        break;
      case "About Us":
        Get.to(() => const AboutView());
      case 'Logout':
        _showLogoutDialog(controller);
        break;
      default:
        controller.onMenuItemTap(item);
        break;
    }
  }

  void _showLogoutDialog(ProfileController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.logout();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  IconData _getIconForMenuItem(String title) {
    switch (title) {
      case 'My Orders':
        return Iconsax.shopping_bag;
      case 'My Recipes':
        return Iconsax.document;
      case 'Coupons':
        return Iconsax.discount_circle;
      case 'Address Book':
        return Iconsax.location;
      case 'Notifications':
        return Iconsax.notification;
      case 'Help & Support':
        return Iconsax.headphone;
      case 'Privacy Policy':
        return Iconsax.shield_tick;
      case 'Logout':
        return Iconsax.logout;
      default:
        return Iconsax.setting;
    }
  }

  void _showImagePickerDialog(ProfileController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Change Profile Picture',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildImagePickerOption(
                  icon: Iconsax.gallery,
                  label: 'Gallery',
                  onTap: () {
                    Get.back();
                    controller.pickImageFromGallery();
                  },
                ),
                _buildImagePickerOption(
                  icon: Iconsax.camera,
                  label: 'Camera',
                  onTap: () {
                    Get.back();
                    controller.pickImageFromCamera();
                  },
                ),
                _buildImagePickerOption(
                  icon: Iconsax.profile_2user,
                  label: 'Default',
                  onTap: () {
                    Get.back();
                    controller.updateProfileImage(
                      'https://randomuser.me/api/portraits/men/1.jpg',
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePickerOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE53935).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 28, color: const Color(0xFFE53935)),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
