// =============================================================================
// pos_detail_view.dart
// Halaman detail pos — placeholder untuk testing logic status progress.
// Menerima posId sebagai parameter, menampilkan konten placeholder,
// dan memiliki tombol "Selesai" yang mengubah status ke completed.
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

// ─── Data placeholder per pos ────────────────────────────────────────────────

class _PosDetailData {
  final String title;
  final String content;

  const _PosDetailData({required this.title, required this.content});
}

const Map<int, _PosDetailData> _posDetails = {
  1: _PosDetailData(
    title: 'Modul PPh 21',
    content:
        'PPh 21 adalah pajak atas penghasilan yang diterima oleh orang pribadi '
        'sebagai akibat dari pekerjaan, jabatan, kegiatan, atau kegiatan lainnya. '
        'Pemotongan dilakukan oleh pemberi kerja (perorangan atau badan usaha).',
  ),
  2: _PosDetailData(
    title: 'Modul PTKP',
    content:
        'PTKP adalah penghasilan yang dikenakan PPh 0%. Ditentukan berdasarkan '
        'status kawin, jumlah tanggungan, dan tunjangan pribadi. '
        'Semakin besar PTKP, semakin kecil pajak yang harus dibayar.',
  ),
  3: _PosDetailData(
    title: 'Modul SPT',
    content:
        'SPT Tahunan PPh Orang Pribadi adalah surat pemberitahuan untuk '
        'melaporkan penghasilan dan menghitung pajak terutang selama satu tahun. '
        'Wajib disetorkan paling lambat 31 Maret tahun berikutnya.',
  ),
};

// ─── View ────────────────────────────────────────────────────────────────────

class PosDetailView extends ConsumerWidget {
  final int posId;

  const PosDetailView({super.key, required this.posId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = _posDetails[posId];
    final progressState = ref.watch(progressViewModelProvider);
    final currentStatus = progressState.getStatus(posId);

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
                      'Pos $posId - ${detail?.title ?? ''}',
                      style: AppTypography.titleLargeBold.copyWith(
                        color: AppColors.orange900,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ── Status Indicator ────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _statusColor(currentStatus),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Status: ${posProgressStatusLabel(currentStatus)}',
                  style: AppTypography.bodyMediumMedium.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── Content Placeholder ─────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.orange200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      detail?.content ?? 'Konten tidak tersedia.',
                      style: AppTypography.bodyMediumRegular.copyWith(
                        color: AppColors.orange950,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── Tombol Aksi ─────────────────────────────────────
              if (currentStatus == PosProgressStatus.notStarted) ...[
                // Belum mulai → tombol "Mulai Belajar" → in_progress
                AppButton(
                  label: 'Mulai Belajar',
                  width: double.infinity,
                  height: 64,
                  onPressed: () async {
                    await ref
                        .read(progressViewModelProvider.notifier)
                        .updatePosProgress(posId, PosProgressStatus.inProgress);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Status berubah: Sedang Dipelajari'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                ),
              ] else if (currentStatus == PosProgressStatus.inProgress) ...[
                // Sedang belajar → tombol "Selesai" → completed
                AppButton(
                  label: 'Selesai',
                  width: double.infinity,
                  height: 64,
                  onPressed: () async {
                    await ref
                        .read(progressViewModelProvider.notifier)
                        .updatePosProgress(posId, PosProgressStatus.completed);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Status berubah: Sudah Dipelajari! 🎉'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                ),
              ] else ...[
                // Sudah selesai → tombol "Ulangi" → in_progress
                AppButton(
                  label: 'Ulangi Pos Ini',
                  variant: ButtonVariant.secondary,
                  width: double.infinity,
                  height: 64,
                  onPressed: () async {
                    await ref
                        .read(progressViewModelProvider.notifier)
                        .updatePosProgress(posId, PosProgressStatus.inProgress);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Status berubah: Sedang Dipelajari'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    }
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _statusColor(PosProgressStatus status) {
    switch (status) {
      case PosProgressStatus.notStarted:
        return AppColors.orange400;
      case PosProgressStatus.inProgress:
        return AppColors.green500;
      case PosProgressStatus.completed:
        return AppColors.green600;
    }
  }
}
