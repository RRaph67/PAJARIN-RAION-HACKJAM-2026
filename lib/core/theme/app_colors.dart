// =============================================================================
// app_colors.dart
// Semua token warna untuk RaionHackJam15.
// File ini diisi oleh tim UI/UX setelah Design System di Figma selesai.
//
// Cara membaca hex di Flutter:
//   → 0xFF diikuti kode hex warna (tanpa tanda #)
//   → Contoh: warna #6C63FF  →  Color(0xFF6C63FF)
//   → Contoh: warna #F5F5F5  →  Color(0xFFF5F5F5)
// =============================================================================

import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // class ini tidak boleh diinstansiasi

  // ─── Warna Utama (Primary) ────────────────────────────────────────────────
  // Warna brand utama — digunakan pada tombol, ikon aktif, highlight.
  // [PLACEHOLDER] Ganti hex dengan warna primary dari Figma Design System
  static const Color primary      = Color(0xFF[PLACEHOLDER_PRIMARY_HEX]);
  static const Color primaryLight = Color(0xFF[PLACEHOLDER_PRIMARY_LIGHT_HEX]);
  static const Color primaryDark  = Color(0xFF[PLACEHOLDER_PRIMARY_DARK_HEX]);

  // ─── Warna Sekunder / Aksen (Secondary) ───────────────────────────────────
  // Warna pendukung — digunakan pada elemen aksen, chip, badge.
  // [PLACEHOLDER] Ganti hex dengan warna secondary dari Figma Design System
  static const Color secondary      = Color(0xFF[PLACEHOLDER_SECONDARY_HEX]);
  static const Color secondaryLight = Color(0xFF[PLACEHOLDER_SECONDARY_LIGHT_HEX]);

  // ─── Warna Netral / Permukaan (Neutral) ───────────────────────────────────
  // [PLACEHOLDER] Ganti hex dengan warna background dari Figma Design System
  static const Color background     = Color(0xFF[PLACEHOLDER_BACKGROUND_HEX]);
  static const Color surface        = Color(0xFFFFFFFF); // putih murni (kartu, modal)
  static const Color surfaceVariant = Color(0xFF[PLACEHOLDER_SURFACE_VARIANT_HEX]);

  // ─── Warna Teks ───────────────────────────────────────────────────────────
  // [PLACEHOLDER] Ganti hex dengan warna teks dari Figma Design System
  static const Color textPrimary   = Color(0xFF[PLACEHOLDER_TEXT_PRIMARY_HEX]);
  static const Color textSecondary = Color(0xFF[PLACEHOLDER_TEXT_SECONDARY_HEX]);
  static const Color textDisabled  = Color(0xFFBDBDBD); // abu-abu — teks nonaktif

  // ─── Warna Status (Semantic Colors) ──────────────────────────────────────
  // Warna-warna ini umumnya sudah cukup standar dan tidak perlu diganti.
  static const Color success = Color(0xFF4CAF50); // hijau — aksi berhasil
  static const Color warning = Color(0xFFFFC107); // kuning — peringatan
  static const Color error   = Color(0xFFE53935); // merah  — error / gagal
  static const Color info    = Color(0xFF2196F3); // biru   — informasi

  // ─── Warna Utilitas ───────────────────────────────────────────────────────
  static const Color divider = Color(0xFFE0E0E0); // garis pemisah antar elemen
  static const Color border  = Color(0xFFE0E0E0); // batas/outline komponen (input, kartu)
  static const Color shadow  = Color(0x1A000000); // bayangan (hitam 10% transparan)
}
