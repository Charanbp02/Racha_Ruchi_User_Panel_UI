import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:racharuchi/App/Models/Social_Model/social_model.dart';
import 'package:racharuchi/App/Modules/Social/controller/social_controller.dart';

class UserCard extends StatelessWidget {
  final UserModel user;
  final SocialController controller;

  const UserCard({super.key, required this.user, required this.controller});

  @override
  Widget build(BuildContext context) {
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
                _buildProfileImage(),
                const SizedBox(width: 12),
                _buildUserInfo(),
                _buildFollowButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return ClipRRect(
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
              child: const Icon(Icons.person, size: 30, color: Colors.grey),
            ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Expanded(
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
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            user.bio,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, color: Color(0xFF666666)),
          ),
        ],
      ),
    );
  }

  Widget _buildFollowButton() {
    return SizedBox(
      width: 85,
      height: 32,
      child: ElevatedButton(
        onPressed: () => controller.toggleFollow(user.id),
        style: ElevatedButton.styleFrom(
          backgroundColor:
              user.isFollowing ? Colors.grey.shade200 : const Color(0xFFE53935),
          foregroundColor:
              user.isFollowing ? Colors.grey.shade700 : Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          user.isFollowing
              ? 'Following'
              : controller.myFollowersSet.contains(user.id)
              ? 'Follow Back'
              : 'Follow',
        ),
      ),
    );
  }
}
