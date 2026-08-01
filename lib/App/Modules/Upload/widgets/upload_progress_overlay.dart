// lib/App/Modules/Upload/widgets/upload_progress_overlay.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:racharuchi/App/Modules/Upload/controller/upload_controller.dart';

class UploadProgressOverlay extends StatelessWidget {
  final UploadController controller;

  const UploadProgressOverlay({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.7),
      child: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: controller.uploadProgress.value),
          duration: const Duration(milliseconds: 300),
          builder: (context, value, child) {
            return GestureDetector(
              onTap: controller.minimizeUpload,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildCircularProgress(value),
                    const SizedBox(height: 20),
                    _buildTitle(),
                    const SizedBox(height: 6),
                    _buildStatusText(),
                    const SizedBox(height: 12),
                    _buildSpeedInfo(),
                    const SizedBox(height: 24),
                    _buildActionButtons(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCircularProgress(double value) {
    return SizedBox(
      height: 100,
      width: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              shape: BoxShape.circle,
            ),
          ),
          // Progress circle
          CircularProgressIndicator(
            value: value,
            strokeWidth: 6,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFE53935)),
          ),
          // Percentage text
          Obx(
            () => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${(controller.uploadProgress.value * 100).toInt()}%',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Uploaded',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Obx(
      () => Text(
        controller.videoTitle.value.isNotEmpty
            ? controller.videoTitle.value
            : 'Uploading Video',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Colors.black87,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildStatusText() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFE53935).withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          _getUploadStatus(controller.uploadProgress.value),
          style: GoogleFonts.poppins(
            color: const Color(0xFFE53935),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  String _getUploadStatus(double progress) {
    if (progress < 0.10) return '📹 Compressing video...';
    if (progress < 0.40) return '⬆️ Uploading video...';
    if (progress < 0.60) return '🖼️ Uploading thumbnail...';
    if (progress < 0.80) return '📝 Saving recipe...';
    if (progress < 0.95) return '⏳ Finalizing...';
    return '✅ Almost done!';
  }

  Widget _buildSpeedInfo() {
    return Obx(() {
      final speed = controller.uploadSpeed.value;
      final time = controller.estimatedTimeRemaining.value;

      if (speed.isEmpty && time.isEmpty) {
        return const SizedBox.shrink();
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (speed.isNotEmpty) ...[
            Icon(Icons.speed_rounded, size: 14, color: Colors.grey.shade400),
            const SizedBox(width: 4),
            Text(
              speed,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          ],
          if (speed.isNotEmpty && time.isNotEmpty) ...[
            const SizedBox(width: 12),
            Container(width: 1, height: 12, color: Colors.grey.shade200),
            const SizedBox(width: 12),
          ],
          if (time.isNotEmpty) ...[
            Icon(Icons.timer_rounded, size: 14, color: Colors.grey.shade400),
            const SizedBox(width: 4),
            Text(
              time,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ],
      );
    });
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: controller.minimizeUpload,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.grey.shade100,
              foregroundColor: Colors.grey.shade700,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.remove_rounded,
                  size: 18,
                  color: Colors.grey.shade700,
                ),
                const SizedBox(width: 6),
                Text(
                  'Minimize',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextButton(
            onPressed: controller.cancelUpload,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: const Color(0xFFE53935).withValues(alpha: 0.08),
              foregroundColor: const Color(0xFFE53935),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: const Color(0xFFE53935),
                ),
                const SizedBox(width: 6),
                Text(
                  'Cancel',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: const Color(0xFFE53935),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Alternative: Upload Progress Overlay with Progress Bar
class UploadProgressOverlayWithBar extends StatelessWidget {
  final UploadController controller;

  const UploadProgressOverlayWithBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.7),
      child: Center(
        child: GestureDetector(
          onTap: controller.minimizeUpload,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildIcon(),
                const SizedBox(height: 20),
                _buildTitle(),
                const SizedBox(height: 8),
                _buildProgressBar(),
                const SizedBox(height: 8),
                _buildStatusText(),
                const SizedBox(height: 16),
                _buildSpeedInfo(),
                const SizedBox(height: 24),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE53935).withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.cloud_upload_rounded,
        color: Color(0xFFE53935),
        size: 40,
      ),
    );
  }

  Widget _buildTitle() {
    return Obx(
      () => Text(
        controller.videoTitle.value.isNotEmpty
            ? controller.videoTitle.value
            : 'Uploading Video',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Colors.black87,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildProgressBar() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                '${(controller.uploadProgress.value * 100).toInt()}%',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFE53935),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: controller.uploadProgress.value,
              backgroundColor: Colors.grey.shade200,
              color: const Color(0xFFE53935),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusText() {
    return Obx(
      () => Text(
        _getUploadStatus(controller.uploadProgress.value),
        style: GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 13),
      ),
    );
  }

  String _getUploadStatus(double progress) {
    if (progress < 0.10) return 'Compressing video...';
    if (progress < 0.40) return 'Uploading video...';
    if (progress < 0.60) return 'Uploading thumbnail...';
    if (progress < 0.80) return 'Saving recipe...';
    if (progress < 0.95) return 'Finalizing...';
    return 'Almost done!';
  }

  Widget _buildSpeedInfo() {
    return Obx(() {
      final speed = controller.uploadSpeed.value;
      final time = controller.estimatedTimeRemaining.value;

      if (speed.isEmpty && time.isEmpty) {
        return const SizedBox.shrink();
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (speed.isNotEmpty) ...[
            Text(
              speed,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          ],
          if (speed.isNotEmpty && time.isNotEmpty) ...[
            const SizedBox(width: 8),
            Text(
              '•',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey.shade300,
              ),
            ),
            const SizedBox(width: 8),
          ],
          if (time.isNotEmpty) ...[
            Text(
              time,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ],
      );
    });
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: controller.minimizeUpload,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.grey.shade100,
            ),
            child: Text(
              'Minimize',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextButton(
            onPressed: controller.cancelUpload,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: const Color(0xFFE53935).withValues(alpha: 0.08),
            ),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: const Color(0xFFE53935),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
