// =============================================================================
// app_status_chip.dart
// Komponen reusable status chip dengan 4 variant untuk menandakan
// status user terhadap sebuah konten (pos/artikel):
//   - light:     Belum Dipelajari (orange-50 bg)
//   - primary:   Sudah Dipelajari (green-500 bg)
//   - secondary: Belum Dipelajari (orange-200 bg)
//   - third:     Sedang Dipelajari (green-200 bg)
// =============================================================================

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

enum StatusChipVariant { light, primary, secondary, third }

class AppStatusChip extends StatelessWidget {
  /// Variant chip yang menentukan warna bg & teks
  final StatusChipVariant variant;

  /// Teks label — jika null, menggunakan default label per variant
  final String? label;

  /// LebarOpsional override (default: hug content / w 110 max)
  final double? width;

  const AppStatusChip({
    super.key,
    required this.variant,
    this.label,
    this.width,
  });

  /// Default label untuk setiap variant
  String get _defaultLabel {
    switch (variant) {
      case StatusChipVariant.light:
        return 'Belum Dipelajari';
      case StatusChipVariant.primary:
        return 'Sudah Dipelajari';
      case StatusChipVariant.secondary:
        return 'Belum Dipelajari';
      case StatusChipVariant.third:
        return 'Sedang Dipelajari';
    }
  }

  /// Background color per variant
  Color get _backgroundColor {
    switch (variant) {
      case StatusChipVariant.light:
        return AppColors.orange50;
      case StatusChipVariant.primary:
        return AppColors.green500;
      case StatusChipVariant.secondary:
        return AppColors.orange200;
      case StatusChipVariant.third:
        return AppColors.green200;
    }
  }

  /// Text color per variant
  Color get _textColor {
    switch (variant) {
      case StatusChipVariant.light:
        return AppColors.orange900;
      case StatusChipVariant.primary:
        return AppColors.green50;
      case StatusChipVariant.secondary:
        return AppColors.orange900;
      case StatusChipVariant.third:
        return AppColors.green800;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label ?? _defaultLabel,
        style: AppTypography.bodyMediumMedium.copyWith(color: _textColor),
        textAlign: TextAlign.center,
      ),
    );
  }
}
