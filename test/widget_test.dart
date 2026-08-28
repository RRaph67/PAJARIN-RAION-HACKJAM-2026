// =============================================================================
// widget_test.dart
// Unit tests untuk logika inti Pajarin: perhitungan pajak & currency formatter.
// Full widget test tidak dilakukan di sini karena Supabase perlu koneksi
// ke server real (tidak bisa di-mock tanpa setup tambahan).
// =============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:pajarin/features/simulasi/models/hasil_pajak_model.dart';
import 'package:pajarin/core/utils/currency_formatter.dart';

void main() {
  // ═══════════════════════════════════════════════════════════════════════════
  // CurrencyFormatter Tests
  // ═══════════════════════════════════════════════════════════════════════════

  group('CurrencyFormatter.formatRupiah', () {
    test('should format zero correctly', () {
      expect(CurrencyFormatter.formatRupiah(0), 'Rp0');
    });

    test('should format small number correctly', () {
      expect(CurrencyFormatter.formatRupiah(1000), 'Rp1.000');
    });

    test('should format millions correctly', () {
      expect(CurrencyFormatter.formatRupiah(5000000), 'Rp5.000.000');
    });

    test('should format large number correctly', () {
      expect(CurrencyFormatter.formatRupiah(150000000), 'Rp150.000.000');
    });

    test('should format number with decimal truncation', () {
      expect(CurrencyFormatter.formatRupiah(5500000.75), 'Rp5.500.001');
    });
  });

  group('CurrencyFormatter.parseRupiah', () {
    test('should parse zero correctly', () {
      expect(CurrencyFormatter.parseRupiah('0'), 0.0);
    });

    test('should parse formatted string correctly', () {
      expect(CurrencyFormatter.parseRupiah('5.000.000'), 5000000.0);
    });

    test('should parse raw string correctly', () {
      expect(CurrencyFormatter.parseRupiah('5000000'), 5000000.0);
    });

    test('should return 0 for invalid input', () {
      expect(CurrencyFormatter.parseRupiah('abc'), 0.0);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // hitungPajak Tests — PPh 21 Calculation
  // ═══════════════════════════════════════════════════════════════════════════

  group('hitungPajak', () {
    test('should return zero tax for salary below PTKP (TK/0)', () {
      // Gaji Rp3.000.000/bln, Belum Menikah, 0 tanggungan
      // Bruto tahunan: 36jt, Biaya Jabatan: 1.8jt, Neto: 34.2jt
      // PTKP TK/0: 54jt → PKP = 0 → PPh = 0
      final hasil = hitungPajak(
        gaji: 3000000,
        ptkp: 'Belum Menikah',
        tanggungan: 0,
      );

      expect(hasil.pph21, 0.0);
      expect(hasil.isNotTaxed, true);
      expect(hasil.ptkpLabel, 'TK/0');
      expect(hasil.takeHomePay, 3000000.0);
    });

    test('should calculate tax correctly for above-PTKP salary (TK/0)', () {
      // Gaji Rp10.000.000/bln, Belum Menikah, 0 tanggungan
      // Bruto tahunan: 120jt
      // Biaya Jabatan: min(10jt * 5%, 500rb) * 12 = 500rb * 12 = 6jt
      // Neto: 120jt - 6jt = 114jt
      // PTKP TK/0: 54jt
      // PKP: 114jt - 54jt = 60jt
      // PPh: 50jt * 5% + 10jt * 15% = 2.5jt + 1.5jt = 4jt
      // PPh/bln: 4jt / 12 = 333.333,33
      final hasil = hitungPajak(
        gaji: 10000000,
        ptkp: 'Belum Menikah',
        tanggungan: 0,
      );

      expect(hasil.isNotTaxed, false);
      expect(hasil.ptkpLabel, 'TK/0');
      expect(hasil.pkp, 60000000.0);
      expect(hasil.pph21, closeTo(333333.33, 1));
      expect(hasil.takeHomePay, closeTo(10000000 - 333333.33, 1));
    });

    test('should calculate tax correctly for married user (K/0)', () {
      // Gaji Rp10.000.000/bln, Sudah Menikah, 0 tanggungan
      // PTKP K/0: 58.5jt
      // Neto: 114jt
      // PKP: 114jt - 58.5jt = 55.5jt
      // PPh: 50jt * 5% + 5.5jt * 15% = 2.5jt + 825rb = 3.325jt
      // PPh/bln: 3.325jt / 12 = 277.083,33
      final hasil = hitungPajak(
        gaji: 10000000,
        ptkp: 'Sudah Menikah',
        tanggungan: 0,
      );

      expect(hasil.ptkpLabel, 'K/0');
      expect(hasil.pkp, 55500000.0);
      expect(hasil.pph21, closeTo(277083.33, 1));
    });

    test('should increase PTKP with tanggungan', () {
      // Gaji Rp10.000.000/bln, Sudah Menikah, 2 tanggungan
      // PTKP K/2: 58.5jt + 2 * 4.5jt = 67.5jt
      // Neto: 114jt
      // PKP: 114jt - 67.5jt = 46.5jt
      // PPh: 46.5jt * 5% = 2.325jt
      // PPh/bln: 2.325jt / 12 = 193.750
      final hasil = hitungPajak(
        gaji: 10000000,
        ptkp: 'Sudah Menikah',
        tanggungan: 2,
      );

      expect(hasil.ptkpLabel, 'K/2');
      expect(hasil.pkp, 46500000.0);
      expect(hasil.pph21, closeTo(193750.0, 1));
    });

    test('should cap biaya jabatan at 500.000 per month', () {
      // Gaji Rp20.000.000/bln
      // Biaya jabatan: min(20jt * 5%, 500rb) = min(1jt, 500rb) = 500rb
      final hasil = hitungPajak(
        gaji: 20000000,
        ptkp: 'Belum Menikah',
        tanggungan: 0,
      );

      // Bruto tahunan: 240jt, Biaya Jabatan: 500rb * 12 = 6jt
      // Neto: 234jt, PTKP: 54jt, PKP: 180jt
      expect(hasil.penghasilanNeto, 234000000.0);
      expect(hasil.pkp, 180000000.0);
    });

    test('should handle very high salary (tarif 30%)', () {
      // Gaji Rp50.000.000/bln, Belum Menikah, 0 tanggungan
      // Bruto tahunan: 600jt
      // Biaya Jabatan: 500rb * 12 = 6jt
      // Neto: 594jt
      // PTKP TK/0: 54jt
      // PKP: 540jt
      // PPh: 2.5jt (50jt*5%) + 30jt (200jt*15%) + 62.5jt (250jt*25%) + 12jt (40jt*30%)
      // PPh total: 107jt, PPh/bln: 107jt/12 = 8.916.666,67
      final hasil = hitungPajak(
        gaji: 50000000,
        ptkp: 'Belum Menikah',
        tanggungan: 0,
      );

      expect(hasil.isNotTaxed, false);
      expect(hasil.pph21, closeTo(8916666.67, 1));
    });

    test('should handle salary exactly at PTKP boundary', () {
      // Gaji Rp4.500.000/bln, Belum Menikah, 0 tanggungan
      // Bruto tahunan: 54jt
      // Biaya Jabatan: min(4.5jt * 5%, 500rb) * 12 = 225rb * 12 = 2.7jt
      // Neto: 54jt - 2.7jt = 51.3jt
      // PTKP TK/0: 54jt
      // PKP: 0 (neto < PTKP)
      final hasil = hitungPajak(
        gaji: 4500000,
        ptkp: 'Belum Menikah',
        tanggungan: 0,
      );

      expect(hasil.pkp, 0.0);
      expect(hasil.pph21, 0.0);
      expect(hasil.isNotTaxed, true);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // HasilPajak Model Tests
  // ═══════════════════════════════════════════════════════════════════════════

  group('HasilPajak model', () {
    test('ptkpLabel should return correct format', () {
      final hasilTK = const HasilPajak(
        gajiBruto: 5000000,
        statusPTKP: 'Belum Menikah',
        jumlahTanggungan: 0,
        penghasilanBruto: 60000000,
        penghasilanNeto: 57000000,
        ptkp: 54000000,
        pkp: 3000000,
        pph21: 12500,
      );
      expect(hasilTK.ptkpLabel, 'TK/0');

      final hasilK1 = const HasilPajak(
        gajiBruto: 5000000,
        statusPTKP: 'Sudah Menikah',
        jumlahTanggungan: 1,
        penghasilanBruto: 60000000,
        penghasilanNeto: 57000000,
        ptkp: 63000000,
        pkp: 0,
        pph21: 0,
      );
      expect(hasilK1.ptkpLabel, 'K/1');
    });

    test('takeHomePay should equal gajiBruto minus pph21', () {
      final hasil = const HasilPajak(
        gajiBruto: 10000000,
        statusPTKP: 'Belum Menikah',
        jumlahTanggungan: 0,
        penghasilanBruto: 120000000,
        penghasilanNeto: 114000000,
        ptkp: 54000000,
        pkp: 60000000,
        pph21: 333333,
      );

      expect(hasil.takeHomePay, 10000000 - 333333);
    });
  });
}
