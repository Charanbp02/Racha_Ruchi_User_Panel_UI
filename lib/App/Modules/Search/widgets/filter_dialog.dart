// App/Modules/Search/view/widgets/filter_dialog.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class FilterDialog extends StatelessWidget {
  const FilterDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sort by',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildFilterOption(context, Iconsax.clock, 'Latest', () {
            Navigator.pop(context);
          }),
          _buildFilterOption(context, Iconsax.eye, 'Most viewed', () {
            Navigator.pop(context);
          }),
          _buildFilterOption(context, Iconsax.like, 'Most liked', () {
            Navigator.pop(context);
          }),
          _buildFilterOption(context, Iconsax.video_play, 'Shortest', () {
            Navigator.pop(context);
          }),
        ],
      ),
    );
  }

  Widget _buildFilterOption(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(title, style: GoogleFonts.poppins(fontSize: 14)),
      onTap: onTap,
    );
  }
}
