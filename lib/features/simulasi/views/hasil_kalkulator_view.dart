// =============================================================================
// hasil_kalkulator_view.dart
// Halaman hasil kalkulasi simulasi pajak.
// Menampilkan "Slip Gaji" card, information banner, dan action button.
// Business logic (model, formula, formatting) dipisahkan ke file terpisah.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_button.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../viewmodels/hasil_kalkulator_viewmodel.dart';

// ─── View ─────────────────────────────────────────────────────────────────────
class HasilKalkulatorView extends ConsumerWidget {
  final double gaji;
  final String ptkp;
  final int tanggungan;

  const HasilKalkulatorView({
    super.key,
    required this.gaji,
    required this.ptkp,
    required this.tanggungan,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ── Ambil nama user dari auth state ──────────────────────────────────
    final authState = ref.watch(authViewModelProvider);
    final userName = authState.user?.name ?? 'User';

    // ── Hitung hasil pajak via ViewModel ─────────────────────────────────
    final state = HasilKalkulatorViewModel.calculate(
      gaji: gaji,
      ptkp: ptkp,
      tanggungan: tanggungan,
      userName: userName,
    );

    final hasil = state.hasil;
    if (hasil == null) {
      return const Scaffold(body: Center(child: Text('Data tidak tersedia')));
    }

    return Scaffold(
      backgroundColor: AppColors.orange50,
      body: SafeArea(
        child: Column(
          children: [
            // ═══════════════ TOP BAR ═══════════════
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
              child: Row(
                children: [
                  AppBackButton(
                    onPressed: () => context.go(AppRoutes.simulasi),
                  ),
                  Expanded(
                    child: Text(
                      'Hasil Simulasi Pajak',
                      style: AppTypography.titleLargeBold.copyWith(
                        color: AppColors.orange900,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // ═══════════════ SCROLLABLE CONTENT (auto gap) ═══════════════
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.65,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        // ═══════════════ SLIP GAJI CARD ═══════════════
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.orange100,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Slip Gaji',
                                style: AppTypography.titleLargeBold.copyWith(
                                  color: AppColors.orange950,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              _buildInfoRow('Nama Karyawan', userName),
                              const SizedBox(height: 8),
                              _buildInfoRow('Periode Gaji', state.periode),
                              const SizedBox(height: 16),
                              _buildDivider(),
                              _buildValueRow(
                                'Gaji Pokok',
                                CurrencyFormatter.formatRupiah(hasil.gajiBruto),
                              ),
                              const SizedBox(height: 4),
                              _buildDivider(),
                              _buildValueRow(
                                'Bruto',
                                CurrencyFormatter.formatRupiah(
                                  hasil.penghasilanBruto,
                                ),
                              ),
                              _buildValueRow(
                                'PPh 21',
                                CurrencyFormatter.formatRupiah(hasil.pph21),
                                isBold: true,
                              ),
                              const SizedBox(height: 4),
                              _buildDivider(),
                              _buildValueRow(
                                'Take-Home Pay',
                                CurrencyFormatter.formatRupiah(
                                  hasil.takeHomePay,
                                ),
                                isBold: true,
                              ),
                            ],
                          ),
                        ),

                        const Spacer(),

                        // ═══════════════ INFORMATION BANNER ═══════════════
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.green100,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.green200,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.lightbulb_outline,
                                  size: 22,
                                  color: AppColors.green700,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.bannerTitle,
                                      style: AppTypography.titleMediumBold
                                          .copyWith(color: AppColors.green900),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      state.bannerSubtitle,
                                      style: AppTypography.bodyMediumMedium
                                          .copyWith(color: AppColors.green800),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Spacer(),

                        // ═══════════════ ACTION BUTTON ═══════════════
                        AppButton(
                          label: 'Coba Skenario Lain',
                          onPressed: () => context.go(AppRoutes.simulasi),
                        ),
                        const SizedBox(height: 16),

                        // ═══════════════ DISCLAIMER ═══════════════
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            'Ini estimasi edukatif, bukan angka resmi untuk pelaporan pajak. '
                            'Dibuat untuk membantu memahami nilai kontribusi pajak.',
                            textAlign: TextAlign.center,
                            style: AppTypography.bodySmallRegular.copyWith(
                              color: AppColors.green900,
                              height: 1.4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Helper: Info Row ─────────────────────────────────────────────────────
  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodyMediumMedium.copyWith(
            color: AppColors.orange900,
          ),
        ),
        Text(
          value,
          style: AppTypography.bodyMediumBold.copyWith(
            color: AppColors.orange950,
          ),
        ),
      ],
    );
  }

  // ─── Helper: Value Row ────────────────────────────────────────────────────
  Widget _buildValueRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 14,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
              color: isBold ? AppColors.orange950 : AppColors.orange900,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 14,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w700,
              color: AppColors.orange950,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Helper: Divider ──────────────────────────────────────────────────────
  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Divider(height: 1, color: AppColors.orange900),
    );
  }
}
