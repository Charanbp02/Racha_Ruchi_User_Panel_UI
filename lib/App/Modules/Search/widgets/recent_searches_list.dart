// App/Modules/Search/view/widgets/recent_searches_list.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/Search/controller/search_controller.dart';
import 'empty_search_state.dart';

class RecentSearchesList extends StatelessWidget {
  final SearchBarController controller;

  const RecentSearchesList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          if (controller.recentSearches.isEmpty)
            const Expanded(child: EmptySearchState()),
          if (controller.recentSearches.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: controller.recentSearches.length,
                itemBuilder: (context, index) {
                  final item = controller.recentSearches[index];
                  return RecentSearchTile(
                    item: item,
                    index: index,
                    onTap: () {
                      controller.onSearchSubmitted(item);
                      _navigateToResultsPage(context, item);
                    },
                    onRemove: () => controller.removeRecentSearch(index),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Recent Searches',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          if (controller.recentSearches.isNotEmpty)
            TextButton(
              onPressed: controller.clearRecentSearches,
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: EdgeInsets.zero,
              ),
              child: const Text(
                'Clear All',
                style: TextStyle(color: Color(0xFFE53935), fontSize: 13),
              ),
            ),
        ],
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

class RecentSearchTile extends StatelessWidget {
  final String item;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const RecentSearchTile({
    super.key,
    required this.item,
    required this.index,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.history, size: 20),
      title: Text(item),
      trailing: IconButton(
        icon: const Icon(Icons.close, size: 18),
        onPressed: onRemove,
      ),
      onTap: onTap,
    );
  }
}
