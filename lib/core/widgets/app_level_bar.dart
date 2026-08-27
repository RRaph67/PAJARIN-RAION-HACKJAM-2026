// =============================================================================
// app_level_bar.dart
// Komponen reusable level bar dengan indikator step.
// =============================================================================

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppLevelBar extends StatelessWidget {
  /// Step aktif saat ini (berbasis angka step, misal 1, 2, atau 3)
  final int activeSteps;

  /// Lebar per step (default 115)
  final double stepWidth;

  /// Tinggi per step (default 10)
  final double stepHeight;

  /// Warna step aktif (default: orange800)
  final Color activeColor;

  /// Warna step inactive (default: orange100)
  final Color inactiveColor;

  /// Jumlah total step (default: 3)
  final int totalSteps;

  /// Jika true, HANYA step saat ini yang aktif (misal step 2 aktif = cuma bar ke-2 yang oranye tua).
  /// Jika false, step 1 sampai activeSteps akan aktif seperti progress bar (default: false).
  final bool highlightCurrentOnly;

  const AppLevelBar({
    super.key,
    required this.activeSteps,
    this.stepWidth = 115,
    this.stepHeight = 10,
    this.activeColor = AppColors.orange800,
    this.inactiveColor = AppColors.orange100,
    this.totalSteps = 3,
    this.highlightCurrentOnly = false, // <-- Tambahan parameter
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalSteps * 2 - 1, (index) {
        // Ganjil = gap 8
        if (index.isOdd) return const SizedBox(width: 8);

        final stepIndex = index ~/ 2;

        // Logika penentuan status aktif:
        // - Jika highlightCurrentOnly = true: hanya bar dengan index pas (activeSteps - 1) yang aktif
        // - Jika highlightCurrentOnly = false: semua bar dari 0 hingga (activeSteps - 1) aktif
        final bool isActive = highlightCurrentOnly
            ? stepIndex == (activeSteps - 1)
            : stepIndex < activeSteps;

        return Container(
          width: stepWidth,
          height: stepHeight,
          decoration: BoxDecoration(
            color: isActive ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
    );
  }
}
