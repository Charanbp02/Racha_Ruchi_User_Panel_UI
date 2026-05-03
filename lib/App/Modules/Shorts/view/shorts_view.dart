import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Models/Shorts_Model/shorts_models.dart';
import 'package:racharuchi/App/Modules/Shorts/controller/shorts_controller.dart';

class ShortsView extends StatefulWidget {
  const ShortsView({super.key});

  @override
  State<ShortsView> createState() => _ShortsViewState();
}

class _ShortsViewState extends State<ShortsView> {
  late PageController _pageController;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ShortsController controller = Get.put(ShortsController());

    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        if (controller.shortsList.isEmpty) {
          return const Center(
            child: Text(
              'No shorts available',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          onPageChanged: (index) {
            controller.changeIndex(index);
          },
          itemCount: controller.shortsList.length,
          itemBuilder: (context, index) {
            return _buildShortsItem(controller, index);
          },
        );
      }),
    );
  }

  Widget _buildShortsItem(ShortsController controller, int index) {
    final short = controller.shortsList[index];

    return Stack(
      children: [
        // Background Image
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(short.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Gradient Overlay for better text visibility
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.8),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),

        // Top Bar
        Positioned(
          top: 40,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Shorts',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Iconsax.search_normal,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Iconsax.camera, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),

        // Right Side Action Buttons
        Positioned(
          right: 12,
          bottom: 100,
          child: Column(
            children: [
              // Like Button
              _buildActionButton(
                icon: short.isLiked ? Iconsax.heart5 : Iconsax.heart,
                label: short.likes,
                color: short.isLiked ? Colors.red : Colors.white,
                onTap: () => controller.likeVideo(index),
              ),
              const SizedBox(height: 20),

              // Comment Button
              _buildActionButton(
                icon: Iconsax.message,
                label: short.comments,
                onTap: () => _showCommentDialog(controller, index),
              ),
              const SizedBox(height: 20),

              // Share Button
              _buildActionButton(
                icon: Iconsax.share,
                label: short.shares,
                onTap: () => _showShareOptions(controller, index, short),
              ),
              const SizedBox(height: 20),

              // More Button
              _buildActionButton(icon: Iconsax.more, label: '', onTap: () {}),
            ],
          ),
        ),

        // Bottom Info Section
        Positioned(
          bottom: 20,
          left: 16,
          right: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Info
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(short.userImage),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    short.user,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Follow',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Title
              Text(
                short.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),

              // Caption with hashtags
              Text(
                short.caption,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 8),

              // Music/Song Info
              Row(
                children: [
                  const Icon(Iconsax.music, size: 14, color: Colors.white),
                  const SizedBox(width: 4),
                  const Text(
                    'Original Sound',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '• ${short.title}',
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    Color color = Colors.white,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          if (label.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 11),
            ),
          ],
        ],
      ),
    );
  }

  void _showCommentDialog(ShortsController controller, int index) {
    _commentController.clear();
    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Comments',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Iconsax.close_circle),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),

            // Comments List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 5,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                            'https://randomuser.me/api/portraits/men/${i + 10}.jpg',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'User${i + 1}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Amazing recipe! Loved it 😍',
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '2h ago',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Iconsax.heart, size: 16),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Comment Input
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Iconsax.send_1, color: Color(0xFFE53935)),
                    onPressed: () {
                      if (_commentController.text.isNotEmpty) {
                        controller.addComment(index, _commentController.text);
                        Get.back();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showShareOptions(
    ShortsController controller,
    int index,
    ShortsModel short,
  ) {
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
              'Share this video',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildShareOption(
                  Iconsax.instagram,
                  'Instagram',
                  Colors.purple,
                ),
                _buildShareOption(Iconsax.copy, 'Copy Link', Colors.grey),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                controller.shareVideo(index);
                Get.back();
                Get.snackbar(
                  'Shared!',
                  'Video shared successfully',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE53935),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('Share Now'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
