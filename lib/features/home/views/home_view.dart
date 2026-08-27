// =============================================================================
// home_view.dart
// Halaman Beranda — tampilan pertama setelah login.
// Struktur:
//   FrameAtas  → TitleFrame (sapa user + judul) + MaskotFrame (oval shadow)
//   FrameBawah → ProgressionFrame (label + level bar)
//                + BelajarFrame (label + single Jelajahi Pos button)
// Bottom navbar di-handle oleh MainShellView (shell route).
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_progress_bar.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../viewmodels/home_viewmodel.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeViewModelProvider);
    final authState = ref.watch(authViewModelProvider);

    // Ambil nama user dari auth state
    final userName = authState.user?.name ?? 'User';

    // Hitung modul yang sudah selesai
    final completedCount = homeState.completedCount;
    final totalModules = homeState.totalModules;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ══════════════════════════════════════════════════════════════
          // FRAME ATAS — Sapa user + Mascot
          // ══════════════════════════════════════════════════════════════
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── TitleFrame ──────────────────────────────────────────
                Text(
                  'Halo, $userName!',
                  style: AppTypography.headlineSmallSemiBold.copyWith(
                    color: AppColors.orange900,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 4),

                Text(
                  'Mulai petualangan belajar\npajakmu hari ini!',
                  style: AppTypography.displaySmallExtraBold.copyWith(
                    color: AppColors.orange900,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 16),

                // ── MaskotFrame ─────────────────────────────────────────
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        bottom: 20,
                        child: ClipOval(
                          child: Container(
                            width: 117,
                            height: 24,
                            color: const Color(
                              0xFF493000,
                            ).withValues(alpha: 0.25),
                          ),
                        ),
                      ),
                      SvgPicture.asset(
                        'assets/svg/maskot_login.svg',
                        width: 360,
                        height: 333,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ══════════════════════════════════════════════════════════════
          // FRAME BAWAH — Progression + Jelajahi Pos
          // ══════════════════════════════════════════════════════════════
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── ProgressionFrame ────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progress Kamu',
                      style: AppTypography.titleLargeBold.copyWith(
                        color: AppColors.orange950,
                      ),
                    ),
                    Text(
                      '$completedCount Pos Sudah Selesai',
                      style: AppTypography.titleLargeExtraBold.copyWith(
                        color: AppColors.orange950,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                AppProgressBar(
                  progress: totalModules > 0
                      ? completedCount / totalModules
                      : 0.0,
                  width: double.infinity,
                  backgroundColor: AppColors.green200,
                  fillColor: AppColors.green600,
                ),
                const SizedBox(height: 32),

                // ── BelajarFrame ────────────────────────────────────────
                Text(
                  'Lanjut Belajar',
                  style: AppTypography.titleLargeBold.copyWith(
                    color: AppColors.orange950,
                  ),
                ),
                const SizedBox(height: 16),

                // ── Single Card Info ────────────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  decoration: BoxDecoration(
                    color: AppColors.orange200,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              'Modul Pajak',
                              style: AppTypography.titleLargeBold.copyWith(
                                color: AppColors.orange950,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Pelajari PPh 21, PTKP, dan SPT secara menyeluruh melalui 3 pos pembelajaran.',
                        style: AppTypography.bodyMediumRegular.copyWith(
                          color: AppColors.orange950,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // ── Button Jelajahi Post ────────────────────────────────
                AppButton(
                  label: 'Jelajahi Post',
                  icon: Icons.arrow_forward,
                  iconSize: 16,
                  iconColor: AppColors.green50,
                  iconPosition: IconPosition.right,
                  height: 44,
                  width: double.infinity,
                  onPressed: () {
                    context.go(AppRoutes.jelajahiPos);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
