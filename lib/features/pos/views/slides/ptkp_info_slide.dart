// =============================================================================
// ptkp_info_slide.dart
// Slide type: ptkpInfo — kenalan dengan PTKP + 2 info cards + tip box.
// Pos 2 Scene 2: "Kenalan dengan PTKP"
// =============================================================================

import 'package:flutter/material.dart';

import '../../../../core/theme/app_typography.dart';
import '../../../home/models/pos_data_model.dart';

class PtkpInfoSlide extends StatelessWidget {
  final PosSlide slide;

  const PtkpInfoSlide({super.key, required this.slide});

  @override
  Widget build(BuildContext context) {
    final infoCards = slide.ptkpInfoCards ?? [];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title Area ────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              slide.title,
              style: AppTypography.headlineMediumBold.copyWith(
                color: const Color(0xFF4A2C00),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (slide.subtitle != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                slide.subtitle!,
                style: AppTypography.titleMediumBold.copyWith(
                  color: const Color(0xFF4A2C00),
                ),
                textAlign: TextAlign.center,
              ),
            ),

          // ── Description (RichText with bold support) ─────────
          if (slide.description != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _buildRichText(slide.description!),
            ),

          // ── Dual Info Cards ──────────────────────────────────
          if (infoCards.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: infoCards.map((card) {
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBE3B5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            card.icon,
                            size: 40,
                            color: const Color(0xFF4A2C00),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            card.label,
                            style: AppTypography.titleSmallBold.copyWith(
                              color: const Color(0xFF4A2C00),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

          // ── Highlight Tip Box ────────────────────────────────
          if (slide.tipTitle != null || slide.tipBody != null)
            Container(
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
        ],
      ),
    );
  }

  /// Build RichText with **bold** markers from **text** format
  Widget _buildRichText(String text) {
    final spans = <TextSpan>[];
    final regex = RegExp(r'\*\*(.+?)\*\*');
    int lastIndex = 0;

    for (final match in regex.allMatches(text)) {
      // Text before bold
      if (match.start > lastIndex) {
        spans.add(
          TextSpan(
            text: text.substring(lastIndex, match.start),
            style: AppTypography.bodyMediumMedium.copyWith(
              color: const Color(0xFF4A2C00),
            ),
          ),
        );
      }
      // Bold text
      spans.add(
        TextSpan(
          text: match.group(1),
          style: AppTypography.bodyMediumBold.copyWith(
            color: const Color(0xFF4A2C00),
          ),
        ),
      );
      lastIndex = match.end;
    }

    // Remaining text
    if (lastIndex < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(lastIndex),
          style: AppTypography.bodyMediumMedium.copyWith(
            color: const Color(0xFF4A2C00),
          ),
        ),
      );
    }

    if (spans.isEmpty) {
      return Text(
        text,
        style: AppTypography.bodyMediumMedium.copyWith(
          color: const Color(0xFF4A2C00),
        ),
      );
    }

    return RichText(text: TextSpan(children: spans));
  }
}
