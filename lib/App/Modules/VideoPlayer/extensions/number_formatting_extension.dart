// lib/App/Modules/VideoPlayer/extensions/number_formatting_extension.dart

extension NumberFormatting on int {
  String formatNumber() {
    if (this >= 1000000) return '${(this / 1000000).toStringAsFixed(1)}M';
    if (this >= 1000) return '${(this / 1000).toStringAsFixed(1)}K';
    return toString();
  }
}
