// =============================================================================
// app_typography.dart
// Semua konfigurasi tipografi (font & skala teks) untuk RaionHackJam15.
// File ini diisi setelah tim UI/UX mengkonfirmasi nama font yang digunakan.
//
// Cara pakai:
//   Text('Halo', style: Theme.of(context).textTheme.titleLarge)
// =============================================================================

import 'package:flutter/material.dart';

class AppTypography {
  AppTypography._(); // class ini tidak boleh diinstansiasi

  // ─── Font Family ──────────────────────────────────────────────────────────
  // [PLACEHOLDER] Ganti dengan nama font dari Design System (konfirmasi ke UI/UX).
  // Contoh: 'Poppins', 'Inter', 'Outfit', 'Nunito', 'Roboto'
  //
  // Jika menggunakan Google Fonts, tambahkan package `google_fonts` ke pubspec.yaml
  // dan ganti pendekatan ini dengan GoogleFonts.interTextTheme() atau sejenisnya.
  //
  // Jika menggunakan font kustom (.ttf), daftarkan fontnya di pubspec.yaml terlebih dulu.
  static const String fontFamily = '[PLACEHOLDER_FONT_FAMILY]'; // contoh: 'Inter'

  // ─── TextTheme (Skala Tipografi Material 3) ────────────────────────────────
  // Referensi hierarki teks Material 3:
  //   Display  → teks hero, angka besar, heading layar penuh
  //   Headline → judul halaman / section besar
  //   Title    → judul kartu / komponen / dialog
  //   Body     → konten paragraf / deskripsi
  //   Label    → teks tombol, chip, caption kecil
  static TextTheme get textTheme => const TextTheme(

        // ── Display ───────────────────────────────────────────────────
        // Ukuran sangat besar, biasanya hanya untuk halaman hero/landing.
        displayLarge: TextStyle(
          fontFamily: fontFamily,
          fontSize: 57,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.25,
        ),
        displayMedium: TextStyle(
          fontFamily: fontFamily,
          fontSize: 45,
          fontWeight: FontWeight.w400,
        ),
        displaySmall: TextStyle(
          fontFamily: fontFamily,
          fontSize: 36,
          fontWeight: FontWeight.w400,
        ),

        // ── Headline (Judul Halaman / Section Besar) ──────────────────
        headlineLarge: TextStyle(
          fontFamily: fontFamily,
          fontSize: 32,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: TextStyle(
          fontFamily: fontFamily,
          fontSize: 28,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          fontFamily: fontFamily,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),

        // ── Title (Judul Kartu / Komponen / Dialog) ───────────────────
        titleLarge: TextStyle(
          fontFamily: fontFamily,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          fontFamily: fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
        ),
        titleSmall: TextStyle(
          fontFamily: fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),

        // ── Body (Konten / Paragraf / Deskripsi) ──────────────────────
        bodyLarge: TextStyle(
          fontFamily: fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
        ),
        bodyMedium: TextStyle(
          fontFamily: fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
        ),
        bodySmall: TextStyle(
          fontFamily: fontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
        ),

        // ── Label (Tombol / Chip / Caption Kecil) ─────────────────────
        labelLarge: TextStyle(
          fontFamily: fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
        labelMedium: TextStyle(
          fontFamily: fontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        labelSmall: TextStyle(
          fontFamily: fontFamily,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      );
}
