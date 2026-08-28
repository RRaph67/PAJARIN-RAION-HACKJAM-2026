// =============================================================================
// profile_view.dart
// Konten halaman profil user — menampilkan data dari tabel `users` Supabase.
// Memungkinkan user melihat profil, progress belajar, dan menu navigasi.
// Status mapping dipisahkan ke pos_data_model.dart untuk reusability.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/pos_progress_model.dart';
import '../../../core/models/user_model.dart';
import '../../../core/providers/progress_provider.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_status_chip.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../../home/models/pos_data_model.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final progressState = ref.watch(progressViewModelProvider);
    final user = authState.user;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ═══════════════ SECTION 1: HEADER PROFIL ═══════════════
          _buildHeaderSection(context, user),

          const SizedBox(height: 24),

          // ═══════════════ SECTION 2: PROGRESS BELAJAR ═══════════════
          _buildProgressSection(progressState),

          const SizedBox(height: 24),

          // ═══════════════ SECTION 3: NAVIGATION MENU ═══════════════
          _buildNavigationSection(context, ref),
        ],
      ),
    );
  }

  // ─── Section 1: Header Profil ──────────────────────────────────────────
  Widget _buildHeaderSection(BuildContext context, UserModel? user) {
    final name = user?.name ?? 'User';
    final jobTitle = user?.jobTitle ?? 'Belum diisi';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: AppColors.orange500,
            child: Text(
              initial,
              style: const TextStyle(
                fontSize: 36,
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: AppTypography.displayMediumExtraBold.copyWith(
              color: AppColors.orange950,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            jobTitle,
            style: AppTypography.titleMediumBold.copyWith(
              color: AppColors.orange900,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          AppButton(
            label: 'Ubah Profil & Data Diri',
            icon: Icons.edit_outlined,
            variant: ButtonVariant.secondary,
            width: 361,
            height: 48,
            onPressed: () => context.push('/profile/edit-profile'),
          ),
        ],
      ),
    );
  }

  // ─── Section 2: Progress Belajar ───────────────────────────────────────
  Widget _buildProgressSection(ProgressState progressState) {
    final posData = [
      {'id': 1, 'title': 'Pos 1 - Modul PPh 21'},
      {'id': 2, 'title': 'Pos 2 - Modul PTKP'},
      {'id': 3, 'title': 'Pos 3 - Modul SPT'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Progress Belajar',
          style: AppTypography.titleLargeBold.copyWith(
            color: AppColors.orange950,
          ),
        ),
        const SizedBox(height: 12),
        ...posData.map((pos) {
          final posId = pos['id'] as int;
          final title = pos['title'] as String;
          final status = progressState.getStatus(posId);

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildProgressCard(title: title, status: status),
          );
        }),
      ],
    );
  }

  // ─── Progress Card — menggunakan shared helpers ────────────────────────
  Widget _buildProgressCard({
    required String title,
    required PosProgressStatus status,
  }) {
    // Panggil shared helper dari pos_data_model.dart
    final chipVariant = getProgressChipVariant(status);
    final chipLabel = getProgressChipLabel(status);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.orange100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTypography.titleMediumBold.copyWith(
                color: AppColors.orange950,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 12),
          AppStatusChip(variant: chipVariant, label: chipLabel),
        ],
      ),
    );
  }

  // ─── Section 3: Navigation Menu ────────────────────────────────────────
  Widget _buildNavigationSection(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _buildMenuCard(
          title: 'CoreTax Checklist',
          icon: Icons.checklist_outlined,
          backgroundColor: AppColors.green100,
          textColor: AppColors.green900,
          iconColor: AppColors.green700,
          onTap: () => context.push('/profile/coretax-checklist'),
        ),
        const SizedBox(height: 8),
        _buildMenuCard(
          title: 'FAQ Pajak',
          icon: Icons.help_outline,
          backgroundColor: AppColors.green100,
          textColor: AppColors.green900,
          iconColor: AppColors.green700,
          onTap: () => context.push('/profile/faq-pajak'),
        ),
        const SizedBox(height: 8),
        _buildMenuCard(
          title: 'Ubah Password',
          icon: Icons.lock_outline,
          backgroundColor: AppColors.green100,
          textColor: AppColors.green900,
          iconColor: AppColors.green700,
          onTap: () => context.push('/profile/change-password'),
        ),
        const SizedBox(height: 8),
        _buildMenuCard(
          title: 'Logout',
          icon: Icons.logout,
          backgroundColor: const Color(0xFFFDE8E8),
          textColor: const Color(0xFFB91C1C),
          iconColor: const Color(0xFFB91C1C),
          onTap: () => _showLogoutDialog(context, ref),
        ),
      ],
    );
  }

  // ─── Menu Card ─────────────────────────────────────────────────────────
  Widget _buildMenuCard({
    required String title,
    required IconData icon,
    required Color backgroundColor,
    required Color textColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: iconColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: AppTypography.titleMediumBold.copyWith(color: textColor),
              ),
            ),
            Icon(Icons.chevron_right, size: 22, color: textColor),
          ],
        ),
      ),
    );
  }

  // ─── Logout Dialog ─────────────────────────────────────────────────────
  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Logout',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w800,
            color: AppColors.orange950,
          ),
        ),
        content: const Text(
          'Apakah kamu yakin ingin keluar?',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w500,
            color: AppColors.orange900,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Batal',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w600,
                color: AppColors.orange900,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await ref.read(authViewModelProvider.notifier).logout();
              if (context.mounted) context.go(AppRoutes.login);
            },
            child: const Text(
              'Keluar',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w700,
                color: Color(0xFFB91C1C),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
