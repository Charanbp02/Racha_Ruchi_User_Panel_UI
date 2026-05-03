import 'package:get/get.dart';

class CommentModel {
  final String id;
  final String userName;
  final String userImage;
  final String comment;
  final String timeAgo;
  final String likes;
  final String replies;
  var isLiked = false.obs;

  CommentModel({
    required this.id,
    required this.userName,
    required this.userImage,
    required this.comment,
    required this.timeAgo,
    required this.likes,
    required this.replies,
  });
}
