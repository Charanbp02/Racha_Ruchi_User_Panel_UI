// lib/App/Modules/All_Videos/widgets/report_options_sheet.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Models/Video_Model/video_model.dart';
import 'package:racharuchi/App/Modules/All_Videos/controller/videos_controller.dart';

class ReportOptionsSheet extends StatelessWidget {
  final VideoModel video;
  final VideosController controller;

  const ReportOptionsSheet({
    super.key,
    required this.video,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(
              20,
              12,
              20,
              24 + MediaQuery.of(context).padding.bottom,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag Handle
                Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                const SizedBox(height: 20),

                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.red.withValues(alpha: .08),
                  child: const Icon(
                    Iconsax.warning_2,
                    color: Colors.red,
                    size: 28,
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  "Report Video",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Why are you reporting this video?",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 24),

                _buildReportOption(
                  icon: Iconsax.warning_2,
                  title: "Spam or Misleading",
                  reason: "spam",
                ),

                _buildReportOption(
                  icon: Iconsax.danger,
                  title: "Violence",
                  reason: "violence",
                ),

                _buildReportOption(
                  icon: Iconsax.forbidden_2,
                  title: "Hateful Content",
                  reason: "hate",
                ),

                _buildReportOption(
                  icon: Iconsax.eye_slash,
                  title: "Sexual Content",
                  reason: "sexual",
                ),

                _buildReportOption(
                  icon: Iconsax.message_question,
                  title: "Other",
                  reason: "other",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReportOption({
    required IconData icon,
    required String title,
    required String reason,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () async {
            Get.back();

            await controller.reportVideo(video: video, reason: reason);

            Get.snackbar(
              "Report Submitted",
              "Thank you for helping keep the community safe.",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
              margin: const EdgeInsets.all(16),
              borderRadius: 12,
              duration: const Duration(seconds: 2),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(icon, color: Colors.red, size: 22),

                const SizedBox(width: 16),

                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const Icon(Icons.chevron_right_rounded, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
