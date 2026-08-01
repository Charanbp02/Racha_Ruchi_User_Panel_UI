// App/Modules/Search/view/widgets/video_options_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class VideoOptionsBottomSheet extends StatelessWidget {
  final Map<String, dynamic> item;

  const VideoOptionsBottomSheet({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDragHandle(),
            _buildOptionTile(Iconsax.save_2, 'Save to playlist', () {
              Navigator.pop(context);
            }),
            _buildOptionTile(Iconsax.share, 'Share', () {
              Navigator.pop(context);
            }),
            _buildOptionTile(Iconsax.message, 'Report', () {
              Navigator.pop(context);
            }),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildOptionTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(title),
      onTap: onTap,
    );
  }
}
