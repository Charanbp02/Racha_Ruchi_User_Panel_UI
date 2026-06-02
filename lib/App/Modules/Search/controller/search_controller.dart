import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class SearchBarController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  var searchText = ''.obs;
  var isSearching = false.obs;
  var recentSearches = <String>[].obs;
  var searchResults = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var suggestions = <String>[].obs; // NEW: For keyword suggestions
  var showSuggestions = false.obs; // NEW: Show/hide suggestions dropdown
  var query = ''.obs; // NEW: Current query for suggestions

  Timer? _debounce;
  Timer? _suggestionDebounce;

  @override
  void onInit() {
    super.onInit();
    loadRecentSearches();
  }

  // =========================
  // RECENT SEARCHES
  // =========================

  void loadRecentSearches() {
    recentSearches.value = [
      'Chicken Biryani',
      'Paneer Butter Masala',
      'Masala Dosa',
    ];
  }

  void addToRecentSearch(String search) {
    recentSearches.remove(search);
    recentSearches.insert(0, search);
    if (recentSearches.length > 10) {
      recentSearches.removeLast();
    }
    saveRecentSearches();
  }

  void saveRecentSearches() {
    print('Saved recent searches: $recentSearches');
  }

  void clearRecentSearches() {
    recentSearches.clear();
    saveRecentSearches();
  }

  void removeRecentSearch(int index) {
    recentSearches.removeAt(index);
    saveRecentSearches();
  }

  // =========================
  // KEYWORD SUGGESTIONS (NEW)
  // =========================

  void onSearchTextChanged(String text) {
    query.value = text;
    searchText.value = text;

    // Cancel existing timers
    _suggestionDebounce?.cancel();

    if (text.trim().isEmpty) {
      suggestions.clear();
      showSuggestions.value = false;
      return;
    }

    // Show suggestions while typing
    showSuggestions.value = true;

    // Debounce suggestions to avoid too many Firebase calls
    _suggestionDebounce = Timer(const Duration(milliseconds: 200), () {
      getKeywordSuggestions(text);
    });
  }

  Future<void> getKeywordSuggestions(String query) async {
    if (query.trim().isEmpty) {
      suggestions.clear();
      return;
    }

    try {
      final searchQuery = query.trim().toLowerCase();

      final matchingRecents =
          recentSearches
              .where((s) => s.toLowerCase().contains(searchQuery))
              .take(3)
              .toList();

      final snapshot =
          await firestore
              .collection('search_suggestions')
              .where('keyword', isGreaterThanOrEqualTo: searchQuery)
              .where('keyword', isLessThanOrEqualTo: '$searchQuery\uf8ff')
              .limit(5)
              .get();

      final firestoreSuggestions =
          snapshot.docs.map((doc) => doc['keyword'] as String).toList();

      suggestions.value = [
        ...matchingRecents,
        ...firestoreSuggestions.where((s) => !matchingRecents.contains(s)),
      ];

      if (suggestions.isEmpty && query.length > 1) {
        suggestions.value = await getFallbackSuggestions(query);
      }
    } catch (e) {
      print('Error getting suggestions: $e');

      suggestions.value = await getFallbackSuggestions(query);
    }
  }

  Future<List<String>> getFallbackSuggestions(String query) async {
    return [
      '$query recipes',
      '$query breakfast recipes',
      '$query chicken recipes',
      '$query snacks recipes',
      '$query cooking',
    ];
  }

  Future<void> onSuggestionSelected(String suggestion) async {
    searchText.value = suggestion;
    query.value = suggestion;
    showSuggestions.value = false;
    suggestions.clear();

    await performSearch(suggestion);

    addToRecentSearch(suggestion);
  }

  // =========================
  // SEARCH
  // =========================

  Future<void> performSearch(String query) async {
    try {
      isLoading.value = true;
      showSuggestions.value = false;

      final searchQuery = query.trim().toLowerCase();
      print('Searching for: $searchQuery');

      // Method 1: Search by keywords (if you have searchKeywords field)
      final snapshot =
          await firestore
              .collection('recipe_videos')
              .where('visibility', isEqualTo: 'visible')
              .get();

      // Manual filtering for better search results
      final results = <Map<String, dynamic>>[];

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final title = (data['title'] ?? '').toString().toLowerCase();
        final description =
            (data['description'] ?? '').toString().toLowerCase();
        final tags =
            (data['tags'] as List? ?? [])
                .map((t) => t.toString().toLowerCase())
                .toList();
        final ingredients =
            (data['ingredients'] as List? ?? [])
                .map((i) => (i['name'] ?? '').toString().toLowerCase())
                .toList();

        // Check if search query matches any field
        bool matches =
            title.contains(searchQuery) ||
            description.contains(searchQuery) ||
            tags.any((tag) => tag.contains(searchQuery)) ||
            ingredients.any((ing) => ing.contains(searchQuery));

        if (matches) {
          results.add({
            'id': doc.id,
            'title': data['title'] ?? '',
            'description': data['description'] ?? '',
            'duration': data['duration'] ?? '',
            'videoType': data['videoType'] ?? '',
            'thumbnailUrl': data['thumbnailUrl'] ?? '',
            'videoUrl': data['videoUrl'] ?? '',
            'views': data['views'] ?? 0,
            'likes': data['likes'] ?? 0,
            'userName': data['userName'] ?? 'User',
            'userImage': data['userImage'] ?? '',
            'createdAt': data['createdAt'],

            // ADD THESE
            'ingredients': data['ingredients'] ?? [],
            'tags': data['tags'] ?? [],
            'category': data['category'] ?? '',
            'comments': data['comments'] ?? 0,
            'shares': data['shares'] ?? 0,
            'rating': data['rating'] ?? 0,
            'isPopular': data['isPopular'] ?? false,
            'userId': data['userId'] ?? '',
          });
        }
      }

      // Sort results by relevance (title match first, then views)
      results.sort((a, b) {
        final aTitle = (a['title'] ?? '').toString().toLowerCase();
        final bTitle = (b['title'] ?? '').toString().toLowerCase();

        bool aExact = aTitle == searchQuery;
        bool bExact = bTitle == searchQuery;

        if (aExact != bExact) return aExact ? -1 : 1;

        // Then by views
        return (b['views'] ?? 0).compareTo(a['views'] ?? 0);
      });

      searchResults.value = results;

      print('Found ${results.length} results for "$searchQuery"');
    } catch (e) {
      print('Search Error: $e');
      searchResults.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void onSearchSubmitted(String query) {
    if (query.isNotEmpty) {
      addToRecentSearch(query);
      performSearch(query);
      isSearching.value = false;
      showSuggestions.value = false;
    }
  }

  void clearSearch() {
    searchText.value = '';
    query.value = '';
    searchResults.clear();
    suggestions.clear();
    isSearching.value = false;
    showSuggestions.value = false;
  }
}
