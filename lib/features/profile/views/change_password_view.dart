// =============================================================================
// change_password_view.dart
// Halaman "Ubah Password Kamu" — form untuk memperbarui password akun.
// Menggunakan AppTextField (password variant) dan terintegrasi dengan Supabase Auth.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../viewmodels/change_password_viewmodel.dart';

class ChangePasswordView extends ConsumerStatefulWidget {
  const ChangePasswordView({super.key});

  @override
  ConsumerState<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends ConsumerState<ChangePasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    final viewModel = ref.read(changePasswordViewModelProvider.notifier);

    final success = await viewModel.submitPassword(
      currentPassword: _oldPasswordController.text.trim(),
      newPassword: _newPasswordController.text.trim(),
      confirmPassword: _confirmPasswordController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      // Tampilkan snackbar sukses
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password berhasil diperbarui!'),
          backgroundColor: AppColors.green600,
        ),
      );

      // Reset form
      _oldPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      viewModel.resetState();

      // Kembali ke halaman sebelumnya
      context.pop();
    } else {
      // Tampilkan snackbar error dari state
      final error = ref.read(changePasswordViewModelProvider).errorMessage;
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: AppColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final passwordState = ref.watch(changePasswordViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.orange50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              // ═══════════════ TOP BAR ═══════════════
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AppBackButton(onPressed: () => context.pop()),
                ),
              ),

              // ═══════════════ SCROLLABLE CONTENT ═══════════════
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 24),

                        // ── Header Section ────────────────────────────
                        _buildHeaderSection(),

                        const SizedBox(height: 100),

                        // ── Input Fields ──────────────────────────────
                        _buildInputFields(passwordState),
                      ],
                    ),
                  ),
                ),
              ),

              // ═══════════════ BOTTOM BUTTON ═══════════════
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: AppButton(
                  label: passwordState.isLoading
                      ? 'Menyimpan...'
                      : 'Simpan Perubahan',
                  onPressed: passwordState.isLoading ? null : _handleSubmit,
                  width: double.infinity,
                  height: 52,
                  isLoading: passwordState.isLoading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Header Section ────────────────────────────────────────────────────────
  Widget _buildHeaderSection() {
    return Column(
      children: [
        // ── Lock Icon ────────────────────────────────────────────────
        Icon(Icons.lock_outline_rounded, size: 32, color: AppColors.orange950),
        const SizedBox(height: 8),

        // ── Title ────────────────────────────────────────────────────
        Text(
          'Ubah Password Kamu',
          style: AppTypography.displayMediumExtraBold.copyWith(
            color: AppColors.orange950,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // ─── Input Fields ──────────────────────────────────────────────────────────
  Widget _buildInputFields(ChangePasswordState passwordState) {
    return Column(
      children: [
        // ── Password Lama ────────────────────────────────────────────
        AppTextField(
          hintText: 'Masukkan Password Lama',
          controller: _oldPasswordController,
          isPassword: true,
          width: double.infinity,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 32),

        // ── Password Baru ───────────────────────────────────────────
        AppTextField(
          hintText: 'Masukkan Password Baru',
          controller: _newPasswordController,
          isPassword: true,
          width: double.infinity,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),

        // ── Konfirmasi Password Baru ────────────────────────────────
        AppTextField(
          hintText: 'Konfirmasi Password Baru',
          controller: _confirmPasswordController,
          isPassword: true,
          width: double.infinity,
          textInputAction: TextInputAction.done,
          onEditingComplete: _handleSubmit,
        ),

        // ── Error Message (jika ada) ────────────────────────────────
        if (passwordState.errorMessage != null) ...[
          const SizedBox(height: 16),
          Text(
            passwordState.errorMessage!,
            style: AppTypography.bodySmallBold.copyWith(color: AppColors.error),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
