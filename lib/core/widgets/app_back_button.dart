// =============================================================================
// app_back_button.dart
// Komponen tombol kembali reusable untuk seluruh aplikasi.
// Styling: 48x48, bg green600, rounded 16, icon arrow_back white.
// =============================================================================

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppBackButton extends StatelessWidget {
  /// Callback saat tombol ditekan.
  final VoidCallback? onPressed;

  /// Warna latar belakang. Default: AppColors.green600.
  final Color backgroundColor;

  /// Warna ikon. Default: AppColors.green50.
  final Color iconColor;

  const AppBackButton({
    super.key,
    this.onPressed,
    this.backgroundColor = AppColors.green600,
    this.iconColor = AppColors.green50,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.arrow_back, size: 24, color: iconColor),
      ),
    );
  }
}
