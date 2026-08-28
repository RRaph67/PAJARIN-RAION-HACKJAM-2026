// =============================================================================
// apa_itu_coretax_view.dart
// Halaman informatif "Apa itu CoreTax?" — penjelasan singkat tentang sistem
// administrasi perpajakan terintegrasi milik DJP.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_button.dart';

class ApaItuCoretaxView extends StatelessWidget {
  const ApaItuCoretaxView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.orange50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // ═══════════════ TOP BAR ═══════════════
              Align(
                alignment: Alignment.centerLeft,
                child: AppBackButton(onPressed: () => context.pop()),
              ),

              // ═══════════════ MIDDLE CONTENT ═══════════════
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ── Title ────────────────────────────────────────
                      Text(
                        'Apa itu CoreTax?',
                        style: AppTypography.displaySmallExtraBold.copyWith(
                          color: AppColors.orange950,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),

                      // ── Paragraph ────────────────────────────────────
                      Text(
                        'Coretax adalah sistem administrasi perpajakan terintegrasi milik Direktorat Jenderal Pajak (DJP) yang digunakan untuk mengelola berbagai layanan dan proses perpajakan secara digital. Sistem ini membantu wajib pajak dalam berbagai urusan pajak, mulai dari administrasi hingga pelaporan.',
                        style: AppTypography.bodyMediumMedium.copyWith(
                          color: AppColors.orange950,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              // ═══════════════ BOTTOM BUTTON ═══════════════
              AppButton(
                label: 'Paham',
                onPressed: () => context.pop(),
                width: double.infinity,
                height: 52,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
