// =============================================================================
// payslip_comparison_slide.dart
// Slide type: payslipComparison — perbandingan slip gaji antara 2 user.
// Pos 2 Scene 1: "Gaji kita sama, kok potongannya beda?"
// Pos 2 Scene 3: "Perbandingan Detail Profil PTKP"
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_typography.dart';
import '../../../home/models/pos_data_model.dart';

class PayslipComparisonSlide extends StatelessWidget {
  final PosSlide slide;
  final String userName;

  const PayslipComparisonSlide({
    super.key,
    required this.slide,
    this.userName = 'Rafi',
  });

  @override
  Widget build(BuildContext context) {
    final cards = slide.comparisonCards ?? [];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title (optional) ──────────────────────────────────
          if (slide.title.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                slide.title,
                style: AppTypography.titleLargeBold.copyWith(
                  color: const Color(0xFF4A2C00),
                ),
                textAlign: TextAlign.center,
              ),
            ),

          // ── Description (optional) ────────────────────────────
          if (slide.description != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                slide.description!,
                style: AppTypography.bodyMediumMedium.copyWith(
                  color: const Color(0xFF4A2C00),
                ),
                textAlign: TextAlign.center,
              ),
            ),

          // ── Comparison Cards ──────────────────────────────────
          ...cards.map((card) {
            // Replace [Nama User] with actual name
            final processedTitle = card.title.replaceAll(
              '[Nama User]',
              userName,
            );

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBE3B5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Card Title ──────────────────────────────
                    Text(
                      processedTitle,
                      style: AppTypography.titleMediumBold.copyWith(
                        color: const Color(0xFF4A2C00),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: const Color(0xFF4A2C00).withValues(alpha: 0.15),
                    ),
                    const SizedBox(height: 12),

                    // ── Rows ────────────────────────────────────
                    ...card.rows.map((row) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFBF0),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                row.label,
                                style: AppTypography.bodyMediumMedium.copyWith(
                                  color: const Color(0xFF4A2C00),
                                ),
                              ),
                              Text(
                                row.value,
                                style:
                                    (row.isBold
                                            ? AppTypography.bodyMediumBold
                                            : AppTypography.bodyMediumMedium)
                                        .copyWith(
                                          color: const Color(0xFF4A2C00),
                                        ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            );
          }),

          // ── Mascot + Chat Bubble (optional) ───────────────────
          if (slide.mascotImagePath != null || slide.chatBubbleText != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
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
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFBE3B5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          slide.chatBubbleText!,
                          style: AppTypography.titleLargeBold.copyWith(
                            color: const Color(0xFF4A2C00),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

          // ── Highlight Tip Box (optional) ──────────────────────
          if (slide.tipTitle != null || slide.tipBody != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFC7E2D4),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.lightbulb_outline,
                      size: 24,
                      color: Color(0xFF2D5E46),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (slide.tipTitle != null)
                            Text(
                              slide.tipTitle!,
                              style: AppTypography.bodyMediumBold.copyWith(
                                color: const Color(0xFF1E3E2E),
                              ),
                            ),
                          if (slide.tipTitle != null && slide.tipBody != null)
                            const SizedBox(height: 4),
                          if (slide.tipBody != null)
                            Text(
                              slide.tipBody!,
                              style: AppTypography.bodySmallMedium.copyWith(
                                color: const Color(0xFF2D5E46),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
