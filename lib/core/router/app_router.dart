// =============================================================================
// app_router.dart
// Konfigurasi navigasi menggunakan GoRouter untuk RaionHackJam15.
// Ikuti pola Feature-First: tambahkan rute baru di bagian fitur masing-masing.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/splash/views/splash_view.dart';
import '../../features/home/views/home_view.dart';
import '../../features/auth/views/login_view.dart';
import '../../features/auth/views/register_view.dart';
import '../../features/complete_profile/views/comprof_view.dart';
import '../../features/onboarding/views/onboarding_intro_view.dart';
import '../../features/onboarding/views/onboarding_core_view.dart';
import '../../features/profile/views/profile_view.dart';

// ─── Nama/Path Rute ───────────────────────────────────────────────────────────
// Gunakan konstanta ini saat berpindah halaman agar tidak salah ketik.
// Contoh: context.go(AppRoutes.home)
class AppRoutes {
  AppRoutes._(); // class ini tidak boleh diinstansiasi

  static const String splash = '/'; // halaman splash (pertama kali buka app)
  static const String home = '/home'; // halaman utama
  static const String login = '/login'; // halaman login
  static const String register = '/register'; // halaman register
  static const String linkup = '/linkup'; // halaman lengkapi profil
  static const String onboardingIntro = '/onboarding-intro'; // halaman pengenalan onboarding
  static const String onboardingCore = '/onboarding-core'; // halaman core onboarding (3 step)
  static const String profile = '/profile'; // halaman profil pengguna

  // [PLACEHOLDER] Tambahkan rute sesuai fitur yang dibangun, contoh:
  // static const String detail   = '/detail/:id'; // rute dinamis dengan parameter
}

// ─── Provider GoRouter ────────────────────────────────────────────────────────
// GoRouter dibuat sebagai Riverpod Provider agar bisa mengakses state (misal:
// status login) untuk keperluan redirect/guard navigasi.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash, // halaman yang pertama dibuka
    debugLogDiagnostics:
        true, // cetak log navigasi — nonaktifkan saat production
    // Auth guard: alihkan pengguna berdasarkan status login
    redirect: (context, state) {
      final session = Supabase.instance.client.auth.currentSession;
      final isLoggedIn = session != null;
      final location = state.matchedLocation;

      // Rute yang tidak memerlukan login
      final publicRoutes = [
        AppRoutes.splash,
        AppRoutes.login,
        AppRoutes.register,
        AppRoutes.linkup,
        AppRoutes.onboardingIntro,
        AppRoutes.onboardingCore,
      ];
      final isPublicRoute = publicRoutes.contains(location);

      // Jika belum login dan bukan di rute publik → arahkan ke login
      if (!isLoggedIn && !isPublicRoute) {
        return AppRoutes.login;
      }

      // Tidak ada pengalihan
      return null;
    },
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

      // ── Login Screen ──────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginView(),
      ),

      // ── Register Screen ────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => const RegisterView(),
      ),

      // ── Linkup Screen ──────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.linkup,
        name: 'linkup',
        builder: (context, state) => const LinkupView(),
      ),

      // ── Onboarding Intro Screen ──────────────────────────────────
      GoRoute(
        path: AppRoutes.onboardingIntro,
        name: 'onboarding-intro',
        builder: (context, state) => const OnboardingIntroView(),
      ),

      // ── Onboarding Core Screen ───────────────────────────────────
      GoRoute(
        path: AppRoutes.onboardingCore,
        name: 'onboarding-core',
        builder: (context, state) => const OnboardingCoreView(),
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
