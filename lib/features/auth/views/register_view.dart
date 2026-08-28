// =============================================================================
// register_view.dart
// Halaman Register — Daftar akun baru dengan data profil.
// Menggunakan AuthViewModel (Riverpod) untuk state management.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../viewmodels/auth_viewmodel.dart';

class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});

  @override
  ConsumerState<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Cek apakah semua field sudah terisi (untuk enable/disable button)
  bool get _isFormFilled =>
      _nameController.text.trim().isNotEmpty &&
      _emailController.text.trim().isNotEmpty &&
      _passwordController.text.isNotEmpty &&
      _confirmPasswordController.text.isNotEmpty;

  void _onFieldChanged(_) {
    setState(() {});
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    ref
        .read(authViewModelProvider.notifier)
        .register(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          userType: 'candidate',
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    // Dengarkan perubahan state → navigasi atau tampilkan error
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.success) {
        // Langsung navigasi tanpa notifikasi sukses
        context.go(AppRoutes.linkup);
      }

      if (next.status == AuthStatus.error && next.message != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message!),
            backgroundColor: AppColors.error,
          ),
        );
        ref.read(authViewModelProvider.notifier).resetStatus();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.orange50,
      body: Stack(
        children: [
          // ── Background ────────────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.55,
            child: Container(color: AppColors.orange50),
          ),

          // ── Maskot Register (di belakang FrameUtama) ─────────────
          Positioned(
            bottom: 506 - 64, // tinggi FrameUtama - y offset
            left: 0, // x offset
            child: SvgPicture.asset(
              'assets/svg/maskot_regis.svg',
              width: 452,
              height: 419,
            ),
          ),

          // ── Frame Utama (posisi bottom, tinggi fixed 506) ──────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: 506,
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 24,
                bottom: 54,
              ),
              decoration: BoxDecoration(
                color: AppColors.orange100,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, -4),
                    blurRadius: 5,
                    spreadRadius: 0,
                    color: const Color(0xFF493000).withValues(alpha: 0.15),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ── Frame Atas (Title + Input) ─────────────────
                    _FrameAtas(
                      nameController: _nameController,
                      emailController: _emailController,
                      passwordController: _passwordController,
                      confirmPasswordController: _confirmPasswordController,
                      onNameChanged: _onFieldChanged,
                      onEmailChanged: _onFieldChanged,
                      onPasswordChanged: _onFieldChanged,
                      onConfirmPasswordChanged: _onFieldChanged,
                    ),
                    // ── Frame Bawah (Button + Link) ────────────────
                    _FrameBawah(
                      isFormFilled: _isFormFilled,
                      isLoading: authState.status == AuthStatus.loading,
                      onPressed: _submitForm,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// TitleFrame — Judul + Subjudul
// =============================================================================
class _TitleFrame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Judul ───────────────────────────────────────────────────
        Text(
          'Yuk, Mulai Belajar Pajak!',
          textAlign: TextAlign.center,
          style: AppTypography.displaySmallExtraBold.copyWith(
            color: AppColors.orange950,
          ),
        ),
        // ── Subjudul ────────────────────────────────────────────────
        Text(
          'Buat akun untuk melanjutkan.',
          textAlign: TextAlign.center,
          style: AppTypography.headlineSmallMedium.copyWith(
            color: AppColors.orange950,
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// InputFrame — Email + Password + Confirm Password (gap 12)
// =============================================================================
class _InputFrame extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final ValueChanged<String?> onNameChanged;
  final ValueChanged<String?> onEmailChanged;
  final ValueChanged<String?> onPasswordChanged;
  final ValueChanged<String?> onConfirmPasswordChanged;

  const _InputFrame({
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onNameChanged,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onConfirmPasswordChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Nama ──────────────────────────────────────────────────
        AppTextField(
          controller: nameController,
          hintText: 'Nama Lengkap',
          prefixIcon: Icons.person_outline,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          onChanged: onNameChanged,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Nama wajib diisi';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        // ── Email ──────────────────────────────────────────────────
        AppTextField(
          controller: emailController,
          hintText: 'Email',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onChanged: onEmailChanged,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Email wajib diisi';
            }
            if (!value.contains('@')) {
              return 'Format email tidak valid';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        // ── Password ──────────────────────────────────────────────
        AppTextField(
          controller: passwordController,
          hintText: 'Password',
          prefixIcon: Icons.lock_outline,
          isPassword: true,
          textInputAction: TextInputAction.next,
          onChanged: onPasswordChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Password wajib diisi';
            }
            if (value.length < 6) {
              return 'Password minimal 6 karakter';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        // ── Konfirmasi Password ─────────────────────────────────
        AppTextField(
          controller: confirmPasswordController,
          hintText: 'Konfirmasi Password',
          prefixIcon: Icons.lock_outline,
          isPassword: true,
          textInputAction: TextInputAction.done,
          onChanged: onConfirmPasswordChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Konfirmasi password wajib diisi';
            }
            if (value != passwordController.text) {
              return 'Password tidak cocok';
            }
            return null;
          },
        ),
      ],
    );
  }
}

// =============================================================================
// FrameAtas — TitleFrame + InputFrame (gap 24)
// =============================================================================
class _FrameAtas extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final ValueChanged<String?> onNameChanged;
  final ValueChanged<String?> onEmailChanged;
  final ValueChanged<String?> onPasswordChanged;
  final ValueChanged<String?> onConfirmPasswordChanged;

  const _FrameAtas({
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onNameChanged,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onConfirmPasswordChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── TitleFrame ────────────────────────────────────────────
        SizedBox(width: double.infinity, child: _TitleFrame()),
        const SizedBox(height: 24),
        // ── InputFrame ────────────────────────────────────────────
        _InputFrame(
          nameController: nameController,
          emailController: emailController,
          passwordController: passwordController,
          confirmPasswordController: confirmPasswordController,
          onNameChanged: onNameChanged,
          onEmailChanged: onEmailChanged,
          onPasswordChanged: onPasswordChanged,
          onConfirmPasswordChanged: onConfirmPasswordChanged,
        ),
      ],
    );
  }
}

// =============================================================================
// FrameBawah — Button + Link Login
// =============================================================================
class _FrameBawah extends StatelessWidget {
  final bool isFormFilled;
  final bool isLoading;
  final VoidCallback onPressed;

  const _FrameBawah({
    required this.isFormFilled,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Button Daftar ──────────────────────────────────────────
        AppButton(
          label: 'Daftar',
          isLoading: isLoading,
          enabled: isFormFilled,
          onPressed: onPressed,
        ),
        const SizedBox(height: 16),
        // ── Link ke Login ──────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sudah punya akun? ',
              style: AppTypography.bodyLargeRegular.copyWith(
                color: AppColors.orange950,
              ),
            ),
            GestureDetector(
              onTap: () => context.go(AppRoutes.login),
              child: Text(
                'Masuk',
                style: AppTypography.bodyLargeBold.copyWith(
                  color: AppColors.orange950,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.orange950,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
