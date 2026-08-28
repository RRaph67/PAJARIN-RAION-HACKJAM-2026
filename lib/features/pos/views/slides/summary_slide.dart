// =============================================================================
// summary_slide.dart
// Slide type: summary — ringkasan materi (bullet points).
// =============================================================================

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../home/models/pos_data_model.dart';

class SummarySlide extends StatelessWidget {
  final PosSlide slide;

  const SummarySlide({super.key, required this.slide});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.green100,
        borderRadius: BorderRadius.circular(24),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Title ─────────────────────────────────────────────
            Center(child: Text('🎉', style: const TextStyle(fontSize: 48))),
            const SizedBox(height: 12),
            Center(
              child: Text(
                slide.title,
                style: AppTypography.titleLargeBold.copyWith(
                  color: AppColors.orange950,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),

            // ── Body (bullet points) ─────────────────────────────
            if (slide.body != null)
              Text(
                slide.body!,
                style: AppTypography.bodyMediumMedium.copyWith(
                  color: AppColors.orange950,
                  height: 2.0,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
