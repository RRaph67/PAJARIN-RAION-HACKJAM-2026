// =============================================================================
// pos_detail_view.dart
// Halaman detail pos dengan multi-type slide (chat, info, quiz, summary).
// Top bar & bottom button shared — konten slide di-build sesuai SlideType.
// Auto-update status progress ke Supabase.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/pos_progress_model.dart';
import '../../../core/providers/progress_provider.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_progress_bar.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../../home/models/pos_data_model.dart';
import 'slides/calculation_steps_slide.dart';
import 'slides/chat_slide.dart';
import 'slides/completion_slide.dart';
import 'slides/grid_cards_slide.dart';
import 'slides/info_slide.dart';
import 'slides/payslip_comparison_slide.dart';
import 'slides/payslip_slide.dart';
import 'slides/ptkp_info_slide.dart';
import 'slides/ptkp_simulation_slide.dart';
import 'slides/quiz_slide.dart' as quiz;
import 'slides/reason_cards_slide.dart';
import 'slides/summary_slide.dart';
import 'slides/tariff_layers_slide.dart';
import 'slides/ter_reconciliation_slide.dart';
import 'slides/terminology_slide.dart';

// ─── View ────────────────────────────────────────────────────────────────────

class PosDetailView extends ConsumerStatefulWidget {
  final int posId;
  final int initialSlide;

  const PosDetailView({super.key, required this.posId, this.initialSlide = 0});

  @override
  ConsumerState<PosDetailView> createState() => _PosDetailViewState();
}

class _PosDetailViewState extends ConsumerState<PosDetailView> {
  late int _currentSlide;
  bool _isUpdating = false;

  // ── Quiz state ────────────────────────────────────────────────────────
  String? _selectedQuizOption;
  bool _quizSubmitted = false;

  // ── Completion slide state ─────────────────────────────────────────────
  bool _completionShowPart2 = false;

  @override
  void initState() {
    super.initState();
    _currentSlide = widget.initialSlide;
  }

  // ── Computed getters ──────────────────────────────────────────────────

  List<PosSlide> get _slides => getSlidesForPos(widget.posId);
  int get _totalScenes => _slides.length;
  double get _progress =>
      _totalScenes > 0 ? (_currentSlide + 1) / _totalScenes : 0.0;
  PosSlide get _currentSlideData => _slides[_currentSlide];
  bool get _isLastScene => _currentSlide >= _totalScenes - 1;

  // ── Navigation ────────────────────────────────────────────────────────

  void _onNextTap() {
    // Reset quiz state saat pindah slide
    setState(() {
      _selectedQuizOption = null;
      _quizSubmitted = false;
    });

    if (_isLastScene) {
      _completePos();
    } else {
      setState(() => _currentSlide++);
    }
  }

  void _onBackTap() {
    // Jika slide completion dan Part 2, kembali ke Part 1
    if (_currentSlideData.type == SlideType.completion &&
        _completionShowPart2) {
      setState(() => _completionShowPart2 = false);
      return;
    }
    // Jika di slide pertama, kembali ke jelajahi pos
    if (_currentSlide == 0) {
      _saveProgress();
      context.go(AppRoutes.jelajahiPos);
      return;
    }
    // Slide lainnya, kembali 1 slide
    setState(() {
      _selectedQuizOption = null;
      _quizSubmitted = false;
      _currentSlide--;
    });
  }

  // ── Quiz handlers ────────────────────────────────────────────────────

  void _onQuizOptionTap(String label, bool isCorrect) {
    if (_quizSubmitted) return;

    setState(() {
      _selectedQuizOption = label;
      _quizSubmitted = true;
    });

    if (isCorrect) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) _onNextTap();
      });
    } else {
      quiz.showWrongAnswerPopup(context: context, onRetry: _onQuizRetry);
    }
  }

  void _onQuizRetry() {
    setState(() {
      _selectedQuizOption = null;
      _quizSubmitted = false;
    });
  }

  // ── Supabase ──────────────────────────────────────────────────────────

  Future<void> _saveProgress() async {
    ref
        .read(progressViewModelProvider.notifier)
        .updatePosProgress(widget.posId, PosProgressStatus.inProgress);
  }

  Future<void> _completePos() async {
    if (_isUpdating) return;
    setState(() => _isUpdating = true);

    final success = await ref
        .read(progressViewModelProvider.notifier)
        .updatePosProgress(widget.posId, PosProgressStatus.completed);

    if (!mounted) return;
    setState(() => _isUpdating = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pos ${widget.posId} selesai! 🎉'),
          backgroundColor: AppColors.green600,
        ),
      );
    }

    context.go(AppRoutes.jelajahiPos);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.orange50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            children: [
              // ── Top Bar (shared) ──────────────────────────────────
              _buildTopBar(),
              const SizedBox(height: 16),

              // ── Slide Content (varies by type) ───────────────────
              Expanded(child: _buildSlideContent()),
              const SizedBox(height: 16),

              // ── Bottom Button (shared) ────────────────────────────
              _buildBottomButton(),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SHARED: TOP BAR
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildTopBar() {
    return Row(
      children: [
        AppBackButton(onPressed: _onBackTap),
        const SizedBox(width: 12),
        Expanded(
          child: AppProgressBar(
            progress: _progress,
            width: double.infinity,
            height: 10,
            backgroundColor: AppColors.orange100,
            fillColor: AppColors.orange800,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.green100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${_currentSlide + 1}/$_totalScenes',
            style: AppTypography.labelSmallBold.copyWith(
              color: AppColors.green900,
            ),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SLIDE CONTENT BUILDER (dispatch by type)
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildSlideContent() {
    final slide = _currentSlideData;

    switch (slide.type) {
      case SlideType.chat:
        return ChatSlide(slide: slide);
      case SlideType.info:
        return InfoSlide(slide: slide);
      case SlideType.quiz:
        return quiz.QuizSlide(
          slide: slide,
          selectedOption: _selectedQuizOption,
          isSubmitted: _quizSubmitted,
          onOptionTap: _onQuizOptionTap,
          onRetry: _onQuizRetry,
        );
      case SlideType.summary:
        return SummarySlide(slide: slide);
      case SlideType.reasonCards:
        return ReasonCardsSlide(slide: slide);
      case SlideType.terminology:
        return TerminologySlide(slide: slide);
      case SlideType.payslip:
        return PayslipSlide(slide: slide);
      case SlideType.calculationSteps:
        return CalculationStepsSlide(slide: slide);
      case SlideType.gridCards:
        final authState = ref.watch(authViewModelProvider);
        final userName = authState.user?.name ?? 'Rafi';
        return GridCardsSlide(slide: slide, userName: userName);
      case SlideType.tariffLayers:
        final authState = ref.watch(authViewModelProvider);
        final userName = authState.user?.name ?? 'Rafi';
        return TariffLayersSlide(slide: slide, userName: userName);
      case SlideType.terReconciliation:
        return TerReconciliationSlide(slide: slide);
      case SlideType.payslipComparison:
      case SlideType.profileComparison:
        final authState2 = ref.watch(authViewModelProvider);
        final userName2 = authState2.user?.name ?? 'Rafi';
        return PayslipComparisonSlide(slide: slide, userName: userName2);
      case SlideType.ptkpInfo:
        return PtkpInfoSlide(slide: slide);
      case SlideType.ptkpSimulation:
        return PtkpSimulationSlide(slide: slide, onContinue: _onNextTap);
      case SlideType.completion:
        final authState = ref.watch(authViewModelProvider);
        final userName = authState.user?.name ?? 'Rafi';
        final hasNextPos = widget.posId < 3;
        final nextPosLabel = hasNextPos
            ? 'Lanjut di Pos ${widget.posId + 1}'
            : 'Selesai';
        return CompletionSlide(
          posTitle: slide.title,
          userName: userName,
          mascotAsset: slide.mascotImagePath ?? 'assets/svg/maskot_login.svg',
          imagePath: slide.imagePath,
          chatBubbleText: slide.chatBubbleText ?? '',
          highlightText: slide.highlightTitle ?? '',
          nextPosLabel: nextPosLabel,
          showPart2: _completionShowPart2,
          onPart2Changed: (isPart2) =>
              setState(() => _completionShowPart2 = isPart2),
          onComplete: () {
            _completePos();
          },
          onGoToNextPos: () {
            if (hasNextPos) {
              _completePos();
              context.go('/pos/${widget.posId + 1}');
            } else {
              _completePos();
            }
          },
          onBack: _onBackTap,
        );
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SHARED: BOTTOM BUTTON
  // ═══════════════════════════════════════════════════════════════════════════

  bool get _showBottomButton {
    if (_currentSlideData.type == SlideType.quiz && !_quizSubmitted) {
      return false;
    }
    // Completion slide punya button sendiri
    if (_currentSlideData.type == SlideType.completion) {
      return false;
    }
    // PTKP simulation punya button sendiri
    if (_currentSlideData.type == SlideType.ptkpSimulation) {
      return false;
    }
    return true;
  }

  Widget _buildBottomButton() {
    if (!_showBottomButton) return const SizedBox.shrink();

    // ── Last slide: 2 buttons (Keluar + Lanjut ke Pos berikutnya) ──
    if (_isLastScene) {
      final hasNextPos = widget.posId < 3; // Max 3 pos
      final nextPosLabel = hasNextPos
          ? 'Lanjut ke Pos ${widget.posId + 1}'
          : 'Selesai';

      return Row(
        children: [
          // ── Tombol Keluar (secondary) ──
          Expanded(
            child: AppButton(
              label: 'Keluar',
              variant: ButtonVariant.secondary,
              width: double.infinity,
              height: 54,
              isLoading: _isUpdating,
              enabled: !_isUpdating,
              onPressed: () {
                _saveProgress();
                context.go(AppRoutes.jelajahiPos);
              },
            ),
          ),
          const SizedBox(width: 12),
          // ── Tombol Lanjut ke Pos berikutnya (primary) ──
          Expanded(
            child: AppButton(
              label: nextPosLabel,
              variant: ButtonVariant.primary,
              width: double.infinity,
              height: 54,
              isLoading: _isUpdating,
              enabled: !_isUpdating,
              icon: hasNextPos
                  ? Icons.arrow_forward
                  : Icons.check_circle_outline,
              iconColor: AppColors.green50,
              onPressed: _onNextTap,
            ),
          ),
        ],
      );
    }

    // ── Normal slide: single button ──
    final label = _currentSlideData.buttonLabel ?? 'Lanjut';

    return AppButton(
      label: label,
      variant: ButtonVariant.primary,
      width: double.infinity,
      height: 64,
      isLoading: _isUpdating,
      enabled: !_isUpdating,
      icon: Icons.arrow_forward,
      iconColor: AppColors.green50,
      onPressed: _onNextTap,
    );
  }
}
