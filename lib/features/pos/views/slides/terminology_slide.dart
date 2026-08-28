// =============================================================================
// terminology_slide.dart
// Slide type: terminology — centered title + education cards.
// =============================================================================

import 'package:flutter/material.dart';

import '../../../../core/theme/app_typography.dart';
import '../../../home/models/pos_data_model.dart';

class TerminologySlide extends StatelessWidget {
  final PosSlide slide;

  const TerminologySlide({super.key, required this.slide});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // ── Centered Title ──────────────────────────────────
          Text(
            slide.title,
            style: AppTypography.titleLargeBold.copyWith(
              color: const Color(0xFF4A2C00),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // ── 4 Terminology Cards ────────────────────────────
          if (slide.terminologyItems != null)
            ...slide.terminologyItems!.map((item) {
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4E7DC),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon (optional)
                    if (item.icon != null) ...[
                      Icon(
                        item.icon!,
                        size: 28,
                        color: const Color(0xFF1E3E2E),
                      ),
                      const SizedBox(width: 12),
                    ],
                    // Text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: AppTypography.titleSmallBold.copyWith(
                              color: const Color(0xFF1E3E2E),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.description,
                            style: AppTypography.bodyMediumRegular.copyWith(
                              color: const Color(0xFF1E3E2E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
