// =============================================================================
// edit_profile_viewmodel.dart
// ViewModel untuk mengelola state dan operasi edit profil user.
// Menggunakan Riverpod StateNotifier untuk state management.
// =============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/repositories/profile_repository.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';

// ─── State ───────────────────────────────────────────────────────────────────

enum EditProfileStatus { idle, loading, success, error }

class EditProfileState {
  final EditProfileStatus status;
  final String? message;

  const EditProfileState({this.status = EditProfileStatus.idle, this.message});
}

// ─── ViewModel ───────────────────────────────────────────────────────────────

class EditProfileViewModel extends StateNotifier<EditProfileState> {
  final ProfileRepository _profileRepository;

  EditProfileViewModel(this._profileRepository)
    : super(const EditProfileState());

  /// Update profil user yang sedang login.
  Future<bool> updateProfile({
    required String userId,
    required String name,
    String? jobTitle,
    double? estimatedIncome,
  }) async {
    // Validasi: nama wajib diisi
    if (name.trim().isEmpty) {
      state = const EditProfileState(
        status: EditProfileStatus.error,
        message: 'Nama tidak boleh kosong.',
      );
      return false;
    }

    state = const EditProfileState(status: EditProfileStatus.loading);

    try {
      await _profileRepository.updateProfile(
        userId: userId,
        name: name.trim(),
        jobTitle: jobTitle,
        estimatedIncome: estimatedIncome,
      );

      state = const EditProfileState(
        status: EditProfileStatus.success,
        message: 'Profil berhasil diperbarui!',
      );
      return true;
    } on ProfileRepositoryException catch (e) {
      state = EditProfileState(
        status: EditProfileStatus.error,
        message: e.message,
      );
      return false;
    } catch (e) {
      state = EditProfileState(
        status: EditProfileStatus.error,
        message: 'Terjadi kesalahan: $e',
      );
      return false;
    }
  }

  /// Reset state ke default.
  void resetState() {
    state = const EditProfileState();
  }
}

// ─── Provider ────────────────────────────────────────────────────────────────

final editProfileViewModelProvider =
    StateNotifierProvider<EditProfileViewModel, EditProfileState>((ref) {
      return EditProfileViewModel(ref.watch(profileRepositoryProvider));
    });
