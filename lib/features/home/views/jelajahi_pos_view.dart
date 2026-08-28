// =============================================================================
// jelajahi_pos_view.dart
// Halaman Jelajahi Pos — carousel 3 pos dengan navigasi arrow & content dinamis.
// Flow: Home → Jelajahi Pos (intro carousel) → pos detail (selanjutnya).
// Bottom navbar di-handle oleh MainShellView (shell route) — Beranda aktif.
// Layout: FrameAtas + Spacer(auto) + FrameBawah + 8px bottom.
// Status chip & button menyesuaikan progress user dari Supabase.
// Data pos & status mapping dipisahkan ke pos_data_model.dart.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/progress_provider.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_level_bar.dart';
import '../../../core/widgets/app_status_chip.dart';
import '../models/pos_data_model.dart';

// ─── View ────────────────────────────────────────────────────────────────────

class JelajahiPosView extends ConsumerStatefulWidget {
  const JelajahiPosView({super.key});

  @override
  ConsumerState<JelajahiPosView> createState() => _JelajahiPosViewState();
}

class _JelajahiPosViewState extends ConsumerState<JelajahiPosView> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    if (page < 0 || page >= posListData.length) return;
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
  }

  @override
  Widget build(BuildContext context) {
    final pos = posListData[_currentPage];
    final progressState = ref.watch(progressViewModelProvider);
    final posStatus = progressState.getStatus(pos.number);
    final uiConfig = getStatusUIConfig(posStatus, pos.number);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ════════════════════════════════════════════════════════════
          // FRAME ATAS
          // ════════════════════════════════════════════════════════════

          // ── Top Bar: Back Button + Info Pos ─────────────────────
          Row(
            children: [
              Expanded(
                child: Text(
                  'Pos ${pos.number} - ${pos.moduleName}',
                  style: AppTypography.titleLargeBold.copyWith(
                    color: AppColors.orange900,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              AppStatusChip(
                variant: uiConfig.chipVariant,
                label: uiConfig.chipLabel,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Title Frame ─────────────────────────────────────────
          Text(
            pos.title,
            style: AppTypography.displaySmallExtraBold.copyWith(
              color: AppColors.orange900,
            ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 48),

          // ── Carousel + Arrow Navigation ─────────────────────────
          SizedBox(
            height: 227,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => _goToPage(_currentPage - 1),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 24,
                    color: _currentPage == 0
                        ? AppColors.orange200
                        : AppColors.orange900,
                  ),
                ),
                const SizedBox(width: 0),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: posListData.length,
                    onPageChanged: _onPageChanged,
                    itemBuilder: (context, index) {
                      final item = posListData[index];
                      return Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: SvgPicture.asset(
                            item.imagePath,
                            width: 383,
                            height: 277,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 0),
                GestureDetector(
                  onTap: () => _goToPage(_currentPage + 1),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 24,
                    color: _currentPage == posListData.length - 1
                        ? AppColors.orange200
                        : AppColors.orange900,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // ── Pagination (Level Bar) ──────────────────────────────
          Center(
            child: AppLevelBar(
              activeSteps: _currentPage + 1,
              totalSteps: posListData.length,
              activeColor: AppColors.orange800,
              inactiveColor: AppColors.orange100,
              highlightCurrentOnly: true,
            ),
          ),

          // ══════════════════════════════════════════════════════════
          // SPACER — Auto gap antara FrameAtas & FrameBawah
          // ══════════════════════════════════════════════════════════
          const Spacer(),

          // ══════════════════════════════════════════════════════════
          // FRAME BAWAH — Tentang Pos
          // ══════════════════════════════════════════════════════════
          Text(
            'Tentang Pos',
            style: AppTypography.titleLargeBold.copyWith(
              color: AppColors.orange950,
            ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            decoration: BoxDecoration(
              color: AppColors.orange200,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              pos.description,
              style: AppTypography.bodyMediumRegular.copyWith(
                color: AppColors.orange950,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(height: 16),

          AppButton(
            label: uiConfig.buttonLabel,
            variant: uiConfig.buttonVariant,
            width: double.infinity,
            height: 64,
            onPressed: () {
              // ── Navigasi ke loading screen, lalu ke detail ────────
              context.go('${AppRoutes.jelajahiPos}/pos-loading/${pos.number}');
            },
          ),
        ],
      ),
    );
  }
}
