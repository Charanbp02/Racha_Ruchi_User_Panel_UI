// App/Modules/Search/view/widgets/full_screen_search_bar.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/Search/controller/search_controller.dart';
import 'search_field.dart';
import 'suggestions_list.dart';
import 'recent_searches_list.dart';

class FullScreenSearchBar extends StatelessWidget {
  final SearchBarController controller;
  final TextEditingController textEditingController;
  final String hintText;

  const FullScreenSearchBar({
    super.key,
    required this.controller,
    required this.textEditingController,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildAppBar(context),
          Expanded(
            child: Obx(() {
              if (controller.showSuggestions.value &&
                  controller.suggestions.isNotEmpty) {
                return SuggestionsList(controller: controller);
              }
              return RecentSearchesList(controller: controller);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 16,
        right: 16,
        bottom: 12,
      ),
      color: Colors.white,
      child: Row(
        children: [
          _buildBackButton(context),
          const SizedBox(width: 12),
          Expanded(
            child: SearchField(
              controller: controller,
              textEditingController: textEditingController,
              hintText: hintText,
            ),
          ),
          _buildCancelButton(context),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Icon(Icons.arrow_back, size: 20),
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: const Text(
        'Cancel',
        style: TextStyle(color: Color(0xFFE53935), fontWeight: FontWeight.w600),
      ),
    );
  }
}
