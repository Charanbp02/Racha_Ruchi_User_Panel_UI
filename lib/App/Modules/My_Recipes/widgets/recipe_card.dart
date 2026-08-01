// lib/App/Modules/My_Recipes/widgets/recipe_card.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:racharuchi/App/Models/My_Recipe_Model/recipe_model.dart';
import 'package:racharuchi/App/Modules/My_Recipes/controller/my_recipes_controller.dart';
import 'package:image_picker/image_picker.dart';

class RecipeCardWidget extends StatelessWidget {
  final RecipeModel recipe;
  final MyRecipesController controller;

  const RecipeCardWidget({
    super.key,
    required this.recipe,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildThumbnail(), _buildRecipeInfo()],
      ),
    );
  }

  Widget _buildThumbnail() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          child: CachedNetworkImage(
            imageUrl: recipe.imageUrl.isNotEmpty ? recipe.imageUrl : '',
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder:
                (context, url) => Container(
                  height: 180,
                  color: Colors.grey.shade100,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
            errorWidget:
                (context, url, error) => Container(
                  height: 180,
                  color: Colors.grey.shade100,
                  child: const Icon(
                    Iconsax.video,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
          ),
        ),
        _buildVideoOverlay(),
        _buildStatusBadge(),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildVideoOverlay() {
    return Positioned(
      bottom: 12,
      right: 12,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Iconsax.play5, size: 20, color: Colors.white),
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Positioned(
      top: 12,
      left: 12,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: _getStatusColor(recipe.status),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          recipe.status,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Positioned(
      top: 12,
      right: 12,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // More Menu Button
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, size: 20, color: Colors.grey),
              padding: const EdgeInsets.all(4),
              offset: const Offset(0, 5),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onSelected: (value) async {
                if (value == 'upload_thumbnail') {
                  await _showThumbnailUploadDialog();
                } else if (value == 'remove_thumbnail') {
                  await _showRemoveThumbnailConfirmation();
                }
              },
              itemBuilder:
                  (context) => [
                    const PopupMenuItem<String>(
                      value: 'upload_thumbnail',
                      child: Row(
                        children: [
                          Icon(Icons.image, size: 20, color: Colors.blue),
                          SizedBox(width: 12),
                          Text('Upload Thumbnail'),
                        ],
                      ),
                    ),
                    if (recipe.imageUrl.isNotEmpty)
                      const PopupMenuItem<String>(
                        value: 'remove_thumbnail',
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_outline,
                              size: 20,
                              color: Colors.red,
                            ),
                            SizedBox(width: 12),
                            Text('Remove Thumbnail'),
                          ],
                        ),
                      ),
                  ],
            ),
          ),
          const SizedBox(width: 8),
          // Delete Button
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Iconsax.trash, size: 18, color: Colors.red),
              onPressed: () => controller.deleteRecipe(recipe.id),
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showThumbnailUploadDialog() async {
    final ImagePicker picker = ImagePicker();

    // Show dialog with options
    final XFile? selectedImage = await Get.dialog<XFile?>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Upload Thumbnail',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Choose a source for your thumbnail image'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: null),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  try {
                    // Pick image from gallery
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 80,
                    );

                    // Close the dialog and return the image
                    if (image != null) {
                      Get.back(result: image);
                    } else {
                      // If user cancels, just close the dialog
                      Get.back(result: null);
                    }
                  } catch (e) {
                    print('Error picking image: $e');
                    Get.back(result: null);
                  }
                },
                icon: const Icon(Icons.photo_library),
                label: const Text('Gallery'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(double.infinity, 45),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () async {
                  try {
                    // Pick image from camera
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 80,
                    );

                    // Close the dialog and return the image
                    if (image != null) {
                      Get.back(result: image);
                    } else {
                      // If user cancels, just close the dialog
                      Get.back(result: null);
                    }
                  } catch (e) {
                    print('Error picking image from camera: $e');
                    Get.back(result: null);
                  }
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text('Camera'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(double.infinity, 45),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    // If an image was selected, upload it
    if (selectedImage != null) {
      await controller.uploadThumbnail(recipe.id, selectedImage);
    }
  }

  Future<void> _showRemoveThumbnailConfirmation() async {
    final bool? confirm = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Remove Thumbnail',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Are you sure you want to remove this thumbnail?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await controller.removeThumbnail(recipe.id);
    }
  }

  Widget _buildRecipeInfo() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            recipe.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D2D2D),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            recipe.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          _buildMetaRow(),
          const SizedBox(height: 10),
          _buildStatsRow(),
        ],
      ),
    );
  }

  Widget _buildMetaRow() {
    return Row(
      children: [
        _buildMetaItem(Iconsax.clock, recipe.cookingTime),
        const SizedBox(width: 16),
        _buildMetaItem(Iconsax.profile_2user, recipe.servings),
        const SizedBox(width: 16),
        _buildMetaItem(Iconsax.chart, recipe.difficulty),
      ],
    );
  }

  Widget _buildMetaItem(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade500),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatItem(Iconsax.heart, recipe.likes, Colors.red),
        const SizedBox(width: 16),
        _buildStatItem(Iconsax.message, recipe.comments, Colors.blue),
        const SizedBox(width: 16),
        _buildStatItem(Iconsax.eye, recipe.viewsCount.toString(), Colors.green),
        const Spacer(),
        Text(
          recipe.createdAt,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Published':
        return Colors.green;
      case 'Draft':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
