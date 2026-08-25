// =============================================================================
// splash_view.dart
// Halaman splash screen untuk RaionHackJam15.
// Menampilkan logo + animasi sambil memeriksa inisialisasi aplikasi,
// lalu berpindah ke halaman selanjutnya (Home atau Login).
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_router.dart';
import '../../../core/constants/app_constants.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _setupAnimations(); // siapkan animasi
    _startInitialization(); // mulai proses inisialisasi
  }

  /// Mengkonfigurasi animasi fade (muncul perlahan) dan scale (membesar).
  void _setupAnimations() {
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Animasi opacity: dari transparan (0) → terlihat penuh (1)
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    // Animasi ukuran: dari kecil (0.7) → ukuran normal (1.0) dengan efek elastis
    _scaleAnim = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _animController.forward(); // mulai putar animasi
  }

  /// Menjalankan animasi dan pengecekan awal secara bersamaan (parallel).
  /// Baru berpindah halaman setelah keduanya selesai.
  Future<void> _startInitialization() async {
    await Future.wait([
      Future.delayed(const Duration(milliseconds: 2500)), // minimum durasi splash
      _runChecks(), // jalankan pengecekan di background
    ]);

    // Pastikan widget masih terpasang sebelum navigasi
    if (!mounted) return;
    _navigateNext();
  }

  /// Tempat untuk menjalankan logika pengecekan saat aplikasi pertama buka.
  Future<void> _runChecks() async {
    // [PLACEHOLDER] Tambahkan logika inisialisasi di sini, contoh:
    //
    // ① Cek apakah pengguna sudah login (session Supabase masih aktif):
    //    final session = Supabase.instance.client.auth.currentSession;
    //
    // ② Baca flag onboarding dari SharedPreferences:
    //    final prefs = await SharedPreferences.getInstance();
    //    final isOnboarded = prefs.getBool(AppConstants.prefKeyIsOnboarded) ?? false;
    //
    // ③ Pre-fetch data yang diperlukan di halaman pertama

    await Future.delayed(const Duration(milliseconds: 500)); // simulasi loading
  }

  /// Menentukan halaman tujuan setelah splash selesai.
  void _navigateNext() {
    // [PLACEHOLDER] Ganti logika ini dengan pengecekan status login:
    //
    //   if (isLoggedIn) {
    //     context.go(AppRoutes.home);    // sudah login → ke home
    //   } else {
    //     context.go(AppRoutes.login);   // belum login → ke halaman login
    //   }
    context.go(AppRoutes.home);
  }

  @override
  void dispose() {
    _animController.dispose(); // selalu dispose controller agar tidak memory leak
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // [PLACEHOLDER] Ganti dengan AppColors.background setelah app_theme.dart diisi
      backgroundColor: const Color(0xFF1A1A2E),
      body: Center(
        child: AnimatedBuilder(
          animation: _animController,
          builder: (context, child) {
            // Terapkan animasi fade dan scale secara bersamaan
            return FadeTransition(
              opacity: _fadeAnim,
              child: ScaleTransition(
                scale: _scaleAnim,
                child: child,
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── Logo Aplikasi ─────────────────────────────────────────
              // [PLACEHOLDER] Ganti Container ini dengan:
              //   SvgPicture.asset(AppConstants.svgLogo, width: 100, height: 100)
              //   setelah file SVG diterima dari tim UI/UX.
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  // [PLACEHOLDER] Ganti dengan AppColors.primary
                  color: const Color(0xFF6C63FF),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.rocket_launch_rounded,
                  color: Colors.white,
                  size: 52,
                ),
              ),

              const SizedBox(height: 24),

              // ── Nama Aplikasi ─────────────────────────────────────────
              Text(
                AppConstants.appName,
                style: const TextStyle(
                  // [PLACEHOLDER] Ganti dengan token dari AppTypography
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),

              const SizedBox(height: 8),

              // ── Tagline ───────────────────────────────────────────────
              // [PLACEHOLDER] Ganti teks ini dengan tagline aplikasi yang asli
              const Text(
                '[PLACEHOLDER: Tagline aplikasi di sini]',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 48),

              // ── Indikator Loading ─────────────────────────────────────
              // Spinner kecil yang menunjukkan aplikasi sedang memuat
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  // [PLACEHOLDER] Ganti dengan AppColors.primary
                  color: Color(0xFF6C63FF),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
