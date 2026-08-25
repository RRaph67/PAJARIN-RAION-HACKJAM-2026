// =============================================================================
// app_constants.dart
// Semua konstanta terpusat untuk proyek RaionHackJam15.
// Gunakan Ctrl+Shift+F dan cari "[PLACEHOLDER]" untuk menemukan semua nilai
// yang perlu diisi sebelum aplikasi bisa berjalan.
// =============================================================================

class AppConstants {
  AppConstants._(); // class ini tidak boleh diinstansiasi

  // ─── Supabase ─────────────────────────────────────────────────────────────
  // Cara mendapatkan: Supabase Dashboard → Project Settings → API
  static const String supabaseUrl =
      '[PLACEHOLDER: https://xxxxxxxxxxxxxxxxxxxx.supabase.co]';
  static const String supabaseAnonKey =
      '[PLACEHOLDER: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...]';

  // ─── URL API Backend Tambahan ─────────────────────────────────────────────
  // Kosongkan jika Supabase adalah satu-satunya backend yang digunakan.
  static const String baseUrlApi =
      '[PLACEHOLDER: https://api.your-backend.com/v1]';

  // ─── Konfigurasi Timeout HTTP ─────────────────────────────────────────────
  // connectTimeout : batas waktu untuk membuka koneksi
  // receiveTimeout : batas waktu menunggu respons dari server
  // sendTimeout    : batas waktu untuk mengirim data ke server
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // ─── Kunci SharedPreferences ──────────────────────────────────────────────
  // Kunci-kunci ini digunakan untuk menyimpan & membaca data lokal.
  static const String prefKeyToken = 'auth_token';        // token autentikasi
  static const String prefKeyUserId = 'user_id';          // ID pengguna yang login
  static const String prefKeyIsOnboarded = 'is_onboarded'; // sudah onboarding?
  static const String prefKeyThemeMode = 'theme_mode';    // preferensi tema
  // [PLACEHOLDER] Tambahkan kunci SharedPref lain sesuai kebutuhan fitur

  // ─── Path Aset : SVG & Ikon ───────────────────────────────────────────────
  // [PLACEHOLDER] Ganti nama file dengan nama file asli dari tim UI/UX
  // Letakkan file SVG di dalam folder: assets/svg/ dan assets/icons/
  static const String svgLogo = 'assets/svg/[PLACEHOLDER_logo].svg';
  static const String svgIllustrationSplash =
      'assets/svg/[PLACEHOLDER_splash_illustration].svg';
  static const String iconHome = 'assets/icons/[PLACEHOLDER_icon_home].svg';
  static const String iconProfile =
      'assets/icons/[PLACEHOLDER_icon_profile].svg';

  // ─── Path Aset : Gambar (PNG/JPG) ─────────────────────────────────────────
  // [PLACEHOLDER] Ganti nama file dengan nama file asli dari tim UI/UX
  // Letakkan file gambar di dalam folder: assets/images/
  static const String imgAppIcon =
      'assets/images/[PLACEHOLDER_app_icon].png';         // ukuran: 1024×1024
  static const String imgOnboarding1 =
      'assets/images/[PLACEHOLDER_onboarding_1].png';

  // ─── Ukuran Desain ScreenUtil ─────────────────────────────────────────────
  // [PLACEHOLDER] Tanyakan ke tim UI/UX: "Berapa resolusi frame di Figma?"
  // Nilai yang umum dipakai: 360×800 atau 375×812
  // Ukuran ini digunakan sebagai referensi ScreenUtil untuk responsivitas.
  static const double designWidth = 360;
  static const double designHeight = 800;

  // ─── Informasi Aplikasi ───────────────────────────────────────────────────
  static const String appName = 'RaionHackJam15';
  static const String appVersion = '1.0.0';
}
