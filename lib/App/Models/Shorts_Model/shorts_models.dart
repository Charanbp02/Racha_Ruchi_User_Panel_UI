class ShortsModel {
  final String id;
  final String imageUrl;
  final String title;
  final String caption;
  String likes;
  String comments;
  String shares;
  final String user;
  final String userImage;
  bool isLiked;
  bool isSaved;

  ShortsModel({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.caption,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.user,
    required this.userImage,
    this.isLiked = false,
    this.isSaved = false,
  });
}
