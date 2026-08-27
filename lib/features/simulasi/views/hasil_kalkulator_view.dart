// =============================================================================
// hasil_kalkulator_view.dart
// Halaman hasil kalkulasi simulasi pajak.
// Menampilkan breakdown perhitungan PPh 21 dengan rumus placeholder.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_button.dart';

/// Model sederhana untuk hasil kalkulasi pajak.
class HasilPajak {
  final double gajiBruto;
  final String statusPTKP;
  final int jumlahTanggungan;
  final double penghasilanBruto;
  final double penghasilanNeto;
  final double ptkp;
  final double pkp;
  final double pph21;

  const HasilPajak({
    required this.gajiBruto,
    required this.statusPTKP,
    required this.jumlahTanggungan,
    required this.penghasilanBruto,
    required this.penghasilanNeto,
    required this.ptkp,
    required this.pkp,
    required this.pph21,
  });

  /// Format angka ke format Rupiah.
  static String formatRupiah(double value) {
    final str = value.toStringAsFixed(0);
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(str[i]);
    }
    return 'Rp ${buffer.toString()}';
  }
}

/// Hitung pajak dengan rumus PPh 21 (per tahun) — PLACEHOLDER.
///
/// Catatan: Ini adalah rumus SEDERHANA untuk simulasi.
/// Rumus asli PPh 21 jauh lebih kompleks dan melibatkan banyak variabel.
HasilPajak hitungPajak({
  required double gaji,
  required String ptkp,
  required int tanggungan,
}) {
  // ── Gaji Bruto per Tahun ──────────────────────────────────────────────
  final gajiBrutoTahunan = gaji * 12;

  // ── Penghasilan Bruto (asumsi 12 bulan) ───────────────────────────────
  final penghasilanBruto = gajiBrutoTahunan;

  // ── Penghasilan Neto (bruto - biaya jabatan 5%, maks 500rb/bulan) ────
  final biayaJabatan = (gaji * 0.05).clamp(0, 500000) * 12;
  final penghasilanNeto = penghasilanBruto - biayaJabatan;

  // ── PTKP berdasarkan status ───────────────────────────────────────────
  // PTKP Dasar: TK/0 = Rp 54.000.000/tahun
  double ptkpValue;
  switch (ptkp) {
    case 'Belum Menikah':
      ptkpValue = 54000000; // TK/0
      break;
    case 'Sudah Menikah':
      ptkpValue = 58500000; // K/0 (54jt + 4.5jt)
      break;
    default:
      ptkpValue = 54000000;
  }

  // ── Tambahan PTKP per tanggungan ──────────────────────────────────────
  // Setiap tanggungan +Rp 4.500.000/tahun
  ptkpValue += tanggungan * 4500000;

  // ── PKP (Penghasilan Kena Pajak) ─────────────────────────────────────
  final pkp = (penghasilanNeto - ptkpValue)
      .clamp(0, double.infinity)
      .toDouble();

  // ── PPh 21 (tarif progresif 2024) ────────────────────────────────────
  double pph21 = 0;
  if (pkp > 0) {
    if (pkp <= 50000000) {
      pph21 = pkp * 0.05;
    } else if (pkp <= 250000000) {
      pph21 = 2500000 + (pkp - 50000000) * 0.15;
    } else if (pkp <= 500000000) {
      pph21 = 32500000 + (pkp - 250000000) * 0.25;
    } else {
      pph21 = 95000000 + (pkp - 500000000) * 0.30;
    }
  }

  // ── PPh 21 per Bulan ─────────────────────────────────────────────────
  final pph21PerBulan = pph21 / 12;

  return HasilPajak(
    gajiBruto: gaji,
    statusPTKP: ptkp,
    jumlahTanggungan: tanggungan,
    penghasilanBruto: penghasilanBruto,
    penghasilanNeto: penghasilanNeto,
    ptkp: ptkpValue,
    pkp: pkp,
    pph21: pph21PerBulan,
  );
}

// ─── View ─────────────────────────────────────────────────────────────────────
class HasilKalkulatorView extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final hasil = hitungPajak(gaji: gaji, ptkp: ptkp, tanggungan: tanggungan);

    return Scaffold(
      backgroundColor: AppColors.orange50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Back Button ──────────────────────────────────────────
              Align(
                alignment: Alignment.centerLeft,
                child: AppBackButton(
                  onPressed: () => context.go(AppRoutes.simulasi),
                ),
              ),

              const SizedBox(height: 16),

              // ── Title ────────────────────────────────────────────────
              Text(
                'Hasil Simulasi Pajak',
                style: AppTypography.displaySmallExtraBold.copyWith(
                  color: AppColors.orange950,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'Perhitungan PPh 21 Tahunan',
                style: AppTypography.headlineSmallMedium.copyWith(
                  color: AppColors.orange900,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // ── Hasil Utama ──────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.green600,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text(
                      'PPh 21 yang harus dibayar per bulan',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.green100,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      HasilPajak.formatRupiah(hasil.pph21),
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: AppColors.green50,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Detail Breakdown ─────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildDetailRow(
                        'Gaji Bruto per Bulan',
                        HasilPajak.formatRupiah(hasil.gajiBruto),
                      ),
                      _buildDetailRow(
                        'Gaji Bruto per Tahun',
                        HasilPajak.formatRupiah(hasil.penghasilanBruto),
                      ),
                      _buildDetailRow(
                        'Penghasilan Neto per Tahun',
                        HasilPajak.formatRupiah(hasil.penghasilanNeto),
                      ),
                      _buildDivider(),
                      _buildDetailRow('Status PTKP', hasil.statusPTKP),
                      _buildDetailRow(
                        'Jumlah Tanggungan',
                        '${hasil.jumlahTanggungan} orang',
                      ),
                      _buildDetailRow(
                        'PTKP',
                        HasilPajak.formatRupiah(hasil.ptkp),
                      ),
                      _buildDivider(),
                      _buildDetailRow(
                        'PKP (Penghasilan Kena Pajak)',
                        HasilPajak.formatRupiah(hasil.pkp),
                      ),
                      _buildDetailRow(
                        'PPh 21 per Tahun',
                        HasilPajak.formatRupiah(hasil.pph21 * 12),
                      ),
                      _buildDivider(),
                      _buildDetailRow(
                        'PPh 21 per Bulan',
                        HasilPajak.formatRupiah(hasil.pph21),
                        isHighlight: true,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ── Button Kembali ───────────────────────────────────────
              AppButton(
                label: 'Hitung Ulang',
                icon: Icons.replay,
                onPressed: () => context.go(AppRoutes.simulasi),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  /// Baris detail: label kiri, value kanan.
  Widget _buildDetailRow(
    String label,
    String value, {
    bool isHighlight = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14,
                fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w500,
                color: isHighlight ? AppColors.orange950 : AppColors.orange900,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 14,
              fontWeight: isHighlight ? FontWeight.w800 : FontWeight.w700,
              color: isHighlight ? AppColors.green600 : AppColors.orange950,
            ),
          ),
        ],
      ),
    );
  }

  /// Divider tipis.
  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Divider(height: 1, color: AppColors.orange200),
    );
  }
}
