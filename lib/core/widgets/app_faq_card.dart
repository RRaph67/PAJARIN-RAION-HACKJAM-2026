// =============================================================================
// app_faq_card.dart
// Komponen reusable FAQ Card dengan 2 state: Closed & Opened.
// Mendukung toggle expand/collapse dengan animasi halus.
// Styling: border orange950, bg header orange50, bg body orange200.
// =============================================================================

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class AppFaqCard extends StatefulWidget {
  /// Pertanyaan FAQ
  final String question;

  /// Jawaban FAQ (bisa mengandung bold text)
  final String answer;

  /// Sumber/catatn kaki (opsional)
  final String? source;

  /// State awal: true = terbuka, false = tertutup
  final bool initiallyExpanded;

  /// Padding horizontal card
  final double horizontalPadding;

  const AppFaqCard({
    super.key,
    required this.question,
    required this.answer,
    this.source,
    this.initiallyExpanded = false,
    this.horizontalPadding = 16,
  });

  @override
  State<AppFaqCard> createState() => _AppFaqCardState();
}

class _AppFaqCardState extends State<AppFaqCard>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
      value: _isExpanded ? 1.0 : 0.0,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.orange50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.orange950, width: 1.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Header (Question + Arrow) ────────────────────────────
          GestureDetector(
            onTap: _toggleExpand,
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Question Text ───────────────────────────────
                  Expanded(
                    child: Text(
                      widget.question,
                      style: AppTypography.titleMediumBold.copyWith(
                        color: AppColors.orange950,
                      ),
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // ── Arrow Icon ──────────────────────────────────
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      size: 24,
                      color: AppColors.orange950,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Body (Answer + Source) — Expandable ─────────────────
          SizeTransition(
            sizeFactor: _animation,
            axisAlignment: -1.0,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Divider ─────────────────────────────────────
                  Container(height: 1.5, color: AppColors.orange950),
                  const SizedBox(height: 16),

                  // ── Answer Text ─────────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.orange200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.answer,
                          style: AppTypography.bodyMediumMedium.copyWith(
                            color: AppColors.orange950,
                            height: 1.6,
                          ),
                        ),

                        // ── Source / Catatan Kaki ────────────────
                        if (widget.source != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            widget.source!,
                            style: AppTypography.bodySmallRegular.copyWith(
                              color: AppColors.orange700,
                              fontStyle: FontStyle.italic,
                              height: 1.4,
                            ),
                          ),
                        ],
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
