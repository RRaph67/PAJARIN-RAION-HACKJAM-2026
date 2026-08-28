// =============================================================================
// app_router.dart
// Konfigurasi navigasi menggunakan GoRouter untuk Pajarin.
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
import '../../features/main/views/main_shell_view.dart';
import '../../features/home/views/jelajahi_pos_view.dart';
import '../../features/pos/views/pos_detail_view.dart';
import '../../features/pos/views/pos_loading_view.dart';
import '../../features/profile/views/profile_view.dart';
import '../../features/simulasi/views/kalkulator_simulasi_view.dart';
import '../../features/simulasi/views/simulasi_loading_view.dart';
import '../../features/simulasi/views/hasil_kalkulator_view.dart';
import '../../features/profile/views/faq_pajak_view.dart';
import '../../features/profile/views/coretax_checklist_view.dart';
import '../../features/profile/views/apa_itu_coretax_view.dart';
import '../../features/profile/views/change_password_view.dart';
import '../../features/profile/views/edit_profile_view.dart';

// ─── Nama/Path Rute ───────────────────────────────────────────────────────────
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String linkup = '/linkup';
  static const String onboardingIntro = '/onboarding-intro';
  static const String onboardingCore = '/onboarding-core';
  static const String profile = '/profile';
  static const String simulasi = '/simulasi';
  static const String simulasiLoading = '/simulasi/loading';
  static const String simulasiHasil = '/simulasi/hasil';
  static const String jelajahiPos = '/home/jelajahi-pos';
  static const String posDetail = '/home/jelajahi-pos/pos';
  static const String posLoading = '/home/jelajahi-pos/pos-loading';
  static const String faqPajak = '/profile/faq-pajak';
  static const String coretaxChecklist = '/profile/coretax-checklist';
  static const String apaItuCoretax = '/profile/apa-itu-coretax';
  static const String changePassword = '/profile/change-password';
  static const String editProfile = '/profile/edit-profile';
}

// ─── Provider GoRouter ────────────────────────────────────────────────────────
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final session = Supabase.instance.client.auth.currentSession;
      final isLoggedIn = session != null;
      final location = state.matchedLocation;

      final publicRoutes = [
        AppRoutes.splash,
        AppRoutes.login,
        AppRoutes.register,
        AppRoutes.linkup,
        AppRoutes.onboardingIntro,
        AppRoutes.onboardingCore,
        AppRoutes.jelajahiPos,
      ];
      final isPublicRoute = publicRoutes.contains(location);

      if (!isLoggedIn && !isPublicRoute) {
        // User tanpa session mencoba akses halaman yang dilindungi.
        // Terpental ke splash screen, lalu splash arahkan ke login.
        return AppRoutes.splash;
      }

      return null;
    },
    routes: [
      // ── Splash Screen ────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashView(),
      ),

      // ── Login Screen ──────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginView(),
      ),

      // ── Register Screen ───────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => const RegisterView(),
      ),

      // ── Linkup Screen ─────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.linkup,
        name: 'linkup',
        builder: (context, state) => const LinkupView(),
      ),

      // ── Onboarding Intro Screen ───────────────────────────────────────
      GoRoute(
        path: AppRoutes.onboardingIntro,
        name: 'onboarding-intro',
        builder: (context, state) => const OnboardingIntroView(),
      ),

      // ── Onboarding Core Screen ────────────────────────────────────────
      GoRoute(
        path: AppRoutes.onboardingCore,
        name: 'onboarding-core',
        builder: (context, state) => const OnboardingCoreView(),
      ),

      // ── Simulasi Loading Screen ──────────────────────────────────────
      GoRoute(
        path: AppRoutes.simulasiLoading,
        name: 'simulasi-loading',
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>? ?? {};
          return SimulasiLoadingView(
            gaji: (data['gaji'] as num?)?.toDouble() ?? 0,
            ptkp: data['ptkp'] as String? ?? '',
            tanggungan: data['tanggungan'] as int? ?? 0,
          );
        },
      ),

      // ── CoreTax Checklist Screen ────────────────────────────────────────
      GoRoute(
        path: AppRoutes.coretaxChecklist,
        name: 'coretax-checklist',
        builder: (context, state) => const CoreTaxChecklistView(),
      ),

      // ── Apa itu CoreTax Screen ───────────────────────────────────────────
      GoRoute(
        path: AppRoutes.apaItuCoretax,
        name: 'apa-itu-coretax',
        builder: (context, state) => const ApaItuCoretaxView(),
      ),

      // ── Edit Profile Screen ─────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.editProfile,
        name: 'edit-profile',
        builder: (context, state) => const EditProfileView(),
      ),

      // ── Change Password Screen ─────────────────────────────────────────
      GoRoute(
        path: AppRoutes.changePassword,
        name: 'change-password',
        builder: (context, state) => const ChangePasswordView(),
      ),

      // ── FAQ Pajak Screen ───────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.faqPajak,
        name: 'faq-pajak',
        builder: (context, state) => const FaqPajakView(),
      ),

      // ── Simulasi Hasil Screen ─────────────────────────────────────────
      GoRoute(
        path: AppRoutes.simulasiHasil,
        name: 'simulasi-hasil',
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>? ?? {};
          return HasilKalkulatorView(
            gaji: (data['gaji'] as num?)?.toDouble() ?? 0,
            ptkp: data['ptkp'] as String? ?? '',
            tanggungan: data['tanggungan'] as int? ?? 0,
          );
        },
      ),

      // ── Main Shell (Bottom Navbar) ────────────────────────────────────
      // StatefulShellRoute mempertahankan state per tab (tidak rebuild
      // saat berpindah tab) — persis seperti mobile app pada umumnya.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShellView(navigationShell: navigationShell);
        },
        branches: [
          // ── Tab 1: Beranda ──────────────────────────────────────────
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                name: 'home',
                builder: (context, state) => const HomeView(),
                routes: [
                  GoRoute(
                    path: 'jelajahi-pos',
                    name: 'jelajahi-pos',
                    builder: (context, state) => const JelajahiPosView(),
                    routes: [
                      GoRoute(
                        path: 'pos-loading/:posId',
                        name: 'pos-loading',
                        builder: (context, state) {
                          final posId = int.parse(
                            state.pathParameters['posId']!,
                          );
                          return PosLoadingView(posId: posId);
                        },
                      ),
                      GoRoute(
                        path: 'pos/:posId',
                        name: 'pos-detail',
                        builder: (context, state) {
                          final posId = int.parse(
                            state.pathParameters['posId']!,
                          );
                          final initialSlide =
                              int.tryParse(
                                state.uri.queryParameters['slide'] ?? '0',
                              ) ??
                              0;
                          return PosDetailView(
                            posId: posId,
                            initialSlide: initialSlide,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // ── Tab 2: Simulasi ─────────────────────────────────────────
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.simulasi,
                name: 'simulasi',
                builder: (context, state) => const KalkulatorSimulasiView(),
              ),
            ],
          ),

          // ── Tab 3: Profile ──────────────────────────────────────────
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                name: 'profile',
                builder: (context, state) => const ProfileView(),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => _RouterErrorView(error: state.error),
  );
});

// ─── Halaman Error 404 ────────────────────────────────────────────────────────
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
