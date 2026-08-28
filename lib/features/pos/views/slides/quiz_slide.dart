// =============================================================================
// quiz_slide.dart
// Slide type: quiz — kuis pilihan ganda dengan 3 state:
//   1. Unanswered (neutral)
//   2. Correct → green bg, ✓ icon, auto-navigate
//   3. Wrong → red bg, ✗ icon, popup "Maaf" + Coba Lagi
// =============================================================================

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../home/models/pos_data_model.dart';

class QuizSlide extends StatelessWidget {
  final PosSlide slide;
  final String? selectedOption;
  final bool isSubmitted;
  final void Function(String label, bool isCorrect) onOptionTap;
  final VoidCallback onRetry;

  const QuizSlide({
    super.key,
    required this.slide,
    required this.selectedOption,
    required this.isSubmitted,
    required this.onOptionTap,
    required this.onRetry,
  });

  // ── Design spec colors ────────────────────────────────────────────────
  static const Color _neutralBorder = Color(0xFF8B6E4E);
  static const Color _wrongBg = Color(0xFFFFDEDE);
  static const Color _wrongBorder = Color(0xFF8E3838);
  static const Color _wrongText = Color(0xFF8E3838);

  @override
  Widget build(BuildContext context) {
    final quiz = slide.quiz;
    if (quiz == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.orange950.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Question (centered) ────────────────────────────
            Text(
              quiz.question,
              style: AppTypography.titleLargeBold.copyWith(
                color: const Color(0xFF4A2C00),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // ── Options ────────────────────────────────────────
            ...quiz.options.map((option) {
              final isSelected = selectedOption == option.label;
              final isCorrect = option.isCorrect;

              // ── State-based styling ──────────────────────────
              Color bgColor;
              Color borderColor;
              Color textColor;
              Widget? suffixIcon;

              if (!isSubmitted) {
                // STATE 1: Belum submit — neutral, selected = orange
                bgColor = isSelected ? AppColors.orange100 : AppColors.orange50;
                borderColor = isSelected ? AppColors.orange800 : _neutralBorder;
                textColor = const Color(0xFF4A2C00);
                suffixIcon = null;
              } else if (isCorrect) {
                // STATE 2: Jawaban benar — hijau
                bgColor = AppColors.green100;
                borderColor = AppColors.green600;
                textColor = AppColors.green600;
                suffixIcon = const Icon(
                  Icons.check_rounded,
                  size: 20,
                  color: AppColors.green600,
                );
              } else if (isSelected && !isCorrect) {
                // STATE 3: Jawaban salah — merah
                bgColor = _wrongBg;
                borderColor = _wrongBorder;
                textColor = _wrongText;
                suffixIcon = const Icon(
                  Icons.close_rounded,
                  size: 20,
                  color: _wrongBorder,
                );
              } else {
                // Opsi lain (neutral)
                bgColor = AppColors.orange50;
                borderColor = _neutralBorder.withValues(alpha: 0.4);
                textColor = const Color(0xFF4A2C00);
                suffixIcon = null;
              }

              return GestureDetector(
                onTap: isSubmitted
                    ? null
                    : () => onOptionTap(option.label, isCorrect),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      // ── Label (A/B/C/D) ────────────────────────
                      Text(
                        '${option.label}.',
                        style: AppTypography.titleSmallBold.copyWith(
                          color: textColor,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // ── Option Text ───────────────────────────
                      Expanded(
                        child: Text(
                          option.text,
                          style: AppTypography.bodyMediumMedium.copyWith(
                            color: textColor,
                          ),
                        ),
                      ),

                      // ── Suffix Icon (check/close) ──────────────
                      if (suffixIcon != null) ...[
                        const SizedBox(width: 8),
                        suffixIcon,
                      ],
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ─── Popup Bottom Sheet untuk jawaban salah ───────────────────────────────

void showWrongAnswerPopup({
  required BuildContext context,
  required VoidCallback onRetry,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isDismissible: false,
    enableDrag: false,
    builder: (context) => Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Close handle ──
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.orange200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            // ── Icon ──
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: Color(0xFFFFDEDE),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close_rounded,
                size: 28,
                color: Color(0xFF8E3838),
              ),
            ),
            const SizedBox(height: 16),

            // ── Title ──
            Text(
              'Maaf, jawaban belum benar',
              style: AppTypography.titleMediumBold.copyWith(
                color: AppColors.orange950,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // ── Button Coba Lagi ──
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: 'Coba Lagi',
                variant: ButtonVariant.primary,
                width: double.infinity,
                height: 54,
                onPressed: () {
                  Navigator.of(context).pop(); // Tutup popup
                  onRetry(); // Reset quiz
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
