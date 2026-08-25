// =============================================================================
// dio_client.dart
// HTTP client berbasis Dio untuk proyek RaionHackJam15.
// Berisi: konfigurasi dasar, interceptor autentikasi, interceptor logging,
// dan helper untuk pesan error yang ramah pengguna.
// =============================================================================

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

// ─── Provider Riverpod ────────────────────────────────────────────────────────
// Gunakan provider ini untuk mengakses DioClient dari ViewModel.
// Contoh: final dioClient = ref.read(dioClientProvider);
final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

// ─── DioClient ────────────────────────────────────────────────────────────────
// Class utama yang membungkus instance Dio dengan konfigurasi siap pakai.
class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrlApi,         // URL dasar semua request
        connectTimeout: AppConstants.connectTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        sendTimeout: AppConstants.sendTimeout,
        headers: {
          'Content-Type': 'application/json',     // kirim data dalam format JSON
          'Accept': 'application/json',           // terima respons dalam format JSON
        },
      ),
    );

    // Daftarkan interceptor — urutan pendaftaran = urutan eksekusi
    _dio.interceptors.addAll([
      _AuthInterceptor(),    // tambahkan token ke setiap request
      _LoggingInterceptor(), // cetak log request & respons di konsol
    ]);
  }

  // Akses langsung ke instance Dio (jika diperlukan untuk kasus khusus)
  Dio get instance => _dio;

  // ── Method HTTP Shortcut ─────────────────────────────────────────────────
  // Gunakan method di bawah ini untuk melakukan request HTTP dari ViewModel.

  /// Melakukan HTTP GET request ke [path].
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.get<T>(path,
        queryParameters: queryParameters, options: options);
  }

  /// Melakukan HTTP POST request ke [path] dengan [data] sebagai body.
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.post<T>(path,
        data: data, queryParameters: queryParameters, options: options);
  }

  /// Melakukan HTTP PUT request ke [path] untuk memperbarui data.
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Options? options,
  }) async {
    return _dio.put<T>(path, data: data, options: options);
  }

  /// Melakukan HTTP DELETE request ke [path] untuk menghapus data.
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Options? options,
  }) async {
    return _dio.delete<T>(path, data: data, options: options);
  }
}

// ─── Interceptor Autentikasi ──────────────────────────────────────────────────
// Interceptor ini berjalan secara otomatis sebelum setiap request dikirim.
// Fungsinya: membaca token dari SharedPreferences lalu menyisipkannya
// ke header "Authorization" sebagai Bearer token.
class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefKeyToken);

      // Jika token ada dan tidak kosong, sisipkan ke header
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (_) {
      // Gagal secara diam-diam — request tanpa token tetap diteruskan
    }

    handler.next(options); // teruskan request ke interceptor berikutnya
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // [PLACEHOLDER] Tangani token kedaluwarsa / auto-refresh di sini.
      // Contoh: coba refresh session Supabase, lalu ulangi request.
      // Untuk sementara, error diteruskan ke pemanggil.
    }
    handler.next(err);
  }
}

// ─── Interceptor Logging ──────────────────────────────────────────────────────
// Mencetak log setiap request dan respons ke konsol saat pengembangan.
// Nonaktifkan atau hapus interceptor ini saat build production.
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // ignore: avoid_print
    print('[DIO] → ${options.method} ${options.path}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // ignore: avoid_print
    print('[DIO] ← ${response.statusCode} ${response.requestOptions.path}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // ignore: avoid_print
    print(
        '[DIO] ✗ ${err.response?.statusCode} ${err.requestOptions.path} — ${err.message}');
    handler.next(err);
  }
}

// ─── Extension: Pesan Error Ramah Pengguna ────────────────────────────────────
// Gunakan properti [friendlyMessage] saat ingin menampilkan pesan error
// ke pengguna. Lebih baik daripada menampilkan pesan teknis Dio mentah.
//
// Contoh pemakaian:
//   } on DioException catch (e) {
//     showSnackBar(e.friendlyMessage);
//   }
extension DioExceptionX on DioException {
  String get friendlyMessage {
    switch (type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'Koneksi terlalu lama. Periksa koneksi internet Anda.';
      case DioExceptionType.connectionError:
        return 'Tidak ada koneksi internet. Coba lagi nanti.';
      case DioExceptionType.badResponse:
        return response?.data?['message'] as String? ??
            'Terjadi kesalahan server (${response?.statusCode})';
      default:
        return 'Terjadi kesalahan. Silakan coba lagi.';
    }
  }
}
