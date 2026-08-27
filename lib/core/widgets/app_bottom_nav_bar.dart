// =============================================================================
// app_bottom_nav_bar.dart
// Komponen reusable bottom navigation bar dengan 3 menu:
// Beranda (home), Simulasi (calculate), Profile (account_circle).
// Wrapper utama: w393 h106, rounded top30, bg #FFFBF3, shadow.
// =============================================================================

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'app_bottom_nav_bar_item.dart';

enum AppBottomNavTab { beranda, simulasi, profile }

class AppBottomNavBar extends StatelessWidget {
  final AppBottomNavTab currentTab;
  final ValueChanged<AppBottomNavTab> onTabChanged;

  const AppBottomNavBar({
    super.key,
    required this.currentTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 106,
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBF3),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: AppColors.orange900.withValues(alpha: 0.2),
            blurRadius: 7,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Beranda ──────────────────────────────────────────────
          Expanded(
            child: AppBottomNavBarItem(
              activeIcon: Icons.home,
              inactiveIcon: Icons.home_outlined,
              label: 'Beranda',
              isActive: currentTab == AppBottomNavTab.beranda,
              onTap: () => onTabChanged(AppBottomNavTab.beranda),
            ),
          ),

          // ── Simulasi ─────────────────────────────────────────────
          Expanded(
            child: AppBottomNavBarItem(
              activeIcon: Icons.calculate,
              inactiveIcon: Icons.calculate_outlined,
              label: 'Simulasi',
              isActive: currentTab == AppBottomNavTab.simulasi,
              onTap: () => onTabChanged(AppBottomNavTab.simulasi),
            ),
          ),

          // ── Profile ──────────────────────────────────────────────
          Expanded(
            child: AppBottomNavBarItem(
              activeIcon: Icons.account_circle,
              inactiveIcon: Icons.account_circle_outlined,
              label: 'Profile',
              isActive: currentTab == AppBottomNavTab.profile,
              onTap: () => onTabChanged(AppBottomNavTab.profile),
            ),
          ),
        ],
      ),
    );
  }
}
