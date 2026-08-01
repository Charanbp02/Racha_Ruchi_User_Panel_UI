// App/Modules/Search/view/widgets/suggestions_list.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/Search/controller/search_controller.dart';

class SuggestionsList extends StatelessWidget {
  final SearchBarController controller;

  const SuggestionsList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        Expanded(
          child: Obx(
            () => ListView.builder(
              itemCount: controller.suggestions.length,
              itemBuilder: (context, index) {
                final suggestion = controller.suggestions[index];
                final isRecent = controller.recentSearches.contains(suggestion);

                return SuggestionTile(
                  suggestion: suggestion,
                  isRecent: isRecent,
                  onTap: () async {
                    await controller.onSuggestionSelected(suggestion);
                    _navigateToResultsPage(context, suggestion);
                  },
                  onRemove: () {
                    final recentIndex = controller.recentSearches.indexOf(
                      suggestion,
                    );
                    if (recentIndex != -1) {
                      controller.removeRecentSearch(recentIndex);
                    }
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Obx(
        () => Text(
          'Suggestions for "${controller.query.value}"',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _navigateToResultsPage(BuildContext context, String query) {
    // Check if the context is still mounted before navigating
    if (!context.mounted) return;

    // Use WidgetsBinding to ensure the navigation happens after the current frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        // Pop the current screen (search overlay)
        Navigator.pop(context);

        // Then navigate to results page
        if (context.mounted) {
          Navigator.pushNamed(
            context,
            '/search-results',
            arguments: {
              'query': query,
              'results': controller.searchResults.toList(),
            },
          );
        }
      }
    });
  }
}

class SuggestionTile extends StatelessWidget {
  final String suggestion;
  final bool isRecent;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const SuggestionTile({
    super.key,
    required this.suggestion,
    required this.isRecent,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        isRecent ? Icons.history : Icons.search,
        size: 20,
        color: Colors.grey.shade600,
      ),
      title: Text(suggestion, style: const TextStyle(fontSize: 14)),
      trailing:
          isRecent
              ? IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: onRemove,
              )
              : null,
      onTap: onTap,
    );
  }
}
