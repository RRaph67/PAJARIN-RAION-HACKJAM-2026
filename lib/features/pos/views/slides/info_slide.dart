// =============================================================================
// info_slide.dart
// Slide type: info — kartu teks + gambar.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../home/models/pos_data_model.dart';

class InfoSlide extends StatelessWidget {
  final PosSlide slide;

  const InfoSlide({super.key, required this.slide});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
        child: Column(
          children: [
            // ── Image ─────────────────────────────────────────────
            if (slide.imagePath != null) ...[
              SizedBox(
                width: 180,
                height: 180,
                child: slide.imagePath!.endsWith('.svg')
                    ? SvgPicture.asset(slide.imagePath!, fit: BoxFit.contain)
                    : Image.asset(
                        slide.imagePath!,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.image_outlined,
                          size: 80,
                          color: AppColors.orange300,
                        ),
                      ),
              ),
              const SizedBox(height: 20),
            ],

            // ── Title ─────────────────────────────────────────────
            Text(
              slide.title,
              style: AppTypography.titleLargeBold.copyWith(
                color: AppColors.orange950,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // ── Body ─────────────────────────────────────────────
            if (slide.body != null)
              Text(
                slide.body!,
                style: AppTypography.bodyMediumMedium.copyWith(
                  color: AppColors.orange950,
                  height: 1.6,
                ),
                textAlign: TextAlign.left,
              ),
          ],
        ),
      ),
    );
  }
}
