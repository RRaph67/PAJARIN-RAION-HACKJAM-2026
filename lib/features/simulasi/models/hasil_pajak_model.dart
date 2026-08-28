// =============================================================================
// hasil_pajak_model.dart
// Model data hasil kalkulasi pajak + fungsi perhitungan PPh 21.
// Dipisahkan dari view untuk maintainability & reusability.
// =============================================================================

/// Model data hasil kalkulasi pajak.
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

  /// Take-Home Pay = Gaji Bruto - PPh 21 per bulan
  double get takeHomePay => gajiBruto - pph21;

  /// PTKP label untuk UI (TK/0, K/1, dll)
  String get ptkpLabel {
    if (statusPTKP == 'Sudah Menikah') {
      return 'K/${jumlahTanggungan > 0 ? jumlahTanggungan : 0}';
    }
    return 'TK/${jumlahTanggungan > 0 ? jumlahTanggungan : 0}';
  }

  /// Apakah user tidak dikenai PPh 21
  bool get isNotTaxed => pph21 <= 0;

  /// Copy with perubahan sebagian field
  HasilPajak copyWith({
    double? gajiBruto,
    String? statusPTKP,
    int? jumlahTanggungan,
    double? penghasilanBruto,
    double? penghasilanNeto,
    double? ptkp,
    double? pkp,
    double? pph21,
  }) {
    return HasilPajak(
      gajiBruto: gajiBruto ?? this.gajiBruto,
      statusPTKP: statusPTKP ?? this.statusPTKP,
      jumlahTanggungan: jumlahTanggungan ?? this.jumlahTanggungan,
      penghasilanBruto: penghasilanBruto ?? this.penghasilanBruto,
      penghasilanNeto: penghasilanNeto ?? this.penghasilanNeto,
      ptkp: ptkp ?? this.ptkp,
      pkp: pkp ?? this.pkp,
      pph21: pph21 ?? this.pph21,
    );
  }
}

// ─── Fungsi Perhitungan Pajak ────────────────────────────────────────────────

/// Hitung pajak dengan rumus PPh 21 (per bulan).
///
/// Rumus:
/// 1. Gaji Bruto Tahunan = Gaji × 12
/// 2. Biaya Jabatan = 5% × Gaji (maks Rp500.000/bulan) × 12
/// 3. Penghasilan Neto = Bruto - Biaya Jabatan
/// 4. PTKP = Dasar (TK/0: Rp54jt, K/0: Rp58.5jt) + tanggungan × Rp4.5jt
/// 5. PKP = Neto - PTKP (min 0)
/// 6. PPh 21 = Tarif progresif terhadap PKP
/// 7. PPh 21 Bulanan = PPh 21 / 12
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
