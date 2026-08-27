// =============================================================================
// linkup_viewmodel.dart
// ViewModel untuk mengelola state pelengkapan profil (linkup).
// Menangani update data profil: nama, pekerjaan, penghasilan, pemahaman pajak.
// =============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/repositories/profile_repository.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';

// ─── Linkup State ───────────────────────────────────────────────────────────
enum LinkupStatus { idle, loading, success, error }

class LinkupState {
  final LinkupStatus status;
  final String? message;

  const LinkupState({this.status = LinkupStatus.idle, this.message});
}

// ─── Linkup ViewModel ───────────────────────────────────────────────────────
class LinkupViewModel extends StateNotifier<LinkupState> {
  final ProfileRepository _profileRepository;

  LinkupViewModel(this._profileRepository) : super(const LinkupState());

  /// Update profil user yang sudah login
  Future<void> completeProfile({
    required String userId,
    required String name,
    required String jobTitle,
    required double estimatedIncome,
  }) async {
    state = const LinkupState(status: LinkupStatus.loading);

    try {
      await _profileRepository.updateProfile(
        userId: userId,
        name: name,
        jobTitle: jobTitle,
        estimatedIncome: estimatedIncome,
      );

      state = const LinkupState(
        status: LinkupStatus.success,
        message: 'Profil berhasil dilengkapi!',
      );
    } on ProfileRepositoryException catch (e) {
      state = LinkupState(status: LinkupStatus.error, message: e.message);
    } catch (e) {
      state = LinkupState(
        status: LinkupStatus.error,
        message: 'Terjadi kesalahan: $e',
      );
    }
  }

  void resetStatus() {
    state = const LinkupState();
  }
}

// ─── Provider ────────────────────────────────────────────────────────────────
final linkupViewModelProvider =
    StateNotifierProvider<LinkupViewModel, LinkupState>((ref) {
      return LinkupViewModel(ref.watch(profileRepositoryProvider));
    });
