// =============================================================================
// app_loading_view.dart
// Komponen reusable loading screen untuk proses loading di berbagai page.
// Menerima parameter: mascotPath, subtitle, title, delayDuration, onLoadingDone.
// Background: orange50, animasi fade-in pada konten.
// =============================================================================

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'app_back_button.dart';

class AppLoadingView extends StatefulWidget {
  /// Path asset SVG mascot
  final String mascotPath;

  /// Teks sub-judul (misal: "Pos 1 - Modul PPh 21")
  final String subtitle;

  /// Teks judul utama
  final String title;

  /// Durasi delay sebelum callback dipanggil (default: 5 detik)
  final Duration delayDuration;

  /// Callback setelah delay selesai
  final VoidCallback onLoadingDone;

  /// Callback saat tombol back ditekan (opsional)
  final VoidCallback? onBack;

  /// Ukuran mascot (default: 160x160)
  final double mascotSize;

  const AppLoadingView({
    super.key,
    required this.mascotPath,
    required this.subtitle,
    required this.title,
    this.delayDuration = const Duration(seconds: 5),
    required this.onLoadingDone,
    this.onBack,
    this.mascotSize = 160,
  });

  @override
  State<AppLoadingView> createState() => _AppLoadingViewState();
}

class _AppLoadingViewState extends State<AppLoadingView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();

    // ── Animasi fade-in ──────────────────────────────────────────────
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    // ── Timer delay ──────────────────────────────────────────────────
    Timer(widget.delayDuration, () {
      if (mounted) widget.onLoadingDone();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.orange50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top Bar: Back Button ────────────────────────────────
              AppBackButton(
                onPressed: widget.onBack ?? () => Navigator.of(context).pop(),
              ),

              // ── Main Content (Center) ──────────────────────────────
              Expanded(
                child: FadeTransition(
                  opacity: _fadeIn,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ── Mascot SVG ────────────────────────────
                        SizedBox(
                          width: widget.mascotSize,
                          height: widget.mascotSize,
                          child: SvgPicture.asset(
                            widget.mascotPath,
                            fit: BoxFit.cover,
                            placeholderBuilder: (context) => Icon(
                              Icons.image_outlined,
                              size: widget.mascotSize * 0.5,
                              color: AppColors.orange300,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ── Subtitle ──────────────────────────────
                        Text(
                          widget.subtitle,
                          style: AppTypography.titleMediumBold.copyWith(
                            color: AppColors.orange950,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),

                        // ── Title ─────────────────────────────────
                        Text(
                          widget.title,
                          style: AppTypography.displaySmallBold.copyWith(
                            color: AppColors.orange950,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Footer: "Memuat" ────────────────────────────────────
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Text(
                    'Memuat',
                    style: AppTypography.bodySmallSemiBold.copyWith(
                      color: AppColors.orange950,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
