// =============================================================================
// ter_reconciliation_slide.dart
// Slide type: terReconciliation — mascot + chat + TER vs reconciliation.
// Scene 10: "Kok potongan bulan Desember bisa beda?"
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_typography.dart';
import '../../../home/models/pos_data_model.dart';

class TerReconciliationSlide extends StatelessWidget {
  final PosSlide slide;

  const TerReconciliationSlide({super.key, required this.slide});

  @override
  Widget build(BuildContext context) {
    final sections = slide.terSections ?? [];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Mascot + Chat Bubble ──────────────────────────────
          if (slide.mascotImagePath != null || slide.chatBubbleText != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
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
                            ),
                    ),
                  const SizedBox(width: 8),
                  // Chat bubble
                  if (slide.chatBubbleText != null)
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFCEECB),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          slide.chatBubbleText!,
                          style: AppTypography.titleMediumBold.copyWith(
                            color: const Color(0xFF4A2C00),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

          // ── Sections (TER & Rekonsiliasi) ─────────────────────
          ...sections.map((section) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header Bar (green chip) ──────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D5E46),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      section.headerLabel,
                      style: AppTypography.titleSmallBold.copyWith(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // ── Body Card (green sage) ──────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC7E2D4),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title with optional icon
                        Row(
                          children: [
                            if (section.icon != null) ...[
                              Icon(
                                section.icon,
                                size: 20,
                                color: const Color(0xFF1E3E2E),
                              ),
                              const SizedBox(width: 8),
                            ],
                            Expanded(
                              child: Text(
                                section.title,
                                style: AppTypography.titleMediumBold.copyWith(
                                  color: const Color(0xFF1E3E2E),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          section.subtitle,
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
