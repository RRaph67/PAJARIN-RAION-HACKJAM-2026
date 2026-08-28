// =============================================================================
// completion_slide.dart
// Slide type: completion — pos selesai, Part 1 (celebration) + Part 2 (teaser).
// Scene 11 Part 1: "Pos 1 Selesai!"
// Scene 11 Part 2: "Masih ada satu hal..."
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';

class CompletionSlide extends StatelessWidget {
  final String posTitle;
  final String userName;
  final String mascotAsset;
  final String? imagePath; // mascot untuk Part 2
  final String chatBubbleText;
  final String highlightText;
  final String nextPosLabel;
  final bool showPart2;
  final ValueChanged<bool> onPart2Changed;
  final VoidCallback onComplete;
  final VoidCallback onGoToNextPos;
  final VoidCallback onBack;

  const CompletionSlide({
    super.key,
    required this.posTitle,
    required this.userName,
    required this.mascotAsset,
    this.imagePath,
    required this.chatBubbleText,
    required this.highlightText,
    required this.nextPosLabel,
    required this.showPart2,
    required this.onPart2Changed,
    required this.onComplete,
    required this.onGoToNextPos,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return showPart2 ? _buildPart2() : _buildPart1();
  }

  /// ═══════════════════════════════════════════════════════════════
  /// PART 1: "Pos 1 Selesai!" — celebration + highlight
  /// ═══════════════════════════════════════════════════════════════
  Widget _buildPart1() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // ── Title ──────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    posTitle,
                    style: AppTypography.displaySmallExtraBold.copyWith(
                      color: const Color(0xFF4A2C00),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                // ── Mascot Illustration with Shadow ───────────
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          bottom: 20,
                          child: ClipOval(
                            child: Container(
                              width: 117,
                              height: 24,
                              color: const Color(
                                0xFF493000,
                              ).withValues(alpha: 0.25),
                            ),
                          ),
                        ),
                        SvgPicture.asset(mascotAsset, width: 360, height: 333),
                      ],
                    ),
                  ),
                ),

                // ── Highlight Info Box ─────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC7E2D4),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    highlightText,
                    style: AppTypography.bodyMediumBold.copyWith(
                      color: const Color(0xFF1E3E2E),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Bottom Button ──────────────────────────────────────
        AppButton(
          label: 'Lanjut',
          variant: ButtonVariant.primary,
          width: double.infinity,
          height: 64,
          icon: Icons.arrow_forward,
          iconColor: AppColors.green50,
          onPressed: () => onPart2Changed(true),
        ),
      ],
    );
  }

  /// ═══════════════════════════════════════════════════════════════
  /// PART 2: "Masih ada satu hal..." — teaser + dual buttons
  /// ═══════════════════════════════════════════════════════════════
  Widget _buildPart2() {
    // Replace [Nama User] with actual name
    final processedChatText = chatBubbleText.replaceAll(
      '[Nama User]',
      userName,
    );

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // ── Title ──────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Text(
                    'Masih ada satu hal...',
                    style: AppTypography.titleLargeBold.copyWith(
                      color: const Color(0xFF4A2C00),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                // ── Mascot + Chat Bubble ───────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Mascot (Part 2 pakai imagePath, fallback ke mascotAsset)
                    SizedBox(width: 64, height: 64, child: _buildPart2Mascot()),
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
                          processedChatText,
                          style: AppTypography.bodyLargeMedium.copyWith(
                            color: const Color(0xFF4A2C00),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // ── Dual Bottom Buttons ──────────────────────────────
        Row(
          children: [
            // ── Keluar dan Selesai (secondary) ──
            Expanded(
              child: AppButton(
                label: 'Keluar dan Selesai',
                variant: ButtonVariant.secondary,
                width: double.infinity,
                height: 54,
                onPressed: onComplete,
              ),
            ),
            const SizedBox(width: 12),
            // ── Lanjut di Pos berikutnya (primary) ──
            Expanded(
              child: AppButton(
                label: nextPosLabel,
                variant: ButtonVariant.primary,
                width: double.infinity,
                height: 54,
                iconColor: AppColors.green50,
                onPressed: onGoToNextPos,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Build mascot widget untuk Part 2 (menggunakan imagePath jika ada)
  Widget _buildPart2Mascot() {
    final asset = imagePath ?? mascotAsset;
    return asset.endsWith('.svg')
        ? SvgPicture.asset(asset, fit: BoxFit.contain)
        : Image.asset(asset, fit: BoxFit.contain);
  }
}
