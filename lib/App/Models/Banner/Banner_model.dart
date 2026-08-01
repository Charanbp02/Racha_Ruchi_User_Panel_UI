// BannerItem Model remains the same
class BannerItem {
  final String id;
  final String imageUrl;
  final String title;
  final String subtitle;
  final String badge;
  final String type;
  final int order;
  final String? link;

  BannerItem({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.type,
    required this.order,
    this.link,
  });
}
