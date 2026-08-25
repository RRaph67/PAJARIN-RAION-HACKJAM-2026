// =============================================================================
// app_router.dart
// Konfigurasi navigasi menggunakan GoRouter untuk RaionHackJam15.
// Ikuti pola Feature-First: tambahkan rute baru di bagian fitur masing-masing.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/views/splash_view.dart';
import '../../features/home/views/home_view.dart';
import '../../features/auth/views/auth_view.dart';
import '../../features/profile/views/profile_view.dart';

// ─── Nama/Path Rute ───────────────────────────────────────────────────────────
// Gunakan konstanta ini saat berpindah halaman agar tidak salah ketik.
// Contoh: context.go(AppRoutes.home)
class AppRoutes {
  AppRoutes._(); // class ini tidak boleh diinstansiasi

  static const String splash = '/';       // halaman splash (pertama kali buka app)
  static const String home = '/home';     // halaman utama
  static const String auth = '/auth';     // halaman login / register
  static const String profile = '/profile'; // halaman profil pengguna

  // [PLACEHOLDER] Tambahkan rute sesuai fitur yang dibangun, contoh:
  // static const String detail   = '/detail/:id'; // rute dinamis dengan parameter
}

// ─── Provider GoRouter ────────────────────────────────────────────────────────
// GoRouter dibuat sebagai Riverpod Provider agar bisa mengakses state (misal:
// status login) untuk keperluan redirect/guard navigasi.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,  // halaman yang pertama dibuka
    debugLogDiagnostics: true,          // cetak log navigasi — nonaktifkan saat production

    // [PLACEHOLDER] Aktifkan redirect di bawah untuk membuat auth guard.
    // Auth guard akan mengalihkan pengguna yang belum login ke halaman login.
    // redirect: (context, state) {
    //   final isLoggedIn = ref.read(authProvider).isLoggedIn;
    //   final isOnLoginPage = state.matchedLocation == AppRoutes.login;
    //
    //   // Jika belum login dan bukan di halaman login → arahkan ke login
    //   if (!isLoggedIn && !isOnLoginPage) return AppRoutes.login;
    //
    //   // Jika sudah login tapi masih di halaman login → arahkan ke home
    //   if (isLoggedIn && isOnLoginPage) return AppRoutes.home;
    //
    //   // Tidak ada pengalihan
    //   return null;
    // },

    routes: [
      // ── Splash Screen ────────────────────────────────────────────────
      // Halaman pertama yang muncul saat aplikasi dibuka.
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashView(),
      ),

      // ── Home Screen ──────────────────────────────────────────────────
      // Halaman utama aplikasi setelah splash selesai.
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomeView(),
      ),

      // ── Auth Screen (Login / Register) ────────────────────────────────
      // Halaman autentikasi dengan mode register dan login.
      GoRoute(
        path: AppRoutes.auth,
        name: 'auth',
        builder: (context, state) => const AuthView(),
      ),

      // ── Profile Screen ────────────────────────────────────────────────
      // Halaman profil pengguna — lihat, edit, dan update data profil.
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (context, state) => const ProfileView(),
      ),
    ],

    // Halaman yang ditampilkan jika rute tidak ditemukan (404)
    errorBuilder: (context, state) => _RouterErrorView(error: state.error),
  );
});

// ─── Halaman Error 404 ────────────────────────────────────────────────────────
// Ditampilkan otomatis oleh GoRouter jika pengguna membuka rute yang tidak ada.
class _RouterErrorView extends StatelessWidget {
  final Exception? error;
  const _RouterErrorView({this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Halaman Tidak Ditemukan')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              '404 — Halaman Tidak Ditemukan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              error?.toString() ?? 'Rute tidak dikenal',
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
