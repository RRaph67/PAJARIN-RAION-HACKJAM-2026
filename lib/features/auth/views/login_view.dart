// =============================================================================
// login_view.dart
// Halaman Login — Masuk dengan email dan password.
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

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Cek apakah semua field sudah terisi (untuk enable/disable button)
  bool get _isFormFilled =>
      _emailController.text.trim().isNotEmpty &&
      _passwordController.text.isNotEmpty;

  void _onFieldChanged(_) {
    setState(() {});
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    ref
        .read(authViewModelProvider.notifier)
        .login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    // Dengarkan perubahan state → navigasi atau tampilkan error
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.success) {
        // Langsung navigasi tanpa notifikasi sukses
        context.go(AppRoutes.home);
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

          // ── Maskot Login (di belakang FrameUtama) ─────────────────
          Positioned(
            bottom: 506 - 64, // tinggi FrameUtama - y offset
            left: 0, // x offset
            child: SvgPicture.asset(
              'assets/svg/maskot_login.svg',
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
                      emailController: _emailController,
                      passwordController: _passwordController,
                      onEmailChanged: _onFieldChanged,
                      onPasswordChanged: _onFieldChanged,
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
          'Halo Lagi!',
          textAlign: TextAlign.center,
          style: AppTypography.displaySmallExtraBold.copyWith(
            color: AppColors.orange950,
          ),
        ),
        // ── Subjudul ────────────────────────────────────────────────
        Text(
          'Masuk dan lanjutkan memahami pajak.',
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
// InputFrame — Email + Password (gap 12)
// =============================================================================
class _InputFrame extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final ValueChanged<String?> onEmailChanged;
  final ValueChanged<String?> onPasswordChanged;

  const _InputFrame({
    required this.emailController,
    required this.passwordController,
    required this.onEmailChanged,
    required this.onPasswordChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
          textInputAction: TextInputAction.done,
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
      ],
    );
  }
}

// =============================================================================
// FrameAtas — TitleFrame + InputFrame (gap 24)
// =============================================================================
class _FrameAtas extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final ValueChanged<String?> onEmailChanged;
  final ValueChanged<String?> onPasswordChanged;

  const _FrameAtas({
    required this.emailController,
    required this.passwordController,
    required this.onEmailChanged,
    required this.onPasswordChanged,
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
          emailController: emailController,
          passwordController: passwordController,
          onEmailChanged: onEmailChanged,
          onPasswordChanged: onPasswordChanged,
        ),
      ],
    );
  }
}

// =============================================================================
// FrameBawah — Button + Link Register
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
        // ── Button Masuk ──────────────────────────────────────────
        AppButton(
          label: 'Masuk',
          isLoading: isLoading,
          enabled: isFormFilled,
          onPressed: onPressed,
        ),
        const SizedBox(height: 16),
        // ── Link ke Register ──────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Belum memiliki akun? ',
              style: AppTypography.bodyLargeRegular.copyWith(
                color: AppColors.orange950,
              ),
            ),
            GestureDetector(
              onTap: () => context.go(AppRoutes.register),
              child: Text(
                'Daftar',
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
