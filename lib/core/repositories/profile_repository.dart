// =============================================================================
// profile_repository.dart
// Repository untuk mengelola data profil user di tabel `public.users` Supabase.
// Menangani: ambil profil, update profil, dan cek apakah profil sudah ada.
// =============================================================================

import '../models/user_model.dart';
import '../../main.dart' show supabase;

class ProfileRepository {
  // ── Nama tabel di Supabase ───────────────────────────────────────────────
  // Pastikan tabel `users` sudah dibuat di Supabase Dashboard → Table Editor.
  static const String _tableName = 'users';

  // ─── Ambil profil user berdasarkan ID ────────────────────────────────────
  // Mengambil satu baris data dari tabel users berdasarkan auth user ID.
  Future<UserModel> getProfile(String userId) async {
    try {
      final response = await supabase
          .from(_tableName)
          .select()
          .eq('id', userId)
          .single();

      return UserModel.fromJson(response);
    } catch (e) {
      throw ProfileRepositoryException('Gagal mengambil data profil: $e');
    }
  }

  // ─── Buat profil baru (setelah register) ─────────────────────────────────
  // Menyimpan data profil ke tabel `users` menggunakan ID dari Supabase Auth.
  // Dipanggil sekali setelah user berhasil register.
  Future<UserModel> createProfile({
    required String userId,
    required String name,
    required String email,
    required String userType,
    String? jobTitle,
    double? estimatedIncome,
  }) async {
    try {
      final data = {
        'id': userId,
        'name': name,
        'email': email,
        'user_type': userType,
        'job_title': jobTitle,
        'estimated_income': estimatedIncome,
      };

      final response = await supabase
          .from(_tableName)
          .insert(data)
          .select()
          .single();

      return UserModel.fromJson(response);
    } catch (e) {
      throw ProfileRepositoryException('Gagal membuat profil: $e');
    }
  }

  // ─── Update profil yang sudah ada ────────────────────────────────────────
  // Memperbarui kolom tertentu pada tabel `users`.
  Future<UserModel> updateProfile({
    required String userId,
    String? name,
    String? userType,
    String? jobTitle,
    double? estimatedIncome,
  }) async {
    try {
      // Bangun map hanya berisi field yang ingin diupdate (selain null).
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (userType != null) data['user_type'] = userType;
      if (jobTitle != null) data['job_title'] = jobTitle;
      if (estimatedIncome != null) data['estimated_income'] = estimatedIncome;

      if (data.isEmpty) {
        return await getProfile(userId);
      }

      final response = await supabase
          .from(_tableName)
          .update(data)
          .eq('id', userId)
          .select()
          .single();

      return UserModel.fromJson(response);
    } catch (e) {
      throw ProfileRepositoryException('Gagal memperbarui profil: $e');
    }
  }

  // ─── Hapus profil ────────────────────────────────────────────────────────
  // Menghapus baris data dari tabel `users`.
  Future<void> deleteProfile(String userId) async {
    try {
      await supabase.from(_tableName).delete().eq('id', userId);
    } catch (e) {
      throw ProfileRepositoryException('Gagal menghapus profil: $e');
    }
  }
}

// ─── Custom Exception untuk ProfileRepository ────────────────────────────────
class ProfileRepositoryException implements Exception {
  final String message;
  const ProfileRepositoryException(this.message);

  @override
  String toString() => 'ProfileRepositoryException: $message';
}
