// lib/App/Modules/VideoPlayer/view/comments_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iconsax/iconsax.dart';

class CommentsBottomSheet extends StatefulWidget {
  final String videoId;
  final String videoTitle;
  final int commentCount;
  final ScrollController scrollController;
  final Function(int) onCommentCountChanged;

  const CommentsBottomSheet({
    super.key,
    required this.videoId,
    required this.videoTitle,
    required this.commentCount,
    required this.scrollController,
    required this.onCommentCountChanged,
  });

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _postComment() async {
    final user = _auth.currentUser;
    if (user == null) {
      Get.snackbar(
        'Login Required',
        'Please login to comment',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (_commentController.text.trim().isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final commentRef =
          _firestore
              .collection('recipe_videos')
              .doc(widget.videoId)
              .collection('comments')
              .doc();

      await commentRef.set({
        'commentId': commentRef.id,
        'userId': user.uid,
        'userName': user.displayName ?? 'User',
        'userEmail': user.email,
        'userPhoto': user.photoURL ?? '',
        'comment': _commentController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
        'likes': 0,
      });

      await _firestore.collection('recipe_videos').doc(widget.videoId).update({
        'comments': FieldValue.increment(1),
      });

      widget.onCommentCountChanged(widget.commentCount + 1);
      _commentController.clear();

      if (mounted) {
        Get.snackbar(
          'Success',
          'Comment posted!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 1),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('Error posting comment: $e');
      if (mounted) {
        Get.snackbar(
          'Error',
          'Could not post comment',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 12, bottom: 8),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const Icon(Iconsax.message, size: 20),
              const SizedBox(width: 8),
              Text(
                'Comments (${widget.commentCount})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Iconsax.close_circle),
                onPressed: () => Get.back(),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream:
                _firestore
                    .collection('recipe_videos')
                    .doc(widget.videoId)
                    .collection('comments')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final comments = snapshot.data!.docs;

              if (comments.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.message, size: 50, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No comments yet',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Be the first to comment!',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                controller: widget.scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final comment =
                      comments[index].data() as Map<String, dynamic>;
                  return _buildCommentCard(comment);
                },
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey[200]!)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage:
                    _auth.currentUser?.photoURL != null
                        ? NetworkImage(_auth.currentUser!.photoURL!)
                        : null,
                child:
                    _auth.currentUser?.photoURL == null
                        ? const Icon(Iconsax.user, size: 20)
                        : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'Write a comment...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _postComment(),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: _isLoading ? null : _postComment,
                icon:
                    _isLoading
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Icon(Iconsax.send_1, color: Colors.red),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCommentCard(Map<String, dynamic> comment) {
    final isCurrentUser = comment['userId'] == _auth.currentUser?.uid;
    final timestamp = (comment['createdAt'] as Timestamp?)?.toDate();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage:
                comment['userPhoto'] != null && comment['userPhoto'].isNotEmpty
                    ? NetworkImage(comment['userPhoto'])
                    : null,
            child:
                comment['userPhoto'] == null || comment['userPhoto'].isEmpty
                    ? const Icon(Iconsax.user, size: 20)
                    : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment['userName'] ?? 'User',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (timestamp != null)
                      Text(
                        _formatTimeAgo(timestamp),
                        style: TextStyle(color: Colors.grey[400], fontSize: 11),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(comment['comment'], style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Like',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(width: 16),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Reply',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isCurrentUser)
            PopupMenuButton(
              icon: const Icon(Iconsax.more, size: 18),
              itemBuilder:
                  (context) => [
                    const PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
              onSelected: (value) {
                if (value == 'delete') {
                  _deleteComment(comment['commentId']);
                }
              },
            ),
        ],
      ),
    );
  }

  Future<void> _deleteComment(String commentId) async {
    try {
      await _firestore
          .collection('recipe_videos')
          .doc(widget.videoId)
          .collection('comments')
          .doc(commentId)
          .delete();

      await _firestore.collection('recipe_videos').doc(widget.videoId).update({
        'comments': FieldValue.increment(-1),
      });

      widget.onCommentCountChanged(widget.commentCount - 1);

      if (mounted) {
        Get.snackbar(
          'Deleted',
          'Comment deleted',
          backgroundColor: Colors.grey,
          colorText: Colors.white,
          duration: const Duration(seconds: 1),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('Error deleting comment: $e');
    }
  }

  String _formatTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
