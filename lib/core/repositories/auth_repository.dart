// =============================================================================
// auth_repository.dart
// Repository untuk mengelola autentikasi menggunakan Supabase Auth.
// Menangani: register, login, logout, dan mendapatkan status auth.
// =============================================================================

import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../main.dart' show supabase;

class AuthRepository {
  // ── Access Supabase Auth ─────────────────────────────────────────────────
  GoTrueClient get _auth => supabase.auth;

  // ── Stream status autentikasi ────────────────────────────────────────────
  // Mendengarkan perubahan status login/logout secara real-time.
  Stream<AuthState> get authStateChanges => _auth.onAuthStateChange;

  // ── User yang sedang login ───────────────────────────────────────────────
  User? get currentUser => _auth.currentUser;

  // ── Apakah user sedang login? ───────────────────────────────────────────
  bool get isLoggedIn => currentUser != null;

  // ─── Register (Email + Password) ─────────────────────────────────────────
  // Membuat akun baru di Supabase Auth.
  // Setelah register, Supabase mengirim email verifikasi otomatis.
  Future<AuthResponse> register({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _auth.signUp(
        email: email,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      throw AuthRepositoryException(e.message);
    } catch (e) {
      throw AuthRepositoryException('Terjadi kesalahan saat mendaftar: $e');
    }
  }

  // ─── Login (Email + Password) ────────────────────────────────────────────
  // Masuk ke akun yang sudah terdaftar.
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      throw AuthRepositoryException(e.message);
    } catch (e) {
      throw AuthRepositoryException('Terjadi kesalahan saat login: $e');
    }
  }

  // ─── Logout ──────────────────────────────────────────────────────────────
  // Mengakhiri sesi login pengguna.
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } on AuthException catch (e) {
      throw AuthRepositoryException(e.message);
    } catch (e) {
      throw AuthRepositoryException('Terjadi kesalahan saat logout: $e');
    }
  }

  // ─── Kirim email reset password ──────────────────────────────────────────
  Future<void> resetPassword(String email) async {
    try {
      await _auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw AuthRepositoryException(e.message);
    } catch (e) {
      throw AuthRepositoryException(
          'Terjadi kesalahan saat reset password: $e');
    }
  }
}

// ─── Custom Exception untuk AuthRepository ───────────────────────────────────
// Membungkus error dari Supabase agar lebih mudah ditangani di ViewModel.
class AuthRepositoryException implements Exception {
  final String message;
  const AuthRepositoryException(this.message);

  @override
  String toString() => 'AuthRepositoryException: $message';
}
