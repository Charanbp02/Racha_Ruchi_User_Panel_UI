class RecipeModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String cookingTime;
  final String servings;
  final String difficulty;
  final String likes;
  final String comments;
  final String status;
  final String createdAt;
  final String cuisine;
  final String category;
  bool isFavorite;

  RecipeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.cookingTime,
    required this.servings,
    required this.difficulty,
    required this.likes,
    required this.comments,
    required this.status,
    required this.createdAt,
    required this.cuisine,
    required this.category,
    this.isFavorite = false,
  });
}
