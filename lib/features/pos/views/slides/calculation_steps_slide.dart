// =============================================================================
// calculation_steps_slide.dart
// Slide type: calculationSteps — mascot + chat bubble + numbered steps + highlight.
// Scene 6: "Uang gajiku ke mana?"
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_typography.dart';
import '../../../home/models/pos_data_model.dart';

class CalculationStepsSlide extends StatelessWidget {
  final PosSlide slide;

  const CalculationStepsSlide({super.key, required this.slide});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Mascot + Chat Bubble ──────────────────────────────
          if (slide.mascotImagePath != null || slide.chatBubbleText != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
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

          // ── Section Title ──────────────────────────────────────
          if (slide.sectionTitle != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                slide.sectionTitle!,
                style: AppTypography.titleMediumBold.copyWith(
                  color: const Color(0xFF4A2C00),
                ),
              ),
            ),

          // ── Calculation Step Cards ────────────────────────────
          if (slide.calculationSteps != null)
            ...slide.calculationSteps!.map((step) {
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
                    // ── Number ──────────────────────────────────
                    Text(
                      '${step.number}',
                      style: AppTypography.headlineMediumBold.copyWith(
                        color: const Color(0xFF4A2C00),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // ── Content ─────────────────────────────────
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step.title,
                            style: AppTypography.bodyMediumMedium.copyWith(
                              color: const Color(0xFF4A2C00),
                            ),
                          ),
                          if (step.caption != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              step.caption!,
                              style: AppTypography.bodySmallRegular.copyWith(
                                color: const Color(0xFF6E5335),
                              ),
                            ),
                          ],
                          const SizedBox(height: 4),
                          Text(
                            step.formula,
                            style: AppTypography.titleSmallBold.copyWith(
                              color: const Color(0xFF4A2C00),
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
