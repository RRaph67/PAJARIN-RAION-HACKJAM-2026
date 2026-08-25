// =============================================================================
// main.dart
// Titik masuk utama aplikasi RaionHackJam15.
// Urutan inisialisasi: Flutter binding → Supabase → App
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/constants/app_constants.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  // ── 1. Inisialisasi Flutter binding ───────────────────────────────────────
  // Wajib dipanggil sebelum menggunakan plugin atau kode async di main().
  WidgetsFlutterBinding.ensureInitialized();

  // ── 2. Inisialisasi Supabase ───────────────────────────────────────────────
  // [PLACEHOLDER] Isi SUPABASE_URL dan SUPABASE_ANON_KEY di app_constants.dart
  // Dapatkan nilainya dari: Supabase Dashboard → Project Settings → API
  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
    debug: true, // ubah ke false saat production
  );

  // ── 3. Jalankan aplikasi dan bungkus dengan ProviderScope ─────────────────
  // ProviderScope diperlukan agar semua Riverpod provider bisa diakses
  // di seluruh widget tree.
  runApp(
    const ProviderScope(
      child: RaionHackJam15App(),
    ),
  );
}

// ─── Akses cepat ke Supabase client ───────────────────────────────────────────
// Gunakan variabel `supabase` ini dari mana saja di dalam aplikasi.
// Contoh: supabase.auth.currentUser
final supabase = Supabase.instance.client;

// ─── Widget Root Aplikasi ─────────────────────────────────────────────────────
class RaionHackJam15App extends ConsumerWidget {
  const RaionHackJam15App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Ambil instance GoRouter dari provider
    final router = ref.watch(appRouterProvider);

    return ScreenUtilInit(
      // [PLACEHOLDER] Konfirmasi ukuran ini ke tim UI/UX:
      // "Berapa resolusi frame/canvas yang kamu pakai di Figma?"
      // Nilai umum: Size(360, 800) atau Size(375, 812)
      designSize: Size(AppConstants.designWidth, AppConstants.designHeight),

      // Aktifkan adaptasi ukuran teks secara otomatis
      minTextAdapt: true,

      // Aktifkan dukungan mode layar terbagi (split screen)
      splitScreenMode: true,

      builder: (context, child) {
        return MaterialApp.router(
          // ── Info Aplikasi ──────────────────────────────────────────────
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false, // sembunyikan banner debug

          // ── Tema ──────────────────────────────────────────────────────
          theme: AppTheme.lightTheme,
          // [PLACEHOLDER] Aktifkan setelah dark theme selesai dibuat:
          // darkTheme: AppTheme.darkTheme,
          // themeMode: ThemeMode.system, // ikuti pengaturan sistem

          // ── Router ────────────────────────────────────────────────────
          // Menghubungkan GoRouter ke MaterialApp
          routerConfig: router,
        );
      },
    );
  }
}
