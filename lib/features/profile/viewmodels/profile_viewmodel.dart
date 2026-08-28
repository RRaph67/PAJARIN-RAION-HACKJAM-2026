// =============================================================================
// profile_viewmodel.dart
// ViewModel untuk mengelola state profil user: fetch, update.
// Menggunakan Riverpod StateNotifier agar state (loading/error/user)
// dapat dipantau oleh widget secara reaktif.
// =============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/repositories/profile_repository.dart';
import '../../../core/models/user_model.dart';

// ─── Profile State ───────────────────────────────────────────────────────────
// Menampung seluruh state yang dibutuhkan halaman profil:
// - status  : idle / loading / success / error
// - message : pesan error atau sukses untuk ditampilkan ke user
// - user    : data profil user yang sedang login
enum ProfileStatus { idle, loading, success, error }

class ProfileState {
  final ProfileStatus status;
  final String? message;
  final UserModel? user;

  const ProfileState({
    this.status = ProfileStatus.idle,
    this.message,
    this.user,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    String? message,
    UserModel? user,
  }) {
    return ProfileState(
      status: status ?? this.status,
      message: message,
      user: user ?? this.user,
    );
  }
}

// ─── Profile ViewModel (StateNotifier) ───────────────────────────────────────
class ProfileViewModel extends StateNotifier<ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileViewModel({required ProfileRepository profileRepository})
    : _profileRepository = profileRepository,
      super(const ProfileState());

  // ─── Fetch Profil ────────────────────────────────────────────────────────
  // Mengambil data profil dari Supabase berdasarkan user ID.
  Future<void> fetchProfile(String userId) async {
    state = state.copyWith(status: ProfileStatus.loading, message: null);

    try {
      final profile = await _profileRepository.getProfile(userId);

      state = state.copyWith(status: ProfileStatus.success, user: profile);
    } on ProfileRepositoryException catch (e) {
      state = state.copyWith(status: ProfileStatus.error, message: e.message);
    } catch (e) {
      state = state.copyWith(
        status: ProfileStatus.error,
        message: 'Gagal memuat profil: $e',
      );
    }
  }

  // ─── Update Profil ───────────────────────────────────────────────────────
  // Memperbarui data profil di Supabase.
  Future<void> updateProfile({
    required String userId,
    String? name,
    String? userType,
    String? jobTitle,
    double? estimatedIncome,
  }) async {
    state = state.copyWith(status: ProfileStatus.loading, message: null);

    try {
      final updatedProfile = await _profileRepository.updateProfile(
        userId: userId,
        name: name,
        userType: userType,
        jobTitle: jobTitle,
        estimatedIncome: estimatedIncome,
      );

      state = state.copyWith(
        status: ProfileStatus.success,
        message: 'Profil berhasil diperbarui!',
        user: updatedProfile,
      );
    } on ProfileRepositoryException catch (e) {
      state = state.copyWith(status: ProfileStatus.error, message: e.message);
    } catch (e) {
      state = state.copyWith(
        status: ProfileStatus.error,
        message: 'Gagal memperbarui profil: $e',
      );
    }
  }

  // ─── Reset pesan ─────────────────────────────────────────────────────────
  void resetStatus() {
    state = state.copyWith(status: ProfileStatus.idle, message: null);
  }
}

// ─── Provider ────────────────────────────────────────────────────────────────
final profileViewModelProvider =
    StateNotifierProvider<ProfileViewModel, ProfileState>((ref) {
      return ProfileViewModel(profileRepository: ProfileRepository());
    });
