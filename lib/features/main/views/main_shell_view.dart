// =============================================================================
// main_shell_view.dart
// Shell view utama yang membungkus halaman dengan bottom navigation bar.
// Menggunakan StatefulNavigationShell dari GoRouter StatefulShellRoute
// untuk mempertahankan state per tab (tidak rebuild saat berpindah tab).
// =============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';

class MainShellView extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShellView({super.key, required this.navigationShell});

  /// Konversi index GoRouter → AppBottomNavTab
  AppBottomNavTab get _currentTab {
    switch (navigationShell.currentIndex) {
      case 0:
        return AppBottomNavTab.beranda;
      case 1:
        return AppBottomNavTab.simulasi;
      case 2:
        return AppBottomNavTab.profile;
      default:
        return AppBottomNavTab.beranda;
    }
  }

  /// Navigasi ke tab yang dipilih
  void _onTabChanged(AppBottomNavTab tab) {
    int index;
    switch (tab) {
      case AppBottomNavTab.beranda:
        index = 0;
        break;
      case AppBottomNavTab.simulasi:
        index = 1;
        break;
      case AppBottomNavTab.profile:
        index = 2;
        break;
    }
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.orange50,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Konten halaman aktif (managed oleh StatefulShellRoute) ──
            Expanded(child: navigationShell),

            // ── Bottom Navigation Bar ─────────────────────────────────
            AppBottomNavBar(
              currentTab: _currentTab,
              onTabChanged: _onTabChanged,
            ),
          ],
        ),
      ),
    );
  }
}
