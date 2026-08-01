// lib/App/Modules/Upload/widgets/video_selection_section.dart
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:racharuchi/App/Modules/Upload/controller/upload_controller.dart';
import 'package:racharuchi/App/Modules/Upload/widgets/video_picker.dart';
import 'package:racharuchi/App/Modules/Upload/widgets/video_preview.dart';
import 'package:racharuchi/App/Modules/Upload/widgets/video_type_indicator.dart';

class VideoSelectionSection extends StatelessWidget {
  final UploadController controller;

  const VideoSelectionSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildVideoContainer(),
        VideoTypeIndicator(controller: controller),
      ],
    );
  }

  Widget _buildVideoContainer() {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Obx(
          () =>
              controller.selectedVideoPath.isEmpty
                  ? VideoPicker(controller: controller)
                  : VideoPreview(controller: controller),
        ),
      ),
    );
  }
}
