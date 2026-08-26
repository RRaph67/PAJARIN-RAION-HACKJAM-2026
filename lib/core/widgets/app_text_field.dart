// =============================================================================
// app_text_field.dart
// Komponen text input reusable untuk seluruh aplikasi.
// Variants: normal (dengan icon kiri) & password (icon kiri + mata toggle).
// =============================================================================

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class AppTextField extends StatefulWidget {
  /// Placeholder text yang ditampilkan saat input kosong.
  final String hintText;

  /// Controller untuk mengontrol nilai input.
  final TextEditingController? controller;

  /// Icon di sebelah kiri input (ukuran 24x24).
  final IconData? prefixIcon;

  /// Keyboard type (email, number, dll).
  final TextInputType? keyboardType;

  /// Fungsi validasi.
  final String? Function(String?)? validator;

  /// TextInputAction untuk keyboard (next, done, dll).
  final TextInputAction? textInputAction;

  /// Dipanggil saat user menekan tombol selesai di keyboard.
  final VoidCallback? onEditingComplete;

  /// Jika true, menggunakan password variant dengan toggle visibility.
  final bool isPassword;

  /// Lebar input. Default: 361.
  final double? width;

  /// Tinggi input. Default: 54.
  final double? height;

  /// Callback saat nilai input berubah.
  final ValueChanged<String>? onChanged;

  /// Text capitalization (words, sentences, dll).
  final TextCapitalization textCapitalization;

  /// Jika true, input tidak bisa diketik (untuk field pilihan/dropdown).
  final bool readOnly;

  /// Jika false, kursor tidak ditampilkan saat field di-tap.
  final bool showCursor;

  /// Dipanggil saat field di-tap (biasanya untuk membuka popup/dropdown).
  final VoidCallback? onTap;

  /// Widget tambahan di sisi kanan field (misal: icon keyboard_arrow_down).
  final Widget? trailing;

  const AppTextField({
    super.key,
    this.hintText = '',
    this.controller,
    this.prefixIcon,
    this.keyboardType,
    this.validator,
    this.textInputAction,
    this.onEditingComplete,
    this.isPassword = false,
    this.width = 361,
    this.height = 54,
    this.onChanged,
    this.textCapitalization = TextCapitalization.none,
    this.readOnly = false,
    this.showCursor = true,
    this.onTap,
    this.trailing,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    // Password variant defaultnya tersembunyi
    if (widget.isPassword) {
      _obscureText = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: TextFormField(
        controller: widget.controller,
        obscureText: _obscureText,
        keyboardType: widget.keyboardType,
        textCapitalization: widget.textCapitalization,
        validator: widget.validator,
        textInputAction: widget.textInputAction,
        onEditingComplete: widget.onEditingComplete,
        onChanged: widget.onChanged,
        readOnly: widget.readOnly,
        showCursor: widget.showCursor,
        onTap: widget.onTap,
        style: AppTypography.textTheme.labelMedium?.copyWith(
          color: AppColors.orange950,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: AppTypography.textTheme.labelMedium?.copyWith(
            color: AppColors.orange950.withValues(alpha: 0.6),
            fontSize: 14,
          ),
          // ── Prefix Icon ──────────────────────────────────────────────
          prefixIcon: widget.prefixIcon != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 16, right: 12),
                  child: Icon(
                    widget.prefixIcon,
                    size: 24,
                    color: AppColors.orange950,
                  ),
                )
              : null,
          prefixIconConstraints: widget.prefixIcon != null
              ? const BoxConstraints(minWidth: 0, minHeight: 0)
              : null,
          // ── Suffix Icon ───────────────────────────────────────────
          // Password variant → toggle mata; selain itu pakai trailing custom.
          suffixIcon: widget.isPassword
              ? Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _obscureText = !_obscureText);
                    },
                    child: Icon(
                      _obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 24,
                      color: AppColors.orange950,
                    ),
                  ),
                )
              : widget.trailing != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: widget.trailing,
                )
              : null,
          suffixIconConstraints: widget.isPassword || widget.trailing != null
              ? const BoxConstraints(minWidth: 0, minHeight: 0)
              : null,
          // ── Content Padding ──────────────────────────────────────────
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          // ── Border Styling ───────────────────────────────────────────
          filled: true,
          fillColor: AppColors.orange50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.orange800, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.orange800, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.orange800, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.error, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.error, width: 2),
          ),
        ),
      ),
    );
  }
}
