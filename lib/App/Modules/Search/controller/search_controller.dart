import 'package:get/get.dart';

class SearchBarController extends GetxController {
  var searchText = ''.obs;
  var isSearching = false.obs;
  var recentSearches = <String>[].obs;
  var searchResults = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  // All available recipes for search
  final List<Map<String, dynamic>> allRecipes = [
    {
      'name': 'Chicken Biryani',
      'type': 'Non-Veg',
      'duration': '30 min',
      'icon': '🍗',
    },
    {
      'name': 'Paneer Butter Masala',
      'type': 'Veg',
      'duration': '25 min',
      'icon': '🧀',
    },
    {'name': 'Masala Dosa', 'type': 'Veg', 'duration': '15 min', 'icon': '🥞'},
    {
      'name': 'Butter Chicken',
      'type': 'Non-Veg',
      'duration': '35 min',
      'icon': '🍗',
    },
    {
      'name': 'Gulab Jamun',
      'type': 'Dessert',
      'duration': '20 min',
      'icon': '🍮',
    },
    {
      'name': 'Chicken Tikka',
      'type': 'Non-Veg',
      'duration': '28 min',
      'icon': '🍗',
    },
    {'name': 'Veg Biryani', 'type': 'Veg', 'duration': '30 min', 'icon': '🍛'},
    {'name': 'Palak Paneer', 'type': 'Veg', 'duration': '20 min', 'icon': '🥬'},
    {
      'name': 'Fish Curry',
      'type': 'Non-Veg',
      'duration': '25 min',
      'icon': '🐟',
    },
    {
      'name': 'Mutton Rogan Josh',
      'type': 'Non-Veg',
      'duration': '45 min',
      'icon': '🍖',
    },
    {'name': 'Idli Sambar', 'type': 'Veg', 'duration': '10 min', 'icon': '🥞'},
    {
      'name': 'Chole Bhature',
      'type': 'Veg',
      'duration': '20 min',
      'icon': '🍛',
    },
  ];

  @override
  void onInit() {
    super.onInit();
    loadRecentSearches();
  }

  void loadRecentSearches() {
    // Load from shared preferences or local storage
    recentSearches.value = [
      'Chicken Biryani',
      'Paneer Butter Masala',
      'Masala Dosa',
    ];
  }

  void onSearchTextChanged(String text) {
    searchText.value = text;
    if (text.isNotEmpty) {
      performSearch(text);
    } else {
      searchResults.clear();
    }
  }

  void performSearch(String query) {
    isLoading.value = true;

    // Simulate API delay
    Future.delayed(const Duration(milliseconds: 200), () {
      searchResults.value =
          allRecipes
              .where(
                (item) => item['name'].toString().toLowerCase().contains(
                  query.toLowerCase(),
                ),
              )
              .toList();

      isLoading.value = false;
    });
  }

  // Get related suggestions based on search text
  List<String> getRelatedSuggestions(String query) {
    if (query.isEmpty) return [];

    final suggestions =
        allRecipes
            .map((item) => item['name'] as String)
            .where((name) => name.toLowerCase().contains(query.toLowerCase()))
            .take(5)
            .toList();

    return suggestions;
  }

  void addToRecentSearch(String search) {
    // Remove if already exists
    recentSearches.remove(search);
    // Add to beginning
    recentSearches.insert(0, search);
    // Keep only last 10
    if (recentSearches.length > 10) {
      recentSearches.removeLast();
    }
    // Save to storage (implement as needed)
    saveRecentSearches();
  }

  void saveRecentSearches() {
    // Save to shared preferences
    // For now, just print
    print('Saved recent searches: $recentSearches');
  }

  void clearSearch() {
    searchText.value = '';
    searchResults.clear();
    isSearching.value = false;
  }

  void clearRecentSearches() {
    recentSearches.clear();
    saveRecentSearches();
  }

  void removeRecentSearch(int index) {
    recentSearches.removeAt(index);
    saveRecentSearches();
  }

  void onSearchSubmitted(String query) {
    if (query.isNotEmpty) {
      addToRecentSearch(query);
      performSearch(query);
      isSearching.value = false;
    }
  }
}
