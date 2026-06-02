import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/Search/controller/search_controller.dart';
import 'package:racharuchi/App/Routes/app_routes.dart';

class SearchBarView extends StatefulWidget {
  final double height;
  final String hintText;
  final VoidCallback? onFilterTap;
  final bool fullScreen;

  const SearchBarView({
    super.key,
    this.height = 50,
    this.hintText = 'Search recipes videos...',
    this.onFilterTap,
    this.fullScreen = false,
  });

  @override
  State<SearchBarView> createState() => _SearchBarViewState();
}

class _SearchBarViewState extends State<SearchBarView> {
  late SearchBarController controller;
  late TextEditingController _textEditingController;
  Worker? _queryWorker;

  @override
  void initState() {
    super.initState();
    controller = Get.put(SearchBarController());
    _textEditingController = TextEditingController();

    // Add a small delay to ensure controller is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Listen to controller query changes to update TextField
        _queryWorker = ever(controller.query, (String? value) {
          if (mounted && _textEditingController.text != (value ?? '')) {
            _textEditingController.text = value ?? '';
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _queryWorker?.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.fullScreen
        ? _buildFullScreenSearch(context)
        : _buildCompactSearch();
  }

  // =========================
  // COMPACT SEARCH BAR
  // =========================

  Widget _buildCompactSearch() {
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
        height: widget.height,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // SEARCH ICON
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.search, size: 20, color: Colors.grey),
            ),

            // SEARCH INPUT
            Expanded(
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
                    hintText: widget.hintText,
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),

            // MIC BUTTON
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.horizontal(
                  right: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.mic, size: 20, color: Colors.grey),
            ),

            // FILTER BUTTON
            if (widget.onFilterTap != null) const SizedBox(width: 8),

            if (widget.onFilterTap != null)
              GestureDetector(
                onTap: widget.onFilterTap,
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
                  child: const Icon(
                    Icons.filter_list,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // =========================
  // FULL SCREEN SEARCH
  // =========================

  Widget _buildFullScreenSearch(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // APP BAR
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              left: 16,
              right: 16,
              bottom: 12,
            ),
            color: Colors.white,
            child: Row(
              children: [
                // BACK BUTTON
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(Icons.arrow_back, size: 20),
                  ),
                ),

                const SizedBox(width: 12),

                // SEARCH FIELD
                Expanded(child: _buildSearchField()),

                // CANCEL BUTTON
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Color(0xFFE53935),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // BODY WITH SUGGESTIONS
          Expanded(
            child: Obx(() {
              // Check if controller is available
              if (!Get.isRegistered<SearchBarController>()) {
                return const SizedBox.shrink();
              }

              // Show suggestions dropdown when typing
              if (controller.showSuggestions.value &&
                  controller.suggestions.isNotEmpty) {
                return _buildSuggestionsList();
              }

              // Show search results or recent searches
              return _buildRecentSearches();
            }),
          ),
        ],
      ),
    );
  }

  // =========================
  // SEARCH FIELD
  // =========================

  Widget _buildSearchField() {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _textEditingController,
        autofocus: true,
        onChanged: (value) {
          if (Get.isRegistered<SearchBarController>()) {
            controller.onSearchTextChanged(value);
          }
        },
        onSubmitted: (value) async {
          if (Get.isRegistered<SearchBarController>()) {
            await controller.performSearch(value);

            controller.addToRecentSearch(value);

            _navigateToResultsPage(value);
          }
        },
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          prefixIcon: const Icon(Icons.search, size: 20, color: Colors.grey),
          suffixIcon: Obx(() {
            if (Get.isRegistered<SearchBarController>() &&
                controller.query.value.isNotEmpty) {
              return IconButton(
                icon: const Icon(Icons.clear, size: 18),
                onPressed: () {
                  if (Get.isRegistered<SearchBarController>()) {
                    controller.clearSearch();
                    _textEditingController.clear();
                  }
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

  // =========================
  // SUGGESTIONS DROPDOWN
  // =========================

  Widget _buildSuggestionsList() {
    if (!Get.isRegistered<SearchBarController>()) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
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
        ),
        Expanded(
          child: Obx(
            () => ListView.builder(
              itemCount: controller.suggestions.length,
              itemBuilder: (context, index) {
                final suggestion = controller.suggestions[index];
                final isRecent = controller.recentSearches.contains(suggestion);

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
                            onPressed: () {
                              final recentIndex = controller.recentSearches
                                  .indexOf(suggestion);
                              if (recentIndex != -1) {
                                controller.removeRecentSearch(recentIndex);
                              }
                            },
                          )
                          : null,
                  onTap: () async {
                    await controller.onSuggestionSelected(suggestion);

                    _navigateToResultsPage(suggestion);
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  // =========================
  // MAIN CONTENT (Recent or Results)
  // =========================

  Widget _buildMainContent() {
    if (!Get.isRegistered<SearchBarController>()) {
      return const SizedBox.shrink();
    }

    // LOADING
    if (controller.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    // SEARCH RESULTS
    if (controller.searchText.value.isNotEmpty) {
      // EMPTY RESULT
      if (controller.searchResults.isEmpty) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Obx(
              () => Text(
                'No results found for "${controller.searchText.value}"',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                if (Get.isRegistered<SearchBarController>()) {
                  controller.clearSearch();
                }
              },
              child: const Text('Clear search'),
            ),
          ],
        );
      }

      // RESULT LIST
      return Obx(
        () => ListView.builder(
          itemCount: controller.searchResults.length,
          padding: const EdgeInsets.all(8),
          itemBuilder: (context, index) {
            final item = controller.searchResults[index];
            return _buildResultItem(item);
          },
        ),
      );
    }

    // RECENT SEARCHES
    return _buildRecentSearches();
  }

  // =========================
  // RESULT ITEM
  // =========================

  Widget _buildResultItem(Map<String, dynamic> item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Navigate to video details page
          Navigator.pushNamed(context, '/video-player', arguments: item);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child:
                  item['thumbnailUrl'] != null &&
                          item['thumbnailUrl'].toString().isNotEmpty
                      ? Image.network(
                        item['thumbnailUrl'],
                        width: 120,
                        height: 90,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 120,
                            height: 90,
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.video_library, size: 30),
                          );
                        },
                      )
                      : Container(
                        width: 120,
                        height: 90,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.video_library, size: 30),
                      ),
            ),

            // Video Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title']?.toString() ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item['userName'] ?? 'User'} • ${item['views'] ?? 0} views',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${item['videoType'] ?? ''} • ${item['duration'] ?? ''}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // RECENT SEARCHES
  // =========================

  Widget _buildRecentSearches() {
    if (!Get.isRegistered<SearchBarController>()) {
      return const SizedBox.shrink();
    }

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
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
          ),

          if (controller.recentSearches.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history, size: 48, color: Colors.grey.shade400),
                    const SizedBox(height: 12),
                    Text(
                      'No recent searches',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
            ),

          if (controller.recentSearches.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: controller.recentSearches.length,
                itemBuilder: (context, index) {
                  final item = controller.recentSearches[index];
                  return ListTile(
                    leading: const Icon(Icons.history, size: 20),
                    title: Text(item),
                    trailing: IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () {
                        controller.removeRecentSearch(index);
                      },
                    ),
                    onTap: () {
                      controller.onSearchSubmitted(item);
                      _navigateToResultsPage(item);
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  // =========================
  // NAVIGATION TO RESULTS PAGE
  // =========================

  Future<void> _navigateToResultsPage(String query) async {
    Navigator.pop(context);

    Navigator.pushNamed(
      context,
      AppRoutes.SEARCH_RESULTS,
      arguments: {'query': query, 'results': controller.searchResults.toList()},
    );
  }
}
