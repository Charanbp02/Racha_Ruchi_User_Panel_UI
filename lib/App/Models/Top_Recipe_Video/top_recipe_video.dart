class RecipeModel {
  final String id;
  final String title;
  final String duration;
  final String imageUrl;
  final String? videoUrl;
  final String views;
  final String rating;
  final String chef;
  final String description;

  RecipeModel({
    required this.id,
    required this.title,
    required this.duration,
    required this.imageUrl,
    this.videoUrl,
    required this.views,
    required this.rating,
    required this.chef,
    required this.description,
  });
}
