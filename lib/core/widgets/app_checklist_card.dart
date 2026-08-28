// =============================================================================
// app_checklist_card.dart
// Komponen reusable checklist card untuk CoreTax Checklist.
// Variants: active (checked - hijau pastel) & inactive (unchecked - krem).
// =============================================================================

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class AppChecklistCard extends StatelessWidget {
  /// Teks judul item checklist.
  final String title;

  /// Status apakah item sudah dicentang.
  final bool isChecked;

  /// Callback saat card ditekan.
  final VoidCallback? onTap;

  const AppChecklistCard({
    super.key,
    required this.title,
    this.isChecked = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isChecked ? _activeBgColor : _inactiveBgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Leading Indicator ─────────────────────────────────────
            _buildIndicator(),
            const SizedBox(width: 12),

            // ── Title Text ───────────────────────────────────────────
            Expanded(
              child: Text(
                title,
                style: AppTypography.titleMediumBold.copyWith(
                  color: isChecked ? AppColors.green900 : AppColors.orange900,
                ),
                maxLines: 3,
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Leading Indicator ──────────────────────────────────────────────────────
  // Active: circle solid hijau tua dengan checkmark putih.
  // Inactive: circle outline cokelat tua.
  Widget _buildIndicator() {
    if (isChecked) {
      return Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          color: AppColors.green600,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, size: 16, color: AppColors.green50),
      );
    }

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.orange900, width: 3),
      ),
    );
  }

  // ─── Background Colors ─────────────────────────────────────────────────────
  Color get _activeBgColor => AppColors.green200; // Hijau pastel sage
  Color get _inactiveBgColor => AppColors.orange100; // Krem keemasan
}
