// =============================================================================
// app_radio_option.dart
// Komponen radio button reusable dengan styling mirip AppTextField.
// Variant:
//   - inactive: bg orange50 (default)
//   - active  : bg orange100 (saat terpilih)
// Radio indicator & teks berwarna orange950.
// =============================================================================

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class AppRadioOption extends StatelessWidget {
  /// Teks label yang ditampilkan.
  final String label;

  /// Apakah opsi ini sedang terpilih.
  final bool selected;

  /// Dipanggil saat opsi di-tap.
  final VoidCallback onTap;

  /// Tinggi komponen. Default: 54.
  final double height;

  const AppRadioOption({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.height = 54,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          // Active → orange100, Inactive → orange50
          color: selected ? AppColors.orange100 : AppColors.orange50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.orange800, width: 2),
        ),
        child: Row(
          children: [
            // ── Radio Indicator ─────────────────────────────────────────
            _RadioIndicator(selected: selected),
            const SizedBox(width: 12),
            // ── Label ───────────────────────────────────────────────────
            Expanded(
              child: Text(
                label,
                style: AppTypography.bodyMediumMedium.copyWith(
                  color: AppColors.orange950,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// _RadioIndicator — lingkaran radio (outer ring + inner dot saat selected)
// =============================================================================
class _RadioIndicator extends StatelessWidget {
  final bool selected;

  const _RadioIndicator({required this.selected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? AppColors.orange950 : Colors.transparent,
        border: Border.all(color: AppColors.orange950, width: 2),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.orange50,
                ),
              ),
            )
          : null,
    );
  }
}
