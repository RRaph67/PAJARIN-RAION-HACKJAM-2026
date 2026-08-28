// =============================================================================
// hasil_kalkulator_viewmodel.dart
// ViewModel untuk halaman hasil kalkulasi simulasi pajak.
// Mengelola state hasil perhitungan, derived values (PTKP label, periode),
// dan logic formatting yang sebelumnya ada di view.
// =============================================================================

import '../models/hasil_pajak_model.dart';
import '../../../core/utils/currency_formatter.dart';

/// State untuk hasil kalkulasi
class HasilKalkulatorState {
  final double gaji;
  final String ptkp;
  final int tanggungan;
  final HasilPajak? hasil;
  final String userName;

  const HasilKalkulatorState({
    required this.gaji,
    required this.ptkp,
    required this.tanggungan,
    this.hasil,
    this.userName = 'User',
  });

  /// PTKP label untuk UI (TK/0, K/1, dll)
  String get ptkpLabel => hasil?.ptkpLabel ?? 'TK/0';

  /// Apakah user tidak dikenai PPh 21
  bool get isNotTaxed => hasil?.isNotTaxed ?? true;

  /// Take-Home Pay
  double get takeHomePay => hasil?.takeHomePay ?? gaji;

  /// Periode gaji saat ini (1 - DD Bulan YYYY)
  String get periode {
    final now = DateTime.now();
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '1 - ${now.day} ${months[now.month - 1]} ${now.year}';
  }

  /// Info banner title
  String get bannerTitle {
    if (isNotTaxed) return 'Gajimu belum dikenai PPh 21';
    return 'Gajimu sudah dikenai PPh 21';
  }

  /// Info banner subtitle
  String get bannerSubtitle {
    if (isNotTaxed) return 'Masih di bawah PTKP untuk $ptkpLabel';
    return 'PPh 21 yang dipotong sebesar ${CurrencyFormatter.formatRupiah(hasil?.pph21 ?? 0)}/bulan';
  }
}

/// ViewModel untuk mengelola hasil kalkulasi
class HasilKalkulatorViewModel {
  /// Hitung hasil pajak dari input → return state siap pakai di view
  static HasilKalkulatorState calculate({
    required double gaji,
    required String ptkp,
    required int tanggungan,
    String userName = 'User',
  }) {
    final hasil = hitungPajak(gaji: gaji, ptkp: ptkp, tanggungan: tanggungan);

    return HasilKalkulatorState(
      gaji: gaji,
      ptkp: ptkp,
      tanggungan: tanggungan,
      hasil: hasil,
      userName: userName,
    );
  }
}
