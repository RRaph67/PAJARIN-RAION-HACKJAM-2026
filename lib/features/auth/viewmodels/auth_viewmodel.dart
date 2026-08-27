// =============================================================================
// auth_viewmodel.dart
// ViewModel untuk mengelola state autentikasi: register, login, logout.
// Menggunakan Riverpod StateNotifier agar state (loading/error/user)
// dapat dipantau oleh widget secara reaktif.
// =============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/repositories/auth_repository.dart';
import '../../../core/repositories/profile_repository.dart';
import '../../../core/models/user_model.dart';

// ─── Auth State ──────────────────────────────────────────────────────────────
// Menampung seluruh state yang dibutuhkan halaman autentikasi:
// - status  : idle / loading / success / error
// - message : pesan error atau sukses untuk ditampilkan ke user
// - user    : data profil user setelah berhasil login/register
enum AuthStatus { idle, loading, success, error }

class AuthState {
  final AuthStatus status;
  final String? message;
  final UserModel? user;

  const AuthState({this.status = AuthStatus.idle, this.message, this.user});

  // Buat salinan dengan perubahan sebagian field.
  AuthState copyWith({AuthStatus? status, String? message, UserModel? user}) {
    return AuthState(
      status: status ?? this.status,
      message: message,
      user: user ?? this.user,
    );
  }
}

// ─── Auth ViewModel (StateNotifier) ──────────────────────────────────────────
class AuthViewModel extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final ProfileRepository _profileRepository;

  AuthViewModel({
    required AuthRepository authRepository,
    required ProfileRepository profileRepository,
  }) : _authRepository = authRepository,
       _profileRepository = profileRepository,
       super(const AuthState()) {
    // Auto-load profile jika session sudah ada (app restart)
    _loadProfileOnStartup();
  }

  /// Load profil dari session aktif saat app pertama kali dibuka.
  /// Ini memastikan data user tersedia sebelum navigasi ke home.
  Future<void> _loadProfileOnStartup() async {
    final userId = _authRepository.currentUser?.id;
    if (userId == null) return;

    try {
      final profile = await _profileRepository.getProfile(userId);
      state = state.copyWith(status: AuthStatus.success, user: profile);
    } catch (e) {
      // Profil belum ada di tabel users (belum complete profile)
      // atau error lainnya — tetap set status success agar app bisa jalan
      state = state.copyWith(status: AuthStatus.success);
    }
  }

  // ─── Register ────────────────────────────────────────────────────────────
  // 1. Buat akun di Supabase Auth
  // 2. Simpan data profil ke tabel `users`
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String userType,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, message: null);

    try {
      // Langkah 1: Buat akun di Supabase Auth
      final authResponse = await _authRepository.register(
        email: email,
        password: password,
      );

      final userId = authResponse.user?.id;
      if (userId == null) {
        state = state.copyWith(
          status: AuthStatus.error,
          message: 'Gagal membuat akun. Silakan coba lagi.',
        );
        return;
      }

      // Langkah 2: Simpan profil ke tabel `users`
      final profile = await _profileRepository.createProfile(
        userId: userId,
        name: name,
        email: email,
        userType: userType,
      );

      state = state.copyWith(
        status: AuthStatus.success,
        message: 'Registrasi berhasil!',
        user: profile,
      );
    } on AuthRepositoryException catch (e) {
      state = state.copyWith(status: AuthStatus.error, message: e.message);
    } on ProfileRepositoryException catch (e) {
      state = state.copyWith(status: AuthStatus.error, message: e.message);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        message: 'Terjadi kesalahan tak terduga: $e',
      );
    }
  }

  // ─── Login ───────────────────────────────────────────────────────────────
  // 1. Login ke Supabase Auth
  // 2. Ambil data profil dari tabel `users` (jika ada)
  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(status: AuthStatus.loading, message: null);

    try {
      // Langkah 1: Login ke Supabase Auth
      final authResponse = await _authRepository.login(
        email: email,
        password: password,
      );

      final userId = authResponse.user?.id;
      if (userId == null) {
        state = state.copyWith(
          status: AuthStatus.error,
          message: 'Login gagal. Periksa email dan password Anda.',
        );
        return;
      }

      // Langkah 2: Ambil profil dari tabel `users` (jika ada)
      try {
        final profile = await _profileRepository.getProfile(userId);
        state = state.copyWith(status: AuthStatus.success, user: profile);
      } catch (_) {
        // Profil belum ada di tabel users — user tetap bisa lanjut
        state = state.copyWith(status: AuthStatus.success);
      }
    } on AuthRepositoryException catch (e) {
      state = state.copyWith(status: AuthStatus.error, message: e.message);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        message: 'Terjadi kesalahan tak terduga: $e',
      );
    }
  }

  // ─── Logout ──────────────────────────────────────────────────────────────
  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      await _authRepository.logout();
      state = const AuthState(); // reset ke idle
    } on AuthRepositoryException catch (e) {
      state = state.copyWith(status: AuthStatus.error, message: e.message);
    }
  }

  // ─── Reset state ke idle ─────────────────────────────────────────────────
  // Dipanggil setelah user melihat pesan error/sukses dan menutupnya.
  void resetStatus() {
    state = state.copyWith(status: AuthStatus.idle, message: null);
  }
}

// ─── Provider ────────────────────────────────────────────────────────────────
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository();
});

final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>((
  ref,
) {
  return AuthViewModel(
    authRepository: ref.watch(authRepositoryProvider),
    profileRepository: ref.watch(profileRepositoryProvider),
  );
});
