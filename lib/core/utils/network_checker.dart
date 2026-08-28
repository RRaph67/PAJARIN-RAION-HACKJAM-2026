// =============================================================================
// network_checker.dart
// Utility untuk memeriksa koneksi internet sebelum melakukan request ke
// Supabase atau API lainnya. Mencegah error SocketException yang tidak jelas.
// =============================================================================

import 'dart:async';
import 'dart:io';

class NetworkChecker {
  NetworkChecker._();

  /// Cek apakah device memiliki koneksi internet aktif.
  /// Menggunakan DNS lookup ke Google DNS (8.8.8.8) sebagai indikator.
  ///
  /// Mengembalikan `true` jika koneksi tersedia, `false` jika tidak.
  static Future<bool> hasConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Cek koneksi ke Supabase secara spesifik.
  /// Lebih akurat daripada `hasConnection()` karena memastikan
  /// hostname Supabase bisa di-resolve.
  static Future<bool> hasSupabaseConnection(String supabaseUrl) async {
    try {
      // Extract hostname dari URL
      final uri = Uri.parse(supabaseUrl);
      final result = await InternetAddress.lookup(uri.host)
          .timeout(const Duration(seconds: 5));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Dapatkan pesan error yang user-friendly berdasarkan jenis gangguan.
  static String getFriendlyMessage(Object error) {
    final errorStr = error.toString().toLowerCase();

    if (errorStr.contains('failed host lookup') ||
        errorStr.contains('no address associated with hostname')) {
      return 'Tidak dapat terhubung ke server. '
          'Pastikan koneksi internet aktif dan tidak diblokir oleh jaringan.';
    }

    if (errorStr.contains('connection refused') ||
        errorStr.contains('connection timed out')) {
      return 'Koneksi ke server gagal. Silakan coba lagi dalam beberapa saat.';
    }

    if (errorStr.contains('socketException') ||
        errorStr.contains('errno = 101') ||
        errorStr.contains('errno = 7')) {
      return 'Tidak ada koneksi internet. '
          'Silakan periksa WiFi atau data seluler kamu.';
    }

    if (errorStr.contains('network is unreachable')) {
      return 'Jaringan tidak tersedia. '
          'Pastikan WiFi atau data seluler aktif.';
    }

    return 'Terjadi kesalahan koneksi. Silakan coba lagi.';
  }
}
