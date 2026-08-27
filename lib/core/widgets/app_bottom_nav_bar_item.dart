// =============================================================================
// app_bottom_nav_bar_item.dart
// Komponen reusable untuk item bottom navigation bar.
// Variant: active (bg orange500 + shadow + white icon/text)
//          inactive (tanpa bg/shadow, orange900 icon/text)
// =============================================================================

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class AppBottomNavBarItem extends StatelessWidget {
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const AppBottomNavBarItem({
    super.key,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 74,
        height: 53,
        decoration: BoxDecoration(
          color: isActive ? AppColors.orange500 : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: const Color(0xFFE9A201).withValues(alpha: 0.3),
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: Offset.zero,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? activeIcon : inactiveIcon,
              size: 24,
              color: isActive ? Colors.white : AppColors.orange900,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTypography.labelSmallSemiBold.copyWith(
                color: isActive ? Colors.white : AppColors.orange900,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
