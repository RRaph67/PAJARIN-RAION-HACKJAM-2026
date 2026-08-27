// =============================================================================
// home_viewmodel.dart
// ViewModel untuk halaman Beranda (home).
// Mengelola daftar modul dan menghitung progress belajar user dari Supabase.
// =============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/pos_progress_model.dart';
import '../../../core/providers/progress_provider.dart';
import '../models/module_model.dart';

class HomeState {
  final List<ModuleModel> modules;
  final int completedCount;

  const HomeState({required this.modules, this.completedCount = 0});

  /// Jumlah modul yang sudah selesai (untuk progress bar)
  int get totalModules => modules.length;

  /// Level berdasarkan jumlah modul selesai (0-3)
  int get level => completedCount.clamp(0, 3);
}

class HomeViewModel extends StateNotifier<HomeState> {
  final ProgressState _progressState;

  HomeViewModel(this._progressState) : super(const HomeState(modules: [])) {
    _loadModules();
  }

  void _loadModules() {
    // Map status dari Supabase ke ModuleStatus
    final modules = mockModules.map((m) {
      // Cari progress untuk modul ini (pos 1-3 = modul id 1-3)
      final posStatus = _progressState.posProgress[m.id]?.status;
      final moduleStatus = _mapStatus(posStatus);
      return m.copyWith(status: moduleStatus);
    }).toList();

    final completed = modules
        .where((m) => m.status == ModuleStatus.completed)
        .length;

    state = HomeState(modules: modules, completedCount: completed);
  }

  /// Map PosProgressStatus ke ModuleStatus
  ModuleStatus _mapStatus(PosProgressStatus? status) {
    switch (status) {
      case PosProgressStatus.inProgress:
        return ModuleStatus.inProgress;
      case PosProgressStatus.completed:
        return ModuleStatus.completed;
      default:
        return ModuleStatus.notStarted;
    }
  }

  /// Refresh modules (panggil setelah progress berubah)
  void refresh(ProgressState newProgressState) {
    _loadModules();
  }
}

final homeViewModelProvider = StateNotifierProvider<HomeViewModel, HomeState>((
  ref,
) {
  final progressState = ref.watch(progressViewModelProvider);
  return HomeViewModel(progressState);
});
