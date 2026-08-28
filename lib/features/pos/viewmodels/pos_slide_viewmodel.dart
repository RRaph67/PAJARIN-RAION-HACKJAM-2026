// =============================================================================
// pos_slide_viewmodel.dart
// ViewModel untuk mengelola state slide pada detail pos.
// Menangani navigasi slide, progress, dan status penyelesaian pos.
// =============================================================================

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/pos_progress_model.dart';
import '../../../core/providers/progress_provider.dart';
import '../../home/models/pos_data_model.dart';

// ─── State ───────────────────────────────────────────────────────────────────

class PosSlideState {
  final int currentSlide;
  final int totalSlides;
  final bool isCompleted;

  const PosSlideState({
    this.currentSlide = 0,
    this.totalSlides = 1,
    this.isCompleted = false,
  });

  /// Apakah ini slide pertama
  bool get isFirstSlide => currentSlide == 0;

  /// Apakah ini slide terakhir
  bool get isLastSlide => currentSlide == totalSlides - 1;

  /// Progress slide (0.0 - 1.0)
  double get slideProgress =>
      totalSlides > 0 ? (currentSlide + 1) / totalSlides : 0.0;

  /// Nomor slide saat ini (1-indexed untuk display)
  int get displaySlideNumber => currentSlide + 1;

  /// Alias untuk kompatibilitas dengan AppLevelBar
  int get totalSteps => totalSlides;

  PosSlideState copyWith({
    int? currentSlide,
    int? totalSlides,
    bool? isCompleted,
  }) {
    return PosSlideState(
      currentSlide: currentSlide ?? this.currentSlide,
      totalSlides: totalSlides ?? this.totalSlides,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

// ─── ViewModel ───────────────────────────────────────────────────────────────

class PosSlideViewModel extends StateNotifier<PosSlideState> {
  final ProgressViewModel _progressViewModel;
  final int posId;
  final List<PosSlide> slides;

  PosSlideViewModel({
    required this.posId,
    required this.slides,
    required ProgressViewModel progressViewModel,
  }) : _progressViewModel = progressViewModel,
       super(
         PosSlideState(
           currentSlide: 0,
           totalSlides: slides.length,
           isCompleted:
               progressViewModel.state.posProgress[posId]?.status ==
               PosProgressStatus.completed,
         ),
       ) {
    debugPrint(
      '[PosSlideVM] Initialized for pos $posId with ${slides.length} slides',
    );
  }

  /// Pindah ke slide berikutnya
  void nextSlide() {
    if (state.isLastSlide) return;

    final newSlide = state.currentSlide + 1;
    state = state.copyWith(currentSlide: newSlide);
    debugPrint(
      '[PosSlideVM] Slide ${state.displaySlideNumber}/${state.totalSlides}',
    );
  }

  /// Pindah ke slide sebelumnya
  void previousSlide() {
    if (state.isFirstSlide) return;

    final newSlide = state.currentSlide - 1;
    state = state.copyWith(currentSlide: newSlide);
    debugPrint(
      '[PosSlideVM] Slide ${state.displaySlideNumber}/${state.totalSlides}',
    );
  }

  /// Jump ke slide tertentu (0-indexed)
  void goToSlide(int index) {
    if (index < 0 || index >= state.totalSlides) return;

    state = state.copyWith(currentSlide: index);
    debugPrint(
      '[PosSlideVM] Jumped to slide ${index + 1}/${state.totalSlides}',
    );
  }

  /// Selesaikan pos → update status ke completed di Supabase
  Future<bool> completePos() async {
    debugPrint('[PosSlideVM] Completing pos $posId...');

    final success = await _progressViewModel.updatePosProgress(
      posId,
      PosProgressStatus.completed,
    );

    if (success) {
      state = state.copyWith(isCompleted: true);
      debugPrint('[PosSlideVM] ✅ Pos $posId marked as completed');
    } else {
      debugPrint('[PosSlideVM] ❌ Failed to complete pos $posId');
    }

    return success;
  }

  /// Mulai/masuk pos → update status ke inProgress jika belum
  Future<void> startPosIfNeeded() async {
    final currentStatus = _progressViewModel.state.getStatus(posId);

    if (currentStatus == PosProgressStatus.notStarted) {
      debugPrint('[PosSlideVM] Starting pos $posId (setting to inProgress)');
      await _progressViewModel.updatePosProgress(
        posId,
        PosProgressStatus.inProgress,
      );
    }
  }

  /// Ambil data slide saat ini
  PosSlide get currentSlideData => slides[state.currentSlide];
}

// ─── Provider ────────────────────────────────────────────────────────────────

/// Provider untuk PosSlideViewModel per pos
/// Args: (posId, slides)
final posSlideViewModelProvider = StateNotifierProvider.autoDispose
    .family<
      PosSlideViewModel,
      PosSlideState,
      ({int posId, List<PosSlide> slides})
    >((ref, args) {
      final progressVM = ref.watch(progressViewModelProvider.notifier);

      return PosSlideViewModel(
        posId: args.posId,
        slides: args.slides,
        progressViewModel: progressVM,
      );
    });
