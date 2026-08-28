// =============================================================================
// grid_cards_slide.dart
// Slide type: gridCards — dynamic title + 2x2 grid cards + highlight info.
// Scene 7: "Pajak [Nama] gak hilang begitu saja."
// =============================================================================

import 'package:flutter/material.dart';

import '../../../../core/theme/app_typography.dart';
import '../../../home/models/pos_data_model.dart';

class GridCardsSlide extends StatelessWidget {
  final PosSlide slide;
  final String userName;

  const GridCardsSlide({
    super.key,
    required this.slide,
    this.userName = 'Rafi',
  });

  @override
  Widget build(BuildContext context) {
    final gridCards = slide.gridCards ?? [];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title (dynamic user name) ────────────────────────
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Pajak $userName gak hilang begitu saja.',
              style: AppTypography.titleLargeBold.copyWith(
                color: const Color(0xFF4A2C00),
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // ── Subtitle ─────────────────────────────────────────
          if (slide.subtitle != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                slide.subtitle!,
                style: AppTypography.bodyMediumMedium.copyWith(
                  color: const Color(0xFF6E5335),
                ),
                textAlign: TextAlign.center,
              ),
            ),

          // ── 2x2 Grid Cards ──────────────────────────────────
          if (gridCards.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.2,
                children: gridCards.map((card) {
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCEECB),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ── Icon ──────────────────────────────
                        Icon(
                          card.icon,
                          size: 32,
                          color: const Color(0xFF4A2C00),
                        ),
                        const SizedBox(height: 8),
                        // ── Title ─────────────────────────────
                        Text(
                          card.title,
                          style: AppTypography.titleSmallBold.copyWith(
                            color: const Color(0xFF4A2C00),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        // ── Subtitle ──────────────────────────
                        Text(
                          card.subtitle,
                          style: AppTypography.bodySmallRegular.copyWith(
                            color: const Color(0xFF6E5335),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

          // ── Highlight Info Box ───────────────────────────────
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
