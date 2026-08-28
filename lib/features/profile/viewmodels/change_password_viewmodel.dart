// =============================================================================
// change_password_viewmodel.dart
// ViewModel untuk mengelola state dan validasi form ubah password.
// Menggunakan Riverpod StateNotifier untuk state management.
// =============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/repositories/auth_repository.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';

// ─── State ───────────────────────────────────────────────────────────────────

class ChangePasswordState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  const ChangePasswordState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  ChangePasswordState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return ChangePasswordState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

// ─── ViewModel ───────────────────────────────────────────────────────────────

class ChangePasswordViewModel extends StateNotifier<ChangePasswordState> {
  final AuthRepository _authRepository;

  ChangePasswordViewModel(this._authRepository)
    : super(const ChangePasswordState());

  /// Validasi form sebelum submit.
  /// Mengembalikan pesan error jika ada, atau null jika valid.
  String? validateForm({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) {
    // Semua field wajib diisi
    if (currentPassword.isEmpty) {
      return 'Password lama harus diisi.';
    }
    if (newPassword.isEmpty) {
      return 'Password baru harus diisi.';
    }
    if (confirmPassword.isEmpty) {
      return 'Konfirmasi password harus diisi.';
    }

    // Password baru minimal 6 karakter
    if (newPassword.length < 6) {
      return 'Password baru minimal 6 karakter.';
    }

    // Konfirmasi password harus cocok
    if (newPassword != confirmPassword) {
      return 'Konfirmasi password tidak cocok.';
    }

    // Password baru tidak boleh sama dengan password lama
    if (newPassword == currentPassword) {
      return 'Password baru harus berbeda dari password lama.';
    }

    return null;
  }

  /// Submit perubahan password ke Supabase.
  Future<bool> submitPassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    // Validasi
    final validationError = validateForm(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );

    if (validationError != null) {
      state = state.copyWith(errorMessage: validationError);
      return false;
    }

    // Mulai loading
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _authRepository.updatePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      // Sukses
      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } on AuthRepositoryException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Terjadi kesalahan: $e',
      );
      return false;
    }
  }

  /// Reset state ke default.
  void resetState() {
    state = const ChangePasswordState();
  }

  /// Clear error message.
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

// ─── Provider ────────────────────────────────────────────────────────────────

final changePasswordViewModelProvider =
    StateNotifierProvider<ChangePasswordViewModel, ChangePasswordState>(
      (ref) => ChangePasswordViewModel(ref.read(authRepositoryProvider)),
    );
