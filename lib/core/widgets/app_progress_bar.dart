// =============================================================================
// app_progress_bar.dart
// Komponen progress bar reusable untuk seluruh aplikasi.
// Terdiri dari dua layer: background (orange100) dan fill (orange800).
// Default: width 361, height 10, rounded 12.
// =============================================================================

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppProgressBar extends StatelessWidget {
  /// Nilai progress dari 0.0 sampai 1.0.
  final double progress;

  /// Lebar komponen. Default: 361.
  final double width;

  /// Tinggi komponen. Default: 10.
  final double height;

  /// Warna background. Default: AppColors.orange100.
  final Color backgroundColor;

  /// Warna fill/isi. Default: AppColors.orange800.
  final Color fillColor;

  /// Rounded corner. Default: 12.
  final double borderRadius;

  const AppProgressBar({
    super.key,
    required this.progress,
    this.width = 361,
    this.height = 10,
    this.backgroundColor = AppColors.orange100,
    this.fillColor = AppColors.orange800,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    // Clamp progress between 0.0 and 1.0
    final double clampedProgress = progress.clamp(0.0, 1.0);

    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          children: [
            // Background layer
            Container(width: width, height: height, color: backgroundColor),
            // Fill layer
            AnimatedFractionallySizedBox(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              widthFactor: clampedProgress,
              child: Container(
                width: width * clampedProgress,
                height: height,
                decoration: BoxDecoration(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
