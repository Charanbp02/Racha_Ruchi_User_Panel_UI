import 'package:get/get.dart';

class CategoryController extends GetxController {
  var categories =
      [
        // Veg Categories
        {'name': 'Pure Veg', 'icon': '🌱'},
        {'name': 'Vegetarian Specials', 'icon': '🥗'},
        {'name': 'Veg Delights', 'icon': '🥕'},
        {'name': 'Green Kitchen', 'icon': '🥬'},
        {'name': 'Garden Fresh', 'icon': '🌿'},
        {'name': 'Veggie Paradise', 'icon': '🍅'},
        {'name': 'Healthy Veg', 'icon': '🥑'},
        {'name': 'Satvik Foods', 'icon': '🍚'},
        {'name': 'Plant-Based Picks', 'icon': '🌾'},
        {'name': 'Veg Feast', 'icon': '🍛'},
        {'name': 'Fresh Veg Menu', 'icon': '🥒'},
        {'name': 'Homestyle Veg', 'icon': '🍲'},
        {'name': 'Veg Treats', 'icon': '🍠'},
        {'name': 'Classic Veg Dishes', 'icon': '🍆'},
        {'name': 'Indian Veg Specials', 'icon': '🇮🇳'},

        // Non-Veg Categories
        {'name': 'Non-Veg Specials', 'icon': '🍗'},
        {'name': 'Meat Lovers', 'icon': '🥩'},
        {'name': 'Chicken Corner', 'icon': '🍗'},
        {'name': 'Mutton Delights', 'icon': '🍖'},
        {'name': 'Seafood Specials', 'icon': '🦐'},
        {'name': 'Protein Feast', 'icon': '🍳'},
        {'name': 'Non-Veg Treats', 'icon': '🍖'},
        {'name': 'Grill & BBQ', 'icon': '🔥'},
        {'name': 'Spicy Non-Veg', 'icon': '🌶️'},
        {'name': 'Royal Non-Veg', 'icon': '👑'},
        {'name': 'Non-Veg Combo Meals', 'icon': '🍱'},
        {'name': 'Street Style Non-Veg', 'icon': '🍢'},
        {'name': 'Exotic Meats', 'icon': '🐑'},
        {'name': 'Chef\'s Non-Veg Picks', 'icon': '👨‍🍳'},
        {'name': 'Tandoori Specials', 'icon': '🔥'},
      ].obs;

  var selectedIndex = 0.obs;

  void selectCategory(int index) {
    selectedIndex.value = index;
    print('Selected: ${categories[index]['name']}');
  }
}
