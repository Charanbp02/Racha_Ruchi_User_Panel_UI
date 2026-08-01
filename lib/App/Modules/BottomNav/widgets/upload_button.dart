// lib/App/Modules/BottomNav/widgets/upload_button.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Modules/Upload/view/upload_type_bottom_sheet.dart';

class UploadButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const UploadButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ?? _showUploadBottomSheet,
      icon: const Icon(Iconsax.gallery_add, color: Color(0xFFE53935)),
      iconSize: 28,
    );
  }

  void _showUploadBottomSheet() {
    Get.bottomSheet(
      const UploadTypeBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
    );
  }
}
