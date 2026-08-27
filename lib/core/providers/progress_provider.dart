// =============================================================================
// progress_provider.dart
// Riverpod provider untuk state progress user terhadap pos pembelajaran.
// Mengelola loading, error, dan data progress dari Supabase.
// =============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/viewmodels/auth_viewmodel.dart';
import '../models/pos_progress_model.dart';
import '../repositories/progress_repository.dart';

/// State untuk progress user
class ProgressState {
  final Map<int, PosProgress> posProgress;
  final bool isLoading;
  final String? error;

  const ProgressState({
    this.posProgress = const {},
    this.isLoading = false,
    this.error,
  });

  /// Status progress untuk pos tertentu (default: notStarted)
  PosProgressStatus getStatus(int posNumber) {
    return posProgress[posNumber]?.status ?? PosProgressStatus.notStarted;
  }

  /// Jumlah pos yang sudah selesai
  int get completedCount {
    return posProgress.values
        .where((p) => p.status == PosProgressStatus.completed)
        .length;
  }

  /// Total pos
  int get totalPos => 3;

  /// Progress sebagai double (0.0 - 1.0)
  double get progress => totalPos > 0 ? completedCount / totalPos : 0.0;

  /// Copy with
  ProgressState copyWith({
    Map<int, PosProgress>? posProgress,
    bool? isLoading,
    String? error,
  }) {
    return ProgressState(
      posProgress: posProgress ?? this.posProgress,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// ViewModel untuk mengelola progress user
class ProgressViewModel extends StateNotifier<ProgressState> {
  final ProgressRepository _repository;
  final String? _userId;

  ProgressViewModel(this._repository, this._userId)
    : super(const ProgressState()) {
    if (_userId != null) {
      loadProgress();
    }
  }

  /// Load semua progress user dari Supabase
  Future<void> loadProgress() async {
    final userId = _userId;
    if (userId == null) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      final progress = await _repository.getUserProgress(userId);
      state = state.copyWith(posProgress: progress, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Update status progress pos tertentu
  Future<void> updatePosProgress(
    int postId,
    PosProgressStatus newStatus,
  ) async {
    final userId = _userId;
    if (userId == null) return;

    try {
      final updated = await _repository.upsertProgress(
        userId: userId,
        postId: postId,
        status: newStatus,
      );

      final newMap = Map<int, PosProgress>.from(state.posProgress);
      newMap[postId] = updated;
      state = state.copyWith(posProgress: newMap);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Inisialisasi progress default untuk user baru
  Future<void> initDefaultProgress() async {
    final userId = _userId;
    if (userId == null) return;

    try {
      await _repository.initDefaultProgress(userId);
      await loadProgress();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

/// Provider untuk ProgressRepository
final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return ProgressRepository();
});

/// Provider untuk ProgressViewModel
final progressViewModelProvider =
    StateNotifierProvider<ProgressViewModel, ProgressState>((ref) {
      final repository = ref.watch(progressRepositoryProvider);
      final authState = ref.watch(authViewModelProvider);
      final userId = authState.user?.id;
      return ProgressViewModel(repository, userId);
    });
