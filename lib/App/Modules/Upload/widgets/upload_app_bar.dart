// lib/App/Modules/Upload/widgets/upload_app_bar.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:racharuchi/App/Modules/Upload/controller/upload_controller.dart';

class UploadAppBar extends StatelessWidget implements PreferredSizeWidget {
  const UploadAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UploadController>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      title: Text(
        'Upload Video',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w700,
          fontSize: 18,
          color: isDarkMode ? Colors.white : const Color(0xFF1A1A1A),
        ),
      ),
      centerTitle: true,
      backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.white,
      elevation: 0,
      leading: _buildBackButton(controller, isDarkMode),
      actions: [_buildPostButton(controller, isDarkMode)],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
      ),
    );
  }

  Widget _buildBackButton(UploadController controller, bool isDarkMode) {
    return IconButton(
      onPressed: () {
        if (controller.isUploading.value) {
          _showMinimizeConfirmation(controller);
        } else {
          _showExitConfirmation(controller);
        }
      },
      padding: const EdgeInsets.only(left: 8),
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.close_rounded,
          color: isDarkMode ? Colors.white : const Color(0xFF1A1A1A),
          size: 20,
        ),
      ),
    );
  }

  Widget _buildPostButton(UploadController controller, bool isDarkMode) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(right: 16),
        child: ElevatedButton(
          onPressed:
              controller.isUploading.value ? null : controller.uploadVideo,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                controller.isUploading.value
                    ? (isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300)
                    : const Color(0xFFE53935),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            disabledBackgroundColor:
                isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
            disabledForegroundColor:
                isDarkMode ? Colors.grey.shade500 : Colors.grey.shade600,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (controller.isUploading.value) ...[
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${controller.uploadProgress.value.toInt()}%',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              ] else ...[
                Icon(Icons.cloud_upload_rounded, size: 18, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  'Post',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showMinimizeConfirmation(UploadController controller) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Minimize Upload?',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        content: Text(
          'Your upload will continue in the background. You can restore it anytime.',
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade600),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.minimizeUpload();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              'Minimize',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _showExitConfirmation(UploadController controller) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Cancel Upload?',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        content: Text(
          'Are you sure you want to cancel? Your progress will be lost.',
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade600),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Keep Editing',
              style: GoogleFonts.poppins(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.cancelUpload();
              Get.back(); // Go back to previous screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// Alternative: Upload App Bar with Progress Indicator
class UploadAppBarWithProgress extends StatefulWidget
    implements PreferredSizeWidget {
  const UploadAppBarWithProgress({super.key});

  @override
  State<UploadAppBarWithProgress> createState() =>
      _UploadAppBarWithProgressState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 4);
}

class _UploadAppBarWithProgressState extends State<UploadAppBarWithProgress> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UploadController>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      title: Text(
        'Upload Video',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w700,
          fontSize: 18,
          color: isDarkMode ? Colors.white : const Color(0xFF1A1A1A),
        ),
      ),
      centerTitle: true,
      backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.white,
      elevation: 0,
      leading: _buildBackButton(controller, isDarkMode),
      actions: [_buildPostButton(controller, isDarkMode)],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(4),
        child: Obx(() {
          if (controller.isUploading.value) {
            return LinearProgressIndicator(
              value: controller.uploadProgress.value / 100,
              backgroundColor:
                  isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
              color: const Color(0xFFE53935),
              minHeight: 4,
            );
          }
          return Container(
            height: 1,
            color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
          );
        }),
      ),
    );
  }

  Widget _buildBackButton(UploadController controller, bool isDarkMode) {
    return IconButton(
      onPressed: () {
        if (controller.isUploading.value) {
          _showMinimizeConfirmation(controller);
        } else {
          _showExitConfirmation(controller);
        }
      },
      padding: const EdgeInsets.only(left: 8),
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.close_rounded,
          color: isDarkMode ? Colors.white : const Color(0xFF1A1A1A),
          size: 20,
        ),
      ),
    );
  }

  Widget _buildPostButton(UploadController controller, bool isDarkMode) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(right: 16),
        child: ElevatedButton(
          onPressed:
              controller.isUploading.value ? null : controller.uploadVideo,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                controller.isUploading.value
                    ? (isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300)
                    : const Color(0xFFE53935),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            disabledBackgroundColor:
                isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
            disabledForegroundColor:
                isDarkMode ? Colors.grey.shade500 : Colors.grey.shade600,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (controller.isUploading.value) ...[
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${controller.uploadProgress.value.toInt()}%',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              ] else ...[
                Icon(Icons.cloud_upload_rounded, size: 18, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  'Post',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showMinimizeConfirmation(UploadController controller) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Minimize Upload?',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        content: Text(
          'Your upload will continue in the background. You can restore it anytime.',
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade600),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.minimizeUpload();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              'Minimize',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _showExitConfirmation(UploadController controller) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Cancel Upload?',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        content: Text(
          'Are you sure you want to cancel? Your progress will be lost.',
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade600),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Keep Editing',
              style: GoogleFonts.poppins(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.cancelUpload();
              Get.back(); // Go back to previous screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
