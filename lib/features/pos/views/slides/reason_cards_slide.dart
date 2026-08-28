// =============================================================================
// reason_cards_slide.dart
// Slide type: reasonCards — mascot + chat bubble + reason cards + highlight.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../home/models/pos_data_model.dart';

class ReasonCardsSlide extends StatelessWidget {
  final PosSlide slide;

  const ReasonCardsSlide({super.key, required this.slide});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // ── Mascot + Chat Bubble ──────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mascot
              if (slide.mascotImagePath != null)
                SizedBox(
                  width: 64,
                  height: 64,
                  child: slide.mascotImagePath!.endsWith('.svg')
                      ? SvgPicture.asset(
                          slide.mascotImagePath!,
                          fit: BoxFit.contain,
                        )
                      : Image.asset(
                          slide.mascotImagePath!,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.image_outlined,
                            size: 48,
                            color: AppColors.orange300,
                          ),
                        ),
                ),
              const SizedBox(width: 8),
              // Chat bubble
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCEECB),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    slide.chatBubbleText ?? slide.title,
                    style: AppTypography.titleLargeBold.copyWith(
                      color: const Color(0xFF4A2C00),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── 3 Reason Cards ──────────────────────────────────
          if (slide.reasonCards != null)
            ...slide.reasonCards!.map((card) {
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCEECB),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon
                    Icon(card.icon, size: 28, color: const Color(0xFF4A2C00)),
                    const SizedBox(width: 12),
                    // Text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            card.title,
                            style: AppTypography.titleSmallBold.copyWith(
                              color: const Color(0xFF4A2C00),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            card.subtitle,
                            style: AppTypography.bodyMediumRegular.copyWith(
                              color: const Color(0xFF6E5136),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),

          // ── Highlight Takeaway Box ──────────────────────────
          if (slide.highlightTitle != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFD4E7DC),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.lightbulb_outline,
                    size: 24,
                    color: Color(0xFF1E3E2E),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          slide.highlightTitle!,
                          style: AppTypography.titleSmallBold.copyWith(
                            color: const Color(0xFF1E3E2E),
                          ),
                        ),
                        if (slide.highlightBody != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            slide.highlightBody!,
                            style: AppTypography.bodyMediumRegular.copyWith(
                              color: const Color(0xFF1E3E2E),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
