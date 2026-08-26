// =============================================================================
// app_typography.dart
// Skala tipografi menggunakan font Nunito untuk RaionHackJam15.
// Tersedia: Regular (400), Medium (500), SemiBold (600), Bold (700), ExtraBold (800)
// =============================================================================

import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  static const String fontFamily = 'Nunito';

  // ─── TextStyle Helpers ──────────────────────────────────────────────────
  // Fungsi helper untuk membuat TextStyle dengan warna yang bisa di-override.

  /// Regular — weight 400
  static TextStyle _regular(double size, [Color? color]) => TextStyle(
    fontFamily: fontFamily,
    fontSize: size,
    fontWeight: FontWeight.w400,
    color: color ?? AppColors.textPrimary,
  );

  /// Medium — weight 500
  static TextStyle _medium(double size, [Color? color]) => TextStyle(
    fontFamily: fontFamily,
    fontSize: size,
    fontWeight: FontWeight.w500,
    color: color ?? AppColors.textPrimary,
  );

  /// SemiBold — weight 600
  static TextStyle _semiBold(double size, [Color? color]) => TextStyle(
    fontFamily: fontFamily,
    fontSize: size,
    fontWeight: FontWeight.w600,
    color: color ?? AppColors.textPrimary,
  );

  /// Bold — weight 700
  static TextStyle _bold(double size, [Color? color]) => TextStyle(
    fontFamily: fontFamily,
    fontSize: size,
    fontWeight: FontWeight.w700,
    color: color ?? AppColors.textPrimary,
  );

  /// ExtraBold — weight 800
  static TextStyle _extraBold(double size, [Color? color]) => TextStyle(
    fontFamily: fontFamily,
    fontSize: size,
    fontWeight: FontWeight.w800,
    color: color ?? AppColors.textPrimary,
  );

  // ─── Display (Untuk judul sangat besar) ─────────────────────────────────
  static TextStyle get displayLargeExtraBold => _extraBold(32);
  static TextStyle get displayLargeBold => _bold(32);
  static TextStyle get displayLargeSemiBold => _semiBold(32);
  static TextStyle get displayLargeMedium => _medium(32);
  static TextStyle get displayLargeRegular => _regular(32);

  static TextStyle get displayMediumExtraBold => _extraBold(28);
  static TextStyle get displayMediumBold => _bold(28);
  static TextStyle get displayMediumSemiBold => _semiBold(28);
  static TextStyle get displayMediumMedium => _medium(28);
  static TextStyle get displayMediumRegular => _regular(28);

  static TextStyle get displaySmallExtraBold => _extraBold(24);
  static TextStyle get displaySmallBold => _bold(24);
  static TextStyle get displaySmallSemiBold => _semiBold(24);
  static TextStyle get displaySmallMedium => _medium(24);
  static TextStyle get displaySmallRegular => _regular(24);

  // ─── Headline (Untuk judul bagian) ──────────────────────────────────────
  static TextStyle get headlineLargeExtraBold => _extraBold(22);
  static TextStyle get headlineLargeBold => _bold(22);
  static TextStyle get headlineLargeSemiBold => _semiBold(22);
  static TextStyle get headlineLargeMedium => _medium(22);
  static TextStyle get headlineLargeRegular => _regular(22);

  static TextStyle get headlineMediumExtraBold => _extraBold(20);
  static TextStyle get headlineMediumBold => _bold(20);
  static TextStyle get headlineMediumSemiBold => _semiBold(20);
  static TextStyle get headlineMediumMedium => _medium(20);
  static TextStyle get headlineMediumRegular => _regular(20);

  static TextStyle get headlineSmallExtraBold => _extraBold(18);
  static TextStyle get headlineSmallBold => _bold(18);
  static TextStyle get headlineSmallSemiBold => _semiBold(18);
  static TextStyle get headlineSmallMedium => _medium(18);
  static TextStyle get headlineSmallRegular => _regular(18);

  // ─── Title (Untuk judul komponen/card) ──────────────────────────────────
  static TextStyle get titleLargeExtraBold => _extraBold(18);
  static TextStyle get titleLargeBold => _bold(18);
  static TextStyle get titleLargeSemiBold => _semiBold(18);
  static TextStyle get titleLargeMedium => _medium(18);
  static TextStyle get titleLargeRegular => _regular(18);

  static TextStyle get titleMediumExtraBold => _extraBold(16);
  static TextStyle get titleMediumBold => _bold(16);
  static TextStyle get titleMediumSemiBold => _semiBold(16);
  static TextStyle get titleMediumMedium => _medium(16);
  static TextStyle get titleMediumRegular => _regular(16);

  static TextStyle get titleSmallExtraBold => _extraBold(14);
  static TextStyle get titleSmallBold => _bold(14);
  static TextStyle get titleSmallSemiBold => _semiBold(14);
  static TextStyle get titleSmallMedium => _medium(14);
  static TextStyle get titleSmallRegular => _regular(14);

  // ─── Body (Untuk teks konten utama) ─────────────────────────────────────
  static TextStyle get bodyLargeExtraBold => _extraBold(16);
  static TextStyle get bodyLargeBold => _bold(16);
  static TextStyle get bodyLargeSemiBold => _semiBold(16);
  static TextStyle get bodyLargeMedium => _medium(16);
  static TextStyle get bodyLargeRegular => _regular(16);

  static TextStyle get bodyMediumExtraBold =>
      _extraBold(14, AppColors.textSecondary);
  static TextStyle get bodyMediumBold => _bold(14, AppColors.textSecondary);
  static TextStyle get bodyMediumSemiBold =>
      _semiBold(14, AppColors.textSecondary);
  static TextStyle get bodyMediumMedium => _medium(14, AppColors.textSecondary);
  static TextStyle get bodyMediumRegular =>
      _regular(14, AppColors.textSecondary);

  static TextStyle get bodySmallExtraBold =>
      _extraBold(12, AppColors.textSecondary);
  static TextStyle get bodySmallBold => _bold(12, AppColors.textSecondary);
  static TextStyle get bodySmallSemiBold =>
      _semiBold(12, AppColors.textSecondary);
  static TextStyle get bodySmallMedium => _medium(12, AppColors.textSecondary);
  static TextStyle get bodySmallRegular =>
      _regular(12, AppColors.textSecondary);

  // ─── Label (Untuk tombol, badge, caption) ───────────────────────────────
  static TextStyle get labelLargeExtraBold => _extraBold(16, Colors.white);
  static TextStyle get labelLargeBold => _bold(16, Colors.white);
  static TextStyle get labelLargeSemiBold => _semiBold(16, Colors.white);
  static TextStyle get labelLargeMedium => _medium(16, Colors.white);
  static TextStyle get labelLargeRegular => _regular(16, Colors.white);

  static TextStyle get labelMediumExtraBold => _extraBold(14, Colors.white);
  static TextStyle get labelMediumBold => _bold(14, Colors.white);
  static TextStyle get labelMediumSemiBold => _semiBold(14, Colors.white);
  static TextStyle get labelMediumMedium => _medium(14, Colors.white);
  static TextStyle get labelMediumRegular => _regular(14, Colors.white);

  static TextStyle get labelSmallExtraBold => _extraBold(12, Colors.white);
  static TextStyle get labelSmallBold => _bold(12, Colors.white);
  static TextStyle get labelSmallSemiBold => _semiBold(12, Colors.white);
  static TextStyle get labelSmallMedium => _medium(12, Colors.white);
  static TextStyle get labelSmallRegular => _regular(12, Colors.white);

  // ─── TextTheme (Default Material Theme) ─────────────────────────────────
  // Digunakan oleh Theme.of(context).textTheme
  static TextTheme get textTheme => TextTheme(
    // Display
    displayLarge: _extraBold(32),
    displayMedium: _extraBold(28),
    displaySmall: _bold(24),
    // Headline
    headlineLarge: _bold(22),
    headlineMedium: _bold(20),
    headlineSmall: _semiBold(18),
    // Title
    titleLarge: _bold(18),
    titleMedium: _semiBold(16),
    titleSmall: _semiBold(14),
    // Body
    bodyLarge: _regular(16),
    bodyMedium: _regular(14, AppColors.textSecondary),
    bodySmall: _regular(12, AppColors.textSecondary),
    // Label
    labelLarge: _bold(16, Colors.white),
    labelMedium: _bold(14, Colors.white),
    labelSmall: _semiBold(12, Colors.white),
  );
}
