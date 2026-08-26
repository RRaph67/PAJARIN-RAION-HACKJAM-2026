// =============================================================================
// auth_view.dart
// Halaman autentikasi dengan dua mode: Register dan Login.
// Menggunakan ConsumerWidget dari Riverpod untuk membaca/memanggil AuthViewModel.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_router.dart';
import '../viewmodels/auth_viewmodel.dart';

class AuthView extends ConsumerStatefulWidget {
  const AuthView({super.key});

  @override
  ConsumerState<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends ConsumerState<AuthView> {
  // ── Mode: true = Register, false = Login ────────────────────────────────
  bool _isRegisterMode = true;

  // ── Key untuk validasi form ─────────────────────────────────────────────
  final _formKey = GlobalKey<FormState>();

  // ── Controller untuk setiap input field ─────────────────────────────────
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // ── Toggle visibilitas password ─────────────────────────────────────────
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ─── Submit Form ────────────────────────────────────────────────────────
  // Memanggil register() atau login() pada AuthViewModel tergantung mode.
  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final authVM = ref.read(authViewModelProvider.notifier);

    if (_isRegisterMode) {
      authVM.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        userType: 'candidate', // default user type saat register
      );
    } else {
      authVM.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Pantau state dari AuthViewModel
    final authState = ref.watch(authViewModelProvider);

    // ── Jika sukses → navigasi ke Home ────────────────────────────────────
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message ?? 'Berhasil!'),
            backgroundColor: Colors.green,
          ),
        );
        context.go(AppRoutes.home);
      }

      if (next.status == AuthStatus.error && next.message != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message!), backgroundColor: Colors.red),
        );
        ref.read(authViewModelProvider.notifier).resetStatus();
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(_isRegisterMode ? 'Daftar Akun' : 'Masuk')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header ──────────────────────────────────────────────────
              const SizedBox(height: 32),
              Icon(
                Icons.person_add_rounded,
                size: 72,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                _isRegisterMode ? 'Buat Akun Baru' : 'Selamat Datang Kembali',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isRegisterMode
                    ? 'Isi data di bawah untuk mendaftar'
                    : 'Masuk dengan akun yang sudah terdaftar',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 32),

              // ── Nama (hanya untuk Register) ────────────────────────────
              if (_isRegisterMode) ...[
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Nama Lengkap',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
              ],

              // ── Email ──────────────────────────────────────────────────
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
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
              const SizedBox(height: 16),

              // ── Password ──────────────────────────────────────────────
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
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
              const SizedBox(height: 16),

              // ── Konfirmasi Password (hanya untuk Register) ─────────────
              if (_isRegisterMode) ...[
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Konfirmasi Password',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Password tidak cocok';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
              ],

              // ── Tombol Submit ──────────────────────────────────────────
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: authState.status == AuthStatus.loading
                    ? null // disable tombol saat loading
                    : _submitForm,
                child: authState.status == AuthStatus.loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(_isRegisterMode ? 'Daftar' : 'Masuk'),
              ),
              const SizedBox(height: 16),

              // ── Toggle Register / Login ────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isRegisterMode
                        ? 'Sudah punya akun? '
                        : 'Belum punya akun? ',
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isRegisterMode = !_isRegisterMode;
                        _formKey.currentState?.reset();
                      });
                    },
                    child: Text(
                      _isRegisterMode ? 'Masuk di sini' : 'Daftar di sini',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
