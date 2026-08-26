// =============================================================================
// app_colors.dart
// Menyediakan seluruh skala token warna lengkap (Orange & Green shade 50-950)
// untuk RaionHackJam15 berdasarkan Design System.
// =============================================================================

import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // class ini tidak boleh diinstansiasi

  // ─── Orange Palette (Shade 50 - 950) ──────────────────────────────────────
  static const Color orange50 = Color(0xFFfdf6e6);
  static const Color orange100 = Color(0xFFf8e2b0);
  static const Color orange200 = Color(0xFFf5d48a);
  static const Color orange300 = Color(0xFFf0c155);
  static const Color orange400 = Color(0xFFedb534);
  static const Color orange500 = Color(0xFFe9a201);
  static const Color orange600 = Color(0xFFd49301);
  static const Color orange700 = Color(0xFFa57301);
  static const Color orange800 = Color(0xFF805901);
  static const Color orange900 = Color(0xFF624400);
  static const Color orange950 = Color(0xFF493000);

  // ─── Green Palette (Shade 50 - 950) ───────────────────────────────────────
  static const Color green50 = Color(0xFFf2f7f3);
  static const Color green100 = Color(0xFFdfece1);
  static const Color green200 = Color(0xFFc1d9c7);
  static const Color green300 = Color(0xFF9fc3aa);
  static const Color green400 = Color(0xFF6a9d7b);
  static const Color green500 = Color(0xFF49805d);
  static const Color green600 = Color(0xFF366548);
  static const Color green700 = Color(0xFF2b513b);
  static const Color green800 = Color(0xFF244130);
  static const Color green900 = Color(0xFF1e3629);
  static const Color green950 = Color(0xFF101e16);

  // ─── Alias Semantik Utama (Digunakan oleh ThemeData) ──────────────────────
  // Kamu bisa mengubah mapping di sini jika ingin mengubah tema utama aplikasi secara global
  static const Color primary = orange500;
  static const Color primaryLight = orange200;
  static const Color primaryDark = orange700;

  static const Color secondary = green500;
  static const Color secondaryLight = green100;
  static const Color secondaryDark = green700;

  static const Color background = green50;
  static const Color surface = Colors.white;
  static const Color surfaceVariant = green100;

  static const Color textPrimary = green950;
  static const Color textSecondary = green800;
  static const Color textDisabled = Color(0xFFBDBDBD);

  // ─── Semantic & Utility Colors ────────────────────────────────────────────
  static const Color success = green500;
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF2196F3);

  static const Color divider = green200;
  static const Color border = green300;
  static const Color shadow = Color(0x1A000000);
}
