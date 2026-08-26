// =============================================================================
// splash_view.dart
// Halaman splash screen — Logo fade in, tahan, fade out, lalu navigasi.
// Background orange-100 tetap sampai navigasi terjadi (tanpa layar hitam).
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _logoFadeIn;
  late Animation<double> _logoFadeOut;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startInitialization();
  }

  void _setupAnimations() {
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    // ── Logo Fade In (0% - 25%) ──────────────────────────────
    _logoFadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.25, curve: Curves.easeIn),
      ),
    );

    // ── Logo Fade Out (75% - 100%) ───────────────────────────
    _logoFadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.75, 1.0, curve: Curves.easeOut),
      ),
    );

    _animController.forward();
  }

  Future<void> _startInitialization() async {
    await _animController.forward();
    if (!mounted) return;
    _navigateNext();
  }

  void _navigateNext() {
    final session = Supabase.instance.client.auth.currentSession;

    if (session != null) {
      context.go(AppRoutes.home);
    } else {
      context.go(AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.orange100,
      body: Center(
        child: AnimatedBuilder(
          animation: _animController,
          builder: (context, child) {
            // Gabungkan fade in dan fade out
            final opacity = _logoFadeIn.value * _logoFadeOut.value;
            return Opacity(opacity: opacity, child: child);
          },
          child: SvgPicture.asset(
            'assets/svg/logo_square.svg',
            width: 200,
            height: 200,
          ),
        ),
      ),
    );
  }
}
