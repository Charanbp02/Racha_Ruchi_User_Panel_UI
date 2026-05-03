class PopularRecipeModel {
  final String id;
  final String title;
  final String duration;
  final String rating;
  final String imageUrl;
  final String calories;
  final String category;
  final String? videoUrl; // Add this field

  PopularRecipeModel({
    required this.id,
    required this.title,
    required this.duration,
    required this.rating,
    required this.imageUrl,
    required this.calories,
    required this.category,
    this.videoUrl, // Make it optional
  });
}
