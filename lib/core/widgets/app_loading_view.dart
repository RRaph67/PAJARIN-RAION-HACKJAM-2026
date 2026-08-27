// =============================================================================
// app_loading_view.dart
// Komponen halaman loading reusable untuk seluruh aplikasi.
// Bisa dikustomisasi: judul, sub-judul, ukuran maskot, dan aksi back.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'app_back_button.dart';

class AppLoadingView extends StatelessWidget {
  /// Judul utama (Main Title) — besar, ExtraBold.
  final String title;

  /// Sub judul di atas main title — SemiBold 18.
  final String? subtitle;

  /// Path aset maskot. Default: assets/svg/maskot_mikir.svg.
  final String mascotAsset;

  /// Lebar maskot. Default: 250.
  final double mascotWidth;

  /// Tinggi maskot. Default: 250.
  final double mascotHeight;

  /// Callback saat tombol back ditekan. Jika null, tombol tidak ditampilkan.
  final VoidCallback? onBackPressed;

  /// Teks "Memuat ...". Default: "Memuat".
  final String loadingText;

  const AppLoadingView({
    super.key,
    required this.title,
    this.subtitle,
    this.mascotAsset = 'assets/svg/maskot_mikir.svg',
    this.mascotWidth = 250,
    this.mascotHeight = 250,
    this.onBackPressed,
    this.loadingText = 'Memuat',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.orange50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Back Button ──────────────────────────────────────────────
              if (onBackPressed != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: AppBackButton(onPressed: onBackPressed),
                ),

              // ── Spacer atas ─────────────────────────────────────────────
              const Spacer(),

              // ── Maskot ──────────────────────────────────────────────────
              SvgPicture.asset(
                mascotAsset,
                width: mascotWidth,
                height: mascotHeight,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 16),

              // ── Sub Title (opsional) ────────────────────────────────────
              if (subtitle != null)
                Text(
                  subtitle!,
                  textAlign: TextAlign.center,
                  style: AppTypography.headlineSmallSemiBold.copyWith(
                    color: AppColors.orange950,
                  ),
                ),

              if (subtitle != null) const SizedBox(height: 8),

              // ── Main Title ──────────────────────────────────────────────
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTypography.displaySmallExtraBold.copyWith(
                  color: AppColors.orange950,
                ),
              ),

              const SizedBox(height: 24),

              // ── Loading Circle ──────────────────────────────────────────
              SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                  color: AppColors.orange950,
                  backgroundColor: AppColors.orange200,
                ),
              ),

              const SizedBox(height: 12),

              // ── "Memuat" Text ───────────────────────────────────────────
              Text(
                loadingText,
                style: AppTypography.bodySmallSemiBold.copyWith(
                  color: AppColors.orange950,
                ),
              ),

              // ── Spacer bawah ────────────────────────────────────────────
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
