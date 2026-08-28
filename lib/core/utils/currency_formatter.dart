// =============================================================================
// currency_formatter.dart
// Utility untuk format mata uang Rupiah.
// Shared di seluruh aplikasi.
// =============================================================================

class CurrencyFormatter {
  CurrencyFormatter._();

  /// Format angka ke format Rupiah: 5000000 → "Rp5.000.000"
  static String formatRupiah(double value) {
    final str = value.toStringAsFixed(0);
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(str[i]);
    }
    return 'Rp${buffer.toString()}';
  }

  /// Format angka ke format Rupiah tanpa prefix "Rp": 5000000 → "5.000.000"
  static String formatNumber(double value) {
    final str = value.toStringAsFixed(0);
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(str[i]);
    }
    return buffer.toString();
  }

  /// Parse string Rupiah ke double: "5.000.000" → 5000000.0
  static double parseRupiah(String value) {
    return double.tryParse(value.replaceAll('.', '').replaceAll(',', '')) ?? 0;
  }
}
