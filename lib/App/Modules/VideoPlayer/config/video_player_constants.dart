// lib/App/Modules/VideoPlayer/config/video_player_constants.dart

class VideoPlayerConstants {
  static const int viewThresholdSeconds = 30;
  static const double viewThresholdPercentage = 0.5;
  static const int progressUpdateIntervalMs = 100;
  static const int controlsHideDelaySeconds = 3;
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 2);
  static const int maxBufferSizeMB = 50;
}
