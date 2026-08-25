// =============================================================================
// app_theme.dart
// Pembangun ThemeData untuk RaionHackJam15.
// File ini hanya berisi konfigurasi widget-level (AppBar, Button, Input, dll).
//
// Token warna   → lihat: app_colors.dart
// Token font    → lihat: app_typography.dart
// =============================================================================

import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._(); // class ini tidak boleh diinstansiasi

  // ─── Light Theme ──────────────────────────────────────────────────────────
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,        // gunakan Material Design 3 (versi terbaru)
        brightness: Brightness.light,

        // ── Color Scheme ──────────────────────────────────────────────
        // Menghubungkan token warna dari AppColors ke sistem Material 3.
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          onPrimary: Colors.white,                    // teks/ikon di atas primary
          primaryContainer: AppColors.primaryLight,
          secondary: AppColors.secondary,
          onSecondary: Colors.white,
          secondaryContainer: AppColors.secondaryLight,
          surface: AppColors.surface,
          onSurface: AppColors.textPrimary,
          error: AppColors.error,
          onError: Colors.white,
        ),

        scaffoldBackgroundColor: AppColors.background,

        // Menghubungkan skala tipografi dari AppTypography
        textTheme: AppTypography.textTheme,

        // ── AppBar (bilah atas halaman) ────────────────────────────────
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,          // hilangkan bayangan bawaan AppBar
          centerTitle: true,     // judul selalu di tengah
          titleTextStyle: TextStyle(
            // [PLACEHOLDER] Ganti dengan AppTypography.textTheme.titleLarge
            // setelah font dikonfirmasi ke tim UI/UX
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),

        // ── ElevatedButton (tombol utama berisi warna) ─────────────────
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 52), // lebar penuh, tinggi 52dp
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),    // sudut membulat
            ),
            elevation: 0, // hilangkan bayangan tombol
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // ── OutlinedButton (tombol dengan garis tepi, tanpa isian warna) ─
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            side: const BorderSide(color: AppColors.primary, width: 1.5),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // ── TextField / InputDecoration (kolom input teks) ─────────────
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceVariant,         // warna latar belakang input
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,               // tanpa garis saat idle
          ),
          enabledBorder: OutlineInputBorder(           // saat input aktif tapi belum fokus
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border, width: 1),
          ),
          focusedBorder: OutlineInputBorder(           // saat sedang diketik
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(             // saat ada error validasi
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.error, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(      // saat error + sedang fokus
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.error, width: 1.5),
          ),
        ),

        // ── Divider (garis pemisah antar elemen) ───────────────────────
        dividerTheme: const DividerThemeData(
          color: AppColors.divider,
          thickness: 1,
          space: 1,
        ),
      );

  // [PLACEHOLDER] Tambahkan darkTheme di sini jika diperlukan oleh Design System
  // static ThemeData get darkTheme => ThemeData(
  //   useMaterial3: true,
  //   brightness: Brightness.dark,
  //   colorScheme: const ColorScheme.dark( ... ),
  //   ...
  // );
}
