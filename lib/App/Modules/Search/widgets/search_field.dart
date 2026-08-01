// App/Modules/Search/view/widgets/search_field.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/Search/controller/search_controller.dart';

class SearchField extends StatelessWidget {
  final SearchBarController controller;
  final TextEditingController textEditingController;
  final String hintText;

  const SearchField({
    super.key,
    required this.controller,
    required this.textEditingController,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: textEditingController,
        autofocus: true,
        onChanged: controller.onSearchTextChanged,
        onSubmitted: (value) async {
          await controller.performSearch(value);
          controller.addToRecentSearch(value);
          _navigateToResultsPage(context, value);
        },
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          prefixIcon: const Icon(Icons.search, size: 20, color: Colors.grey),
          suffixIcon: Obx(() {
            if (controller.query.value.isNotEmpty) {
              return IconButton(
                icon: const Icon(Icons.clear, size: 18),
                onPressed: () {
                  controller.clearSearch();
                  textEditingController.clear();
                },
              );
            }
            return const SizedBox.shrink();
          }),
          border: InputBorder.none,
        ),
      ),
    );
  }

  void _navigateToResultsPage(BuildContext context, String query) {
    Navigator.pop(context);
    Navigator.pushNamed(
      context,
      '/search-results',
      arguments: {'query': query, 'results': controller.searchResults.toList()},
    );
  }
}
