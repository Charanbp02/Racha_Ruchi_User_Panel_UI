/// Bunny Video Model
class BunnyVideo {
  final String? guid;
  final String? title;
  final String? description;
  final String? uploadUrl;
  final String? thumbnailUrl;
  final int? length;
  final String? status;
  final int? views;
  final bool? isPublic;
  final bool? isListed;
  final DateTime? createdAt;
  final Map<String, dynamic>? metaTags;

  BunnyVideo({
    this.guid,
    this.title,
    this.description,
    this.uploadUrl,
    this.thumbnailUrl,
    this.length,
    this.status,
    this.views,
    this.isPublic,
    this.isListed,
    this.createdAt,
    this.metaTags,
  });

  factory BunnyVideo.fromJson(Map<String, dynamic> json) {
    return BunnyVideo(
      guid: json['guid'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      uploadUrl: json['uploadUrl'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      length: json['length'] as int?,
      status: json['status'] as String?,
      views: json['views'] as int?,
      isPublic: json['isPublic'] as bool?,
      isListed: json['isListed'] as bool?,
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'] as String)
              : null,
      metaTags: json['metaTags'] as Map<String, dynamic>?,
    );
  }
}

/// Bunny Upload Result Model
class BunnyUploadResult {
  final String videoId;
  final String videoUrl;
  final String hlsUrl;
  final String thumbnailUrl;
  final String title;
  final String description;
  final int duration;
  final String status;

  BunnyUploadResult({
    required this.videoId,
    required this.videoUrl,
    required this.hlsUrl,
    required this.thumbnailUrl,
    required this.title,
    required this.description,
    required this.duration,
    required this.status,
  });
}
