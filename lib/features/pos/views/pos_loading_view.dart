// =============================================================================
// pos_loading_view.dart
// Loading screen untuk pos — menampilkan mascot, judul, dan delay 5 detik.
// Setelah delay, navigasi ke PosDetailView (chat scene).
// Auto-update status progress ke Supabase (inProgress).
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/progress_provider.dart';
import '../../../core/router/app_router.dart';
import '../../../core/widgets/app_loading_view.dart';
import '../../home/models/pos_data_model.dart';
import '../../../core/models/pos_progress_model.dart';

class PosLoadingView extends ConsumerStatefulWidget {
  final int posId;

  const PosLoadingView({super.key, required this.posId});

  @override
  ConsumerState<PosLoadingView> createState() => _PosLoadingViewState();
}

class _PosLoadingViewState extends ConsumerState<PosLoadingView> {
  @override
  void initState() {
    super.initState();
    _startPosIfNeeded();
  }

  /// Update status pos ke inProgress jika belum
  void _startPosIfNeeded() {
    final progressState = ref.read(progressViewModelProvider);
    final currentStatus = progressState.getStatus(widget.posId);

    if (currentStatus == PosProgressStatus.notStarted) {
      ref
          .read(progressViewModelProvider.notifier)
          .updatePosProgress(widget.posId, PosProgressStatus.inProgress);
    }
  }

  @override
  Widget build(BuildContext context) {
    final posData = posListData.firstWhere(
      (p) => p.number == widget.posId,
      orElse: () => posListData.first,
    );

    return AppLoadingView(
      mascotPath: posData.imagePath,
      subtitle: 'Pos ${widget.posId} - ${posData.moduleName}',
      title: posData.title,
      delayDuration: const Duration(seconds: 5),
      onLoadingDone: () {
        if (!mounted) return;
        // ── Navigasi ke detail pos (chat scene) ──────────────────────
        context.go('${AppRoutes.jelajahiPos}/pos/${widget.posId}');
      },
      onBack: () {
        context.go(AppRoutes.jelajahiPos);
      },
    );
  }
}
