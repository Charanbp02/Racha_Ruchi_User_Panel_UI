// lib/App/Modules/Upload/widgets/video_picker.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Modules/Upload/controller/upload_controller.dart';

class VideoPicker extends StatelessWidget {
  final UploadController controller;

  const VideoPicker({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: controller.pickVideo,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // ✅ Prevents overflow
          children: [
            _buildIcon(isDarkMode),
            const SizedBox(height: 12),
            _buildTitle(isDarkMode),
            const SizedBox(height: 6),
            _buildSubtitle(isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFD32F2F), Color(0xFFE53935)],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE53935).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Icon(Iconsax.video_add, size: 28, color: Colors.white),
    );
  }

  Widget _buildTitle(bool isDarkMode) {
    return Text(
      'Tap to select video',
      style: GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: isDarkMode ? Colors.white : Colors.black87,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubtitle(bool isDarkMode) {
    return Text(
      'MP4, MOV • Max 25 minutes',
      style: GoogleFonts.poppins(
        fontSize: 12,
        color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade500,
      ),
      textAlign: TextAlign.center,
    );
  }
}

// Alternative: Video Picker with Browse Button (More Compact)
class CompactVideoPicker extends StatelessWidget {
  final UploadController controller;

  const CompactVideoPicker({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: controller.pickVideo,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIcon(isDarkMode),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTitle(isDarkMode),
                  const SizedBox(height: 4),
                  _buildSubtitle(isDarkMode),
                ],
              ),
            ),
            _buildBrowseButton(isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFD32F2F), Color(0xFFE53935)],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE53935).withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(Iconsax.video_add, size: 20, color: Colors.white),
    );
  }

  Widget _buildTitle(bool isDarkMode) {
    return Text(
      'Select a video',
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: isDarkMode ? Colors.white : Colors.black87,
      ),
    );
  }

  Widget _buildSubtitle(bool isDarkMode) {
    return Text(
      'MP4, MOV • Max 25 minutes',
      style: GoogleFonts.poppins(
        fontSize: 11,
        color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade500,
      ),
    );
  }

  Widget _buildBrowseButton(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFD32F2F), Color(0xFFE53935)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE53935).withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.folder_open_rounded, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            'Browse',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// Alternative: Video Picker with File Info
class VideoPickerWithFileInfo extends StatelessWidget {
  final UploadController controller;

  const VideoPickerWithFileInfo({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: controller.pickVideo,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildIcon(isDarkMode),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildTitle(isDarkMode),
                      const SizedBox(height: 4),
                      _buildSubtitle(isDarkMode),
                    ],
                  ),
                ),
                _buildBrowseButton(isDarkMode),
              ],
            ),
            const SizedBox(height: 12),
            _buildFileInfo(isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFD32F2F), Color(0xFFE53935)],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE53935).withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(Iconsax.video_add, size: 20, color: Colors.white),
    );
  }

  Widget _buildTitle(bool isDarkMode) {
    return Text(
      'Select a video',
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: isDarkMode ? Colors.white : Colors.black87,
      ),
    );
  }

  Widget _buildSubtitle(bool isDarkMode) {
    return Text(
      'MP4, MOV • Max 25 minutes',
      style: GoogleFonts.poppins(
        fontSize: 11,
        color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade500,
      ),
    );
  }

  Widget _buildBrowseButton(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFD32F2F), Color(0xFFE53935)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE53935).withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.folder_open_rounded, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            'Browse',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileInfo(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 12,
            color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade500,
          ),
          const SizedBox(width: 6),
          Text(
            '1080p recommended',
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
