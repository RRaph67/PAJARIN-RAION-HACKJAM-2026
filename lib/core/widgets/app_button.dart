// =============================================================================
// app_button.dart
// Komponen button reusable untuk seluruh aplikasi.
// Variants: primary (green600) & secondary (green100 + outline).
// =============================================================================

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Variants button yang tersedia.
enum ButtonVariant { primary, secondary }

class AppButton extends StatelessWidget {
  /// Teks yang ditampilkan di button.
  final String label;

  /// Fungsi yang dipanggil saat button ditekan.
  final VoidCallback? onPressed;

  /// Lebar button. Default: 361.
  final double? width;

  /// Tinggi button. Default: 64.
  final double? height;

  /// Variants button: primary atau secondary.
  final ButtonVariant variant;

  /// Icon opsional di sebelah kiri teks.
  final IconData? icon;

  /// Menampilkan loading indicator menggantikan konten button.
  final bool isLoading;

  /// Meng-disable button.
  final bool enabled;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.width = 361,
    this.height = 64,
    this.variant = ButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = !enabled || isLoading;

    return SizedBox(
      width: width,
      height: height,
      child: variant == ButtonVariant.primary
          ? _buildPrimary(isDisabled)
          : _buildSecondary(isDisabled),
    );
  }

  // ─── Primary Button ──────────────────────────────────────────────────────
  // Background: green600 | Text: green50 | Rounded: 16
  // Disabled: background green300
  Widget _buildPrimary(bool isDisabled) {
    return ElevatedButton(
      onPressed: isDisabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isDisabled ? AppColors.green300 : AppColors.green600,
        foregroundColor: AppColors.green50,
        disabledBackgroundColor: AppColors.green300,
        disabledForegroundColor: AppColors.green50,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
      child: _buildChild(),
    );
  }

 // ─── Secondary Button ──────────────────────────────────────────────
  // Background: green100 | Text: green800 | Rounded: 16 | Tanpa Outline
  // Disabled: background green300
  Widget _buildSecondary(bool isDisabled) {
    return OutlinedButton(
      onPressed: isDisabled ? null : onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: isDisabled ? AppColors.green300 : AppColors.green200,
        foregroundColor: isDisabled ? AppColors.green50 : AppColors.green800,
        disabledBackgroundColor: AppColors.green300,
        disabledForegroundColor: AppColors.green50,
        side: BorderSide.none, // <-- INI YANG MEMBUAT OUTLINE/BORDER HILANG
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
      child: _buildChild(),
    );
  }

  // ─── Konten Button (Icon + Text / Loading) ───────────────────────────────
  Widget _buildChild() {
    if (isLoading) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.green50,
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      );
    }

    return Text(
      label,
      style: const TextStyle(
        fontFamily: 'Nunito',
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
