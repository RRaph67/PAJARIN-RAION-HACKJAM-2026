// =============================================================================
// kalkulator_simulasi_viewmodel.dart
// ViewModel untuk halaman kalkulator simulasi pajak.
// Mengelola state form, validasi, opsi dropdown, dan navigasi submit.
// =============================================================================

import 'package:flutter/material.dart';

/// State untuk kalkulator simulasi
class KalkulatorState {
  final String gaji;
  final String statusPTKP;
  final String jumlahTanggungan;
  final bool isLoading;

  const KalkulatorState({
    this.gaji = '',
    this.statusPTKP = '',
    this.jumlahTanggungan = '',
    this.isLoading = false,
  });

  /// Apakah semua field sudah terisi
  bool get isFormFilled =>
      gaji.trim().isNotEmpty &&
      statusPTKP.isNotEmpty &&
      jumlahTanggungan.isNotEmpty;

  /// Parse tanggungan string → numeric
  int get tanggunganNumeric {
    switch (jumlahTanggungan) {
      case 'Tidak Ada Tanggungan':
        return 0;
      case '1 Tanggungan':
        return 1;
      case '2 Tanggungan':
        return 2;
      default:
        return 0;
    }
  }

  /// Parse gaji string → double (hapus separator ribuan)
  double get gajiNumeric {
    return double.tryParse(gaji.replaceAll('.', '').replaceAll(',', '')) ?? 0;
  }

  KalkulatorState copyWith({
    String? gaji,
    String? statusPTKP,
    String? jumlahTanggungan,
    bool? isLoading,
  }) {
    return KalkulatorState(
      gaji: gaji ?? this.gaji,
      statusPTKP: statusPTKP ?? this.statusPTKP,
      jumlahTanggungan: jumlahTanggungan ?? this.jumlahTanggungan,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// ViewModel untuk mengelola form simulasi kalkulator
class KalkulatorSimulasiViewModel extends ChangeNotifier {
  KalkulatorState _state = const KalkulatorState();

  KalkulatorState get state => _state;

  // ── Opsi Dropdown ──────────────────────────────────────────────────────
  static const List<String> ptkpOptions = ['Belum Menikah', 'Sudah Menikah'];

  static const List<String> tanggunganOptions = [
    'Tidak Ada Tanggungan',
    '1 Tanggungan',
    '2 Tanggungan',
  ];

  // ── Update Methods ────────────────────────────────────────────────────

  void updateGaji(String value) {
    _state = _state.copyWith(gaji: value);
    notifyListeners();
  }

  void updateStatusPTKP(String value) {
    _state = _state.copyWith(statusPTKP: value);
    notifyListeners();
  }

  void updateJumlahTanggungan(String value) {
    _state = _state.copyWith(jumlahTanggungan: value);
    notifyListeners();
  }

  /// Reset form ke kondisi awal
  void resetForm() {
    _state = const KalkulatorState();
    notifyListeners();
  }

  /// Get data untuk dikirim ke loading/hasil page
  Map<String, dynamic> getSubmitData() {
    return {
      'gaji': _state.gajiNumeric,
      'ptkp': _state.statusPTKP,
      'tanggungan': _state.tanggunganNumeric,
    };
  }
}
