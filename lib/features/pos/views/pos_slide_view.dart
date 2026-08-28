// =============================================================================
// pos_slide_view.dart
// Halaman detail pos dengan sistem slide (PageView).
// Menerima posId, load slides dari mock data, navigasi via swipe/tombol.
// Auto-update status progress ke Supabase saat pertama masuk.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_level_bar.dart';
import '../../home/models/pos_data_model.dart';
import '../viewmodels/pos_slide_viewmodel.dart';

// ─── View ────────────────────────────────────────────────────────────────────

class PosSlideView extends ConsumerStatefulWidget {
  final int posId;

  const PosSlideView({super.key, required this.posId});

  @override
  ConsumerState<PosSlideView> createState() => _PosSlideViewState();
}

class _PosSlideViewState extends ConsumerState<PosSlideView> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // ── Tunda widget init ke frame berikutnya ──────────────────────────
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startPosIfNeeded();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Mulai pos (set status ke inProgress jika belum)
  void _startPosIfNeeded() {
    ref
        .read(
          posSlideViewModelProvider((
            posId: widget.posId,
            slides: getSlidesForPos(widget.posId),
          )).notifier,
        )
        .startPosIfNeeded();
  }

  /// Tap tombol selanjutnya → pindah slide / selesaikan pos
  void _onNextTap(PosSlideState slideState) {
    if (slideState.isLastSlide) {
      // ── Slide terakhir → selesaikan pos ────────────────────────────
      _completePos();
    } else {
      // ── Update state ViewModel ─────────────────────────────────────
      ref
          .read(
            posSlideViewModelProvider((
              posId: widget.posId,
              slides: getSlidesForPos(widget.posId),
            )).notifier,
          )
          .nextSlide();

      // ── Pindah ke slide berikutnya via PageController ───────────────
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Selesaikan pos dan kembali ke jelajahi pos
  Future<void> _completePos() async {
    final notifier = ref.read(
      posSlideViewModelProvider((
        posId: widget.posId,
        slides: getSlidesForPos(widget.posId),
      )).notifier,
    );

    final success = await notifier.completePos();

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pos ${widget.posId} selesai! 🎉'),
          backgroundColor: AppColors.green600,
        ),
      );
    }

    // ── Kembali ke jelajahi pos ──────────────────────────────────────
    context.go(AppRoutes.jelajahiPos);
  }

  @override
  Widget build(BuildContext context) {
    final slides = getSlidesForPos(widget.posId);
    final posData = posListData.firstWhere(
      (p) => p.number == widget.posId,
      orElse: () => posListData.first,
    );

    final slideState = ref.watch(
      posSlideViewModelProvider((posId: widget.posId, slides: slides)),
    );

    return Scaffold(
      backgroundColor: AppColors.orange50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top Bar ─────────────────────────────────────────
              Row(
                children: [
                  AppBackButton(
                    onPressed: () => context.go(AppRoutes.jelajahiPos),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Pos ${widget.posId} - ${posData.moduleName}',
                      style: AppTypography.titleMediumBold.copyWith(
                        color: AppColors.orange900,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── Progression Bar (level bar) ──────────────────────
              Row(
                children: [
                  Expanded(
                    child: AppLevelBar(
                      activeSteps: slideState.displaySlideNumber,
                      totalSteps: slideState.totalSteps,
                      activeColor: AppColors.orange800,
                      inactiveColor: AppColors.orange100,
                      highlightCurrentOnly: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${slideState.displaySlideNumber}/${slideState.totalSteps}',
                    style: AppTypography.bodySmallBold.copyWith(
                      color: AppColors.orange900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ── Slide Content (PageView) ────────────────────────
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: slides.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final slide = slides[index];
                    return _buildSlideContent(slide);
                  },
                ),
              ),
              const SizedBox(height: 16),

              // ── Bottom Navigation ───────────────────────────────
              _buildBottomNav(slideState),
            ],
          ),
        ),
      ),
    );
  }

  /// Build konten satu slide (fallback untuk tipe info/summary)
  Widget _buildSlideContent(PosSlide slide) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image Placeholder ────────────────────────────────────
          if (slide.imagePath != null)
            Center(
              child: Container(
                width: 361,
                height: 280,
                decoration: BoxDecoration(
                  color: AppColors.orange100,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    slide.imagePath!,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(
                          Icons.image_outlined,
                          size: 64,
                          color: AppColors.orange300,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          const SizedBox(height: 24),

          // ── Title ───────────────────────────────────────────────
          Text(
            slide.title,
            style: AppTypography.titleLargeBold.copyWith(
              color: AppColors.orange900,
            ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 12),

          // ── Body ────────────────────────────────────────────────
          if (slide.body != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.orange200,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                slide.body!,
                style: AppTypography.bodyMediumRegular.copyWith(
                  color: AppColors.orange950,
                  height: 1.5,
                ),
                textAlign: TextAlign.left,
              ),
            ),
        ],
      ),
    );
  }

  /// Build navigasi bawah (tombol Selanjutnya / Selesai)
  Widget _buildBottomNav(PosSlideState slideState) {
    final isLast = slideState.isLastSlide;

    return AppButton(
      label: isLast ? 'Selesai & Tandai Dipelajari' : 'Selanjutnya',
      variant: isLast ? ButtonVariant.secondary : ButtonVariant.primary,
      width: double.infinity,
      height: 64,
      icon: isLast ? Icons.check_circle_outline : Icons.arrow_forward,
      iconColor: isLast ? AppColors.green800 : AppColors.green50,
      onPressed: () => _onNextTap(slideState),
    );
  }
}
