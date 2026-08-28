// =============================================================================
// progress_provider.dart
// Riverpod provider untuk state progress user terhadap pos pembelajaran.
// Mengelola loading, error, dan data progress dari Supabase.
// =============================================================================

import 'package:flutter/foundation.dart';
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
///
/// Static cache: menyimpan progress terakhir agar tidak reset
/// saat provider di-recreate (misal: auth state berubah).
class ProgressViewModel extends StateNotifier<ProgressState> {
  final ProgressRepository _repository;
  final String? _userId;

  /// Static cache — persist across ViewModel recreations
  static Map<int, PosProgress>? _cachedProgress;
  static String? _cachedUserId;

  ProgressViewModel(this._repository, this._userId)
    : super(
        // ── Load dari cache jika ada (mencegah flash empty state) ──
        _cachedProgress != null && _cachedUserId == _userId
            ? ProgressState(posProgress: _cachedProgress!)
            : const ProgressState(),
      ) {
    if (_userId != null) {
      _initializeProgress();
    }
  }

  /// Inisialisasi: load progress, dan kalau belum ada, buat default
  Future<void> _initializeProgress() async {
    final userId = _userId;
    if (userId == null) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      final progress = await _repository.getUserProgress(userId);

      // ── Kalau belum ada progress record, buat default ───────────────
      if (progress.isEmpty) {
        debugPrint(
          '[ProgressVM] No progress found for user $userId, initializing defaults...',
        );
        await _repository.initDefaultProgress(userId);
        final newProgress = await _repository.getUserProgress(userId);
        state = state.copyWith(posProgress: newProgress, isLoading: false);
        _cachedProgress = newProgress;
        _cachedUserId = _userId;
        debugPrint(
          '[ProgressVM] Default progress initialized: ${newProgress.length} records',
        );
      } else {
        state = state.copyWith(posProgress: progress, isLoading: false);
        _cachedProgress = progress;
        _cachedUserId = _userId;
        debugPrint('[ProgressVM] Loaded ${progress.length} progress records');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      debugPrint('[ProgressVM] Error initializing progress: $e');
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
      _cachedProgress = progress;
      _cachedUserId = userId;
      debugPrint('[ProgressVM] Reloaded ${progress.length} progress records');
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      debugPrint('[ProgressVM] Error loading progress: $e');
    }
  }

  /// Update status progress pos tertentu + return success/fail
  Future<bool> updatePosProgress(
    int postId,
    PosProgressStatus newStatus,
  ) async {
    final userId = _userId;
    if (userId == null) {
      debugPrint('[ProgressVM] Cannot update: userId is null');
      return false;
    }

    try {
      debugPrint('[ProgressVM] Updating pos $postId to ${newStatus.name}...');

      final updated = await _repository.upsertProgress(
        userId: userId,
        postId: postId,
        status: newStatus,
      );

      // ── Update state lokal ──────────────────────────────────────────
      final newMap = Map<int, PosProgress>.from(state.posProgress);
      newMap[postId] = updated;
      state = state.copyWith(posProgress: newMap);

      debugPrint('[ProgressVM] ✅ Pos $postId updated to ${newStatus.name}');
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      debugPrint('[ProgressVM] ❌ Error updating pos $postId: $e');
      return false;
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
      debugPrint('[ProgressVM] Error init default progress: $e');
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
