// App/Modules/Search/view/widgets/compact_search_bar.dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Modules/Search/view/search_bar_view.dart';

class CompactSearchBar extends StatelessWidget {
  final double height;
  final String hintText;
  final VoidCallback? onFilterTap;

  const CompactSearchBar({
    super.key,
    required this.height,
    required this.hintText,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SearchBarView(fullScreen: true),
          ),
        );
      },
      child: Container(
        height: height,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _buildSearchIcon(),
            _buildSearchInput(context),
            _buildMicButton(),
            if (onFilterTap != null) _buildFilterButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchIcon() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.horizontal(left: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(Icons.search, size: 20, color: Colors.grey),
    );
  }

  Widget _buildSearchInput(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          enabled: false,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildMicButton() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(Iconsax.close_circle5, size: 20, color: Colors.grey),
    );
  }

  Widget _buildFilterButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: GestureDetector(
        onTap: onFilterTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFE53935),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE53935).withValues(alpha: 0.3),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(Icons.filter_list, size: 20, color: Colors.white),
        ),
      ),
    );
  }
}
