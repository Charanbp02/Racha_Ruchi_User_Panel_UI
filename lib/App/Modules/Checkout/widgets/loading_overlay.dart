import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class LoadingOverlay extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Color? accentColor;
  final bool showProgress;
  final double? progressValue;
  final String? progressText;
  final Widget? customIcon;
  final bool showCancelButton;
  final VoidCallback? onCancel;
  final Duration? animationDuration;

  const LoadingOverlay({
    super.key,
    this.title,
    this.subtitle,
    this.accentColor,
    this.showProgress = false,
    this.progressValue,
    this.progressText,
    this.customIcon,
    this.showCancelButton = false,
    this.onCancel,
    this.animationDuration,
  });

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? const Color(0xFFE53935);
    final theme = Theme.of(context);

    return Container(
      color: Colors.black.withValues(alpha: 0.55),
      child: Center(
        child: AnimatedContainer(
          duration: animationDuration ?? const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 40,
                offset: const Offset(0, 12),
                spreadRadius: 4,
              ),
            ],
            border: Border.all(color: Colors.grey.shade100, width: 1.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon or Custom Widget
              if (customIcon != null)
                customIcon!
              else
                _buildLoadingIndicator(color, theme),

              const SizedBox(height: 24),

              // Title
              Text(
                title ?? 'Placing Order...',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A2E),
                  letterSpacing: -0.3,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              // Subtitle
              Text(
                subtitle ?? 'Please wait a moment',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),

              // Progress Indicator (Optional)
              if (showProgress) ...[
                const SizedBox(height: 20),
                _buildProgressIndicator(color, theme),
                if (progressText != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    progressText!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],

              // Cancel Button (Optional)
              if (showCancelButton) ...[
                const SizedBox(height: 24),
                _buildCancelButton(color),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(Color color, ThemeData theme) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer ring animation
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withValues(alpha: 0.08),
                color.withValues(alpha: 0.02),
              ],
            ),
          ),
          child: const CircularProgressIndicator(
            color: Color(0xFFE53935),
            strokeWidth: 3.5,
          ),
        ),
        // Inner icon
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.06),
            shape: BoxShape.circle,
          ),
          child: Icon(Iconsax.timer, color: color, size: 24),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator(Color color, ThemeData theme) {
    return Column(
      children: [
        SizedBox(
          width: 200,
          height: 6,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progressValue,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ),
        if (progressText != null) ...[
          const SizedBox(height: 8),
          Text(
            progressText!,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCancelButton(Color color) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onCancel,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.grey.shade700,
          side: BorderSide(color: Colors.grey.shade300, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          backgroundColor: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.close_circle, size: 18, color: Colors.grey.shade600),
            const SizedBox(width: 8),
            Text(
              'Cancel',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

// Simplified version with common use cases
class LoadingOverlaySimple extends StatelessWidget {
  final String message;
  final bool isProcessing;

  const LoadingOverlaySimple({
    super.key,
    this.message = 'Processing...',
    this.isProcessing = true,
  });

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(title: message, showProgress: isProcessing);
  }
}

// Order specific loading overlay
class OrderLoadingOverlay extends StatelessWidget {
  final double? progress;
  final VoidCallback? onCancel;

  const OrderLoadingOverlay({super.key, this.progress, this.onCancel});

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      title: progress == null ? 'Placing Order...' : 'Processing Order',
      subtitle:
          progress == null
              ? 'Please wait a moment'
              : 'Your order is being processed',
      showProgress: true,
      progressValue: progress,
      progressText:
          progress != null ? '${(progress! * 100).toInt()}% Complete' : null,
      showCancelButton: onCancel != null,
      onCancel: onCancel,
      customIcon: progress == null ? null : _buildProgressIcon(context),
    );
  }

  Widget _buildProgressIcon(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFE53935).withValues(alpha: 0.12),
            const Color(0xFFE53935).withValues(alpha: 0.05),
          ],
        ),
      ),
      child: Center(
        child: Text(
          '${(progress! * 100).toInt()}%',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Color(0xFFE53935),
          ),
        ),
      ),
    );
  }
}

// Usage example with different loading states
class LoadingOverlayExample extends StatelessWidget {
  const LoadingOverlayExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Default loading
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const LoadingOverlay(),
            );
          },
          child: const Text('Show Default Loading'),
        ),

        // Custom loading
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder:
                  (_) => const LoadingOverlay(
                    title: 'Processing Payment',
                    subtitle: 'Please do not close the app',
                    showCancelButton: true,
                  ),
            );
          },
          child: const Text('Show Custom Loading'),
        ),

        // Order loading with progress
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder:
                  (_) =>
                      const OrderLoadingOverlay(progress: 0.45, onCancel: null),
            );
          },
          child: const Text('Show Order Loading'),
        ),

        // Simple loading
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder:
                  (_) => const LoadingOverlaySimple(
                    message: 'Saving...',
                    isProcessing: true,
                  ),
            );
          },
          child: const Text('Show Simple Loading'),
        ),
      ],
    );
  }
}
