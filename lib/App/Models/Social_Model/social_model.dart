class UserModel {
  final String id;
  final String name;
  final String username;
  final String imageUrl;
  final String bio;
  final int recipes;
  String followers;
  bool isFollowing;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.imageUrl,
    required this.bio,
    required this.recipes,
    required this.followers,
    this.isFollowing = false,
  });
}
