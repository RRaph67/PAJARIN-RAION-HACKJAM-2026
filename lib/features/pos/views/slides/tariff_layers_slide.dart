// =============================================================================
// tariff_layers_slide.dart
// Slide type: tariffLayers — stacked layer visualization for progressive tax.
// Scene 8: "Kenalan dengan Tarif Progresif"
// Scene 9: "Ini yang sering disalahpahami."
// =============================================================================

import 'package:flutter/material.dart';

import '../../../../core/theme/app_typography.dart';
import '../../../home/models/pos_data_model.dart';

class TariffLayersSlide extends StatelessWidget {
  final PosSlide slide;
  final String userName;

  const TariffLayersSlide({
    super.key,
    required this.slide,
    this.userName = 'Rafi',
  });

  @override
  Widget build(BuildContext context) {
    final layers = slide.tariffLayers ?? [];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              slide.title,
              style: AppTypography.titleLargeBold.copyWith(
                color: const Color(0xFF4A2C00),
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // ── Subtitle / Description (RichText support) ─────────
          if (slide.subtitle != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _buildRichText(slide.subtitle!, userName),
            ),

          // ── Stacked Layer Box ──────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFCEECB),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                // ── Layer Header (if exists) ────────────────────
                if (slide.sectionTitle != null) ...[
                  Text(
                    slide.sectionTitle!,
                    style: AppTypography.titleMediumBold.copyWith(
                      color: const Color(0xFF4A2C00),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                ],

                // ── Stacked Layers (top = narrowest, bottom = widest) ──
                ...layers.asMap().entries.map((entry) {
                  final index = entry.key;
                  final layer = entry.value;
                  // Width increases from top to bottom
                  final widthFactor = 0.5 + (index * 0.2);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: FractionallySizedBox(
                      widthFactor: widthFactor,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: layer.color,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                layer.label,
                                style: AppTypography.titleSmallBold.copyWith(
                                  color: layer.textColor,
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (layer.value != null) ...[
                              const SizedBox(width: 8),
                              Text(
                                layer.value!,
                                style: AppTypography.titleSmallBold.copyWith(
                                  color: layer.textColor,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          // ── Footer Description ────────────────────────────────
          if (slide.description != null) ...[
            const SizedBox(height: 16),
            Center(child: _buildRichText(slide.description!, userName)),
          ],

          // ── Highlight Box (optional) ──────────────────────────
          if (slide.highlightTitle != null) ...[
            const SizedBox(height: 16),
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
        ],
      ),
    );
  }

  /// Build RichText with **bold** markers from **text** format
  Widget _buildRichText(String text, String name) {
    // Replace [Nama User] with actual name
    final processedText = text.replaceAll('[Nama User]', name);

    // Parse **bold** markers
    final spans = <TextSpan>[];
    final regex = RegExp(r'\*\*(.+?)\*\*');
    int lastIndex = 0;

    for (final match in regex.allMatches(processedText)) {
      // Text before bold
      if (match.start > lastIndex) {
        spans.add(
          TextSpan(
            text: processedText.substring(lastIndex, match.start),
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
    if (lastIndex < processedText.length) {
      spans.add(
        TextSpan(
          text: processedText.substring(lastIndex),
          style: AppTypography.bodyMediumMedium.copyWith(
            color: const Color(0xFF4A2C00),
          ),
        ),
      );
    }

    if (spans.isEmpty) {
      return Text(
        processedText,
        style: AppTypography.bodyMediumMedium.copyWith(
          color: const Color(0xFF4A2C00),
        ),
        textAlign: TextAlign.center,
      );
    }

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(children: spans),
    );
  }
}
