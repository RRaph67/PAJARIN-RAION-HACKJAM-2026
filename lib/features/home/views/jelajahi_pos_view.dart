// =============================================================================
// jelajahi_pos_view.dart
// Halaman Jelajahi Pos — carousel 3 pos dengan navigasi arrow & content dinamis.
// Flow: Home → Jelajahi Pos (intro carousel) → pos detail (selanjutnya).
// Bottom navbar di-handle oleh MainShellView (shell route) — Beranda aktif.
// Layout: FrameAtas + Spacer(auto) + FrameBawah + 8px bottom.
// Status chip & button menyesuaikan progress user dari Supabase.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/pos_progress_model.dart';
import '../../../core/providers/progress_provider.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_level_bar.dart';
import '../../../core/widgets/app_status_chip.dart';

// ─── Data Model untuk setiap Pos ─────────────────────────────────────────────

class _PosData {
  final int number;
  final String moduleName;
  final String title;
  final String description;
  final String imagePath;

  const _PosData({
    required this.number,
    required this.moduleName,
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

const List<_PosData> _posList = [
  _PosData(
    number: 1,
    moduleName: 'Modul PPh 21',
    title: 'Lah, Pajak Ini Jadi Urusanku Sekarang?',
    description:
        'Pajak Penghasilan Pasal 21 adalah pemotongan pajak atas penghasilan '
        'yang diterima oleh pegawai, baik negeri maupun swasta. Di pos ini, '
        'kamu akan memahami apa itu PPh 21, siapa yang wajib memotong, '
        'serta cara menghitungnya dari dasar hingga praktik.',
    imagePath: 'assets/svg/maskot_mikir.svg',
  ),
  _PosData(
    number: 2,
    moduleName: 'Modul PTKP',
    title: 'Gaji Kita Sama, Tapi Potongannya Beda. Kok Bisa?',
    description:
        'Penghasilan Tidak Kena Pajak (PTKP) menentukan berapa besar '
        'potongan pajak dari gaji kita. Semakin banyak tanggungan, semakin '
        'besar PTKP, dan semakin kecil pajak yang harus dibayar. '
        'Yuk pahami cara menentukan PTKP yang benar!',
    imagePath: 'assets/svg/maskot_takut.svg',
  ),
  _PosData(
    number: 3,
    moduleName: 'Modul SPT',
    title: 'Ah Iya, Belum Bayar Pajak! Tapi Gimana Cara Hitungnya?',
    description:
        'SPT Tahunan PPh Orang Pribadi adalah laporan pajak tahunan yang '
        'wajib disetorkan. Di pos terakhir ini, kamu akan belajar '
        'cara mengisi SPT dari awal hingga akhir, termasuk memanfaatkan '
        'kredit pajak dan memahami batas waktu pelaporan.',
    imagePath: 'assets/svg/maskot_curiga.svg',
  ),
];

// ─── Mapping Status → UI Config ──────────────────────────────────────────────

class _StatusUIConfig {
  final StatusChipVariant chipVariant;
  final String chipLabel;
  final String buttonLabel;
  final ButtonVariant buttonVariant;

  const _StatusUIConfig({
    required this.chipVariant,
    required this.chipLabel,
    required this.buttonLabel,
    required this.buttonVariant,
  });
}

_StatusUIConfig _getStatusUI(PosProgressStatus status, int posNumber) {
  switch (status) {
    case PosProgressStatus.notStarted:
      return _StatusUIConfig(
        chipVariant: StatusChipVariant.secondary,
        chipLabel: 'Belum Dipelajari',
        buttonLabel: 'Masuk ke Pos $posNumber',
        buttonVariant: ButtonVariant.primary,
      );
    case PosProgressStatus.inProgress:
      return _StatusUIConfig(
        chipVariant: StatusChipVariant.third,
        chipLabel: 'Sedang Dipelajari',
        buttonLabel: 'Lanjutkan Pos $posNumber',
        buttonVariant: ButtonVariant.primary,
      );
    case PosProgressStatus.completed:
      return _StatusUIConfig(
        chipVariant: StatusChipVariant.primary,
        chipLabel: 'Sudah Dipelajari',
        buttonLabel: 'Mainkan Ulang Pos $posNumber',
        buttonVariant: ButtonVariant.secondary,
      );
  }
}

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
    if (page < 0 || page >= _posList.length) return;
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
    final pos = _posList[_currentPage];
    final progressState = ref.watch(progressViewModelProvider);
    final posStatus = progressState.getStatus(pos.number);
    final uiConfig = _getStatusUI(posStatus, pos.number);

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
              // Status chip dinamis berdasarkan progress
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
          const SizedBox(height: 20),

          // ── Carousel + Arrow Navigation ─────────────────────────
          SizedBox(
            height: 227,
            child: Row(
              children: [
                // Arrow Back
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
                const SizedBox(width: 8),

                // Image Carousel
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _posList.length,
                    onPageChanged: _onPageChanged,
                    itemBuilder: (context, index) {
                      final item = _posList[index];
                      return Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: SvgPicture.asset(
                            item.imagePath,
                            width: 313,
                            height: 227,
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),

                // Arrow Next
                GestureDetector(
                  onTap: () => _goToPage(_currentPage + 1),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 24,
                    color: _currentPage == _posList.length - 1
                        ? AppColors.orange200
                        : AppColors.orange900,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── Pagination (Level Bar) ──────────────────────────────
         Center(
            child: AppLevelBar(
              activeSteps: _currentPage + 1,
              totalSteps: _posList.length,
              activeColor: AppColors.orange800,
              inactiveColor: AppColors.orange100,
              highlightCurrentOnly: true, // <-- INI KUNCINYA
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

          // ── Description Wrapper ──────────────────────────────────
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

          // ── Button dinamis berdasarkan progress ─────────────────
          AppButton(
            label: uiConfig.buttonLabel,
            variant: uiConfig.buttonVariant,
            width: double.infinity,
            height: 64,
            onPressed: () {
              // Navigate ke pos detail
              context.go('${AppRoutes.jelajahiPos}/pos/${pos.number}');
            },
          ),
        ],
      ),
    );
  }
}
