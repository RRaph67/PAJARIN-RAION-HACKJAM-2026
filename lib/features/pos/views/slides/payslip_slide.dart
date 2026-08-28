// =============================================================================
// payslip_slide.dart
// Slide type: payslip — dynamic user name + payslip card with rows.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_typography.dart';
import '../../../auth/viewmodels/auth_viewmodel.dart';
import '../../../home/models/pos_data_model.dart';

class PayslipSlide extends ConsumerWidget {
  final PosSlide slide;

  const PayslipSlide({super.key, required this.slide});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ── Ambil nama user dari auth provider ──
    final authState = ref.watch(authViewModelProvider);
    final userName = authState.user?.name ?? 'Rafi';

    return SingleChildScrollView(
      child: Column(
        children: [
          // ── Title (dynamic user name) ────────────────────────
          Text(
            'Ini adalah slip gaji $userName nantinya.',
            style: AppTypography.titleLargeBold.copyWith(
              color: const Color(0xFF4A2C00),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // ── Subtitle ─────────────────────────────────────────
          if (slide.subtitle != null)
            Text(
              slide.subtitle!,
              style: AppTypography.bodyMediumMedium.copyWith(
                color: const Color(0xFF6E5136),
              ),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 24),

          // ── Slip Gaji Card ───────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFFCEECB),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                // ── Header "Slip Gaji" ────────────────────────
                Text(
                  'Slip Gaji',
                  style: AppTypography.titleMediumBold.copyWith(
                    color: const Color(0xFF4A2C00),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // ── Subheader Info ─────────────────────────────
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nama Karyawan: $userName',
                        style: AppTypography.bodySmallMedium.copyWith(
                          color: const Color(0xFF4A2C00),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Periode Gaji: 1 - 31 Juli 2026',
                        style: AppTypography.bodySmallMedium.copyWith(
                          color: const Color(0xFF4A2C00),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // ── Divider ────────────────────────────────────
                Container(
                  width: double.infinity,
                  height: 1,
                  color: const Color(0xFF8B6E4E).withValues(alpha: 0.3),
                ),
                const SizedBox(height: 12),

                // ── White pill container for rows ──────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDF5E6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      if (slide.payslipRows != null)
                        ...slide.payslipRows!.map((row) {
                          return Column(
                            children: [
                              if (row.showDividerBefore) ...[
                                Container(
                                  width: double.infinity,
                                  height: 1,
                                  color: const Color(
                                    0xFF8B6E4E,
                                  ).withValues(alpha: 0.2),
                                ),
                                const SizedBox(height: 10),
                              ],
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    row.label,
                                    style:
                                        (row.isBold
                                                ? AppTypography.bodyMediumBold
                                                : AppTypography
                                                      .bodyMediumRegular)
                                            .copyWith(
                                              color: const Color(0xFF4A2C00),
                                            ),
                                  ),
                                  Text(
                                    row.value,
                                    style:
                                        (row.isBold
                                                ? AppTypography.bodyMediumBold
                                                : AppTypography
                                                      .bodyMediumRegular)
                                            .copyWith(
                                              color: row.value.contains('xxx')
                                                  ? const Color(
                                                      0xFF8B6E4E,
                                                    ).withValues(alpha: 0.6)
                                                  : const Color(0xFF4A2C00),
                                            ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          );
                        }),
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
