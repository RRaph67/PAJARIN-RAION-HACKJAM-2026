// =============================================================================
// ptkp_simulation_slide.dart
// Slide type: ptkpSimulation — toggle di bawah/di atas PTKP dengan dynamic bar.
// Pos 2 Scene 4: "Bagaimana kalau penghasilan netomu masih di bawah PTKP?"
// =============================================================================

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../home/models/pos_data_model.dart';

class PtkpSimulationSlide extends StatefulWidget {
  final PosSlide slide;
  final VoidCallback onContinue;

  const PtkpSimulationSlide({
    super.key,
    required this.slide,
    required this.onContinue,
  });

  @override
  State<PtkpSimulationSlide> createState() => _PtkpSimulationSlideState();
}

class _PtkpSimulationSlideState extends State<PtkpSimulationSlide>
    with SingleTickerProviderStateMixin {
  bool _isAbovePtkp = false; // false = di bawah, true = di atas
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleOption(bool abovePtkp) {
    if (_isAbovePtkp == abovePtkp) return;
    setState(() => _isAbovePtkp = abovePtkp);
    if (abovePtkp) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // ── Title ──────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    widget.slide.title,
                    style: AppTypography.headlineMediumBold.copyWith(
                      color: const Color(0xFF4A2C00),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                // ── Description (RichText) ─────────────────────
                if (widget.slide.description != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: _buildRichText(widget.slide.description!),
                  ),

                // ── Dynamic Progress Bar ───────────────────────
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _buildProgressBar(),
                ),

                // ── Sub-text Result ────────────────────────────
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Text.rich(
                    TextSpan(
                      text: 'Potongan PPh 21: ',
                      style: AppTypography.bodyMediumMedium.copyWith(
                        color: const Color(0xFF6E5335),
                      ),
                      children: [
                        TextSpan(
                          text: _isAbovePtkp ? 'Rp100.000' : 'Rp0',
                          style: AppTypography.bodyMediumBold.copyWith(
                            color: const Color(0xFF4A2C00),
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                // ── Toggle Selector ────────────────────────────
                _buildToggleSelector(),
              ],
            ),
          ),
        ),

        // ── Bottom Button ──────────────────────────────────────
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: AppButton(
            label: 'Lanjut',
            variant: _isAbovePtkp
                ? ButtonVariant.primary
                : ButtonVariant.primary,
            width: double.infinity,
            height: 64,
            enabled: _isAbovePtkp,
            icon: Icons.arrow_forward,
            iconColor: _isAbovePtkp ? AppColors.green50 : AppColors.green50,
            onPressed: _isAbovePtkp ? widget.onContinue : null,
          ),
        ),
      ],
    );
  }

  /// Build dynamic progress bar with threshold line
  Widget _buildProgressBar() {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFC7E2D4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // ── Threshold line (center) ───────────────────────
          Positioned(
            left:
                MediaQuery.of(context).size.width *
                0.38, // ~50% accounting for padding
            top: 0,
            bottom: 0,
            child: Container(width: 4, color: const Color(0xFF2D5E46)),
          ),

          // ── Dynamic fill ─────────────────────────────────
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            left: 0,
            top: 0,
            bottom: 0,
            width: _isAbovePtkp
                ? MediaQuery.of(context).size.width *
                      0.70 // Di atas PTKP (melewati garis)
                : MediaQuery.of(context).size.width *
                      0.35, // Di bawah PTKP (sebelum garis)
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2D5E46),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                'Penghasilan Kamu',
                style: AppTypography.bodySmallBold.copyWith(
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          // ── Threshold label ──────────────────────────────
          Positioned(
            right: 16,
            top: 0,
            bottom: 0,
            child: Center(
              child: Text(
                'PTKP',
                style: AppTypography.bodySmallBold.copyWith(
                  color: const Color(0xFF2D5E46),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build segmented toggle selector
  Widget _buildToggleSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFC7E2D4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // ── Option 1: Di Bawah PTKP ──────────────────────
          Expanded(
            child: GestureDetector(
              onTap: () => _toggleOption(false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !_isAbovePtkp
                      ? const Color(0xFF2D5E46)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Di Bawah PTKP',
                  style: AppTypography.titleSmallBold.copyWith(
                    color: !_isAbovePtkp
                        ? Colors.white
                        : const Color(0xFF1E3E2E),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

          // ── Option 2: Di Atas PTKP ───────────────────────
          Expanded(
            child: GestureDetector(
              onTap: () => _toggleOption(true),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _isAbovePtkp
                      ? const Color(0xFF2D5E46)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Di Atas PTKP',
                  style: AppTypography.titleSmallBold.copyWith(
                    color: _isAbovePtkp
                        ? Colors.white
                        : const Color(0xFF1E3E2E),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
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
              color: const Color(0xFF6E5335),
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
            color: const Color(0xFF6E5335),
          ),
        ),
      );
    }

    if (spans.isEmpty) {
      return Text(
        text,
        style: AppTypography.bodyMediumMedium.copyWith(
          color: const Color(0xFF6E5335),
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
