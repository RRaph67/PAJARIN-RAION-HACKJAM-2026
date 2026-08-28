// =============================================================================
// progress_repository.dart
// Repository untuk mengelola progress user terhadap pos pembelajaran.
// Menyimpan dan membaca data dari tabel `user_progress` di Supabase.
// =============================================================================

import 'package:flutter/foundation.dart';
import '../models/pos_progress_model.dart';
import '../../main.dart' show supabase;

class ProgressRepository {
  // ── Nama tabel di Supabase ───────────────────────────────────────────────
  static const String _tableName = 'user_progress';

  // ─── Ambil semua progress user ───────────────────────────────────────────
  Future<Map<int, PosProgress>> getUserProgress(String userId) async {
    try {
      final response = await supabase
          .from(_tableName)
          .select()
          .eq('user_id', userId);

      final Map<int, PosProgress> progress = {};
      for (final row in response) {
        final posProgress = PosProgress.fromJson(row);
        progress[posProgress.postId] = posProgress;
      }
      debugPrint(
        '[ProgressRepo] getUserProgress: ${progress.length} records for $userId',
      );
      return progress;
    } catch (e) {
      debugPrint('[ProgressRepo] ❌ getUserProgress error: $e');
      throw ProgressRepositoryException('Gagal mengambil progress: $e');
    }
  }

  // ─── Ambil progress satu pos ─────────────────────────────────────────────
  Future<PosProgress?> getPosProgress(String userId, int postId) async {
    try {
      final response = await supabase
          .from(_tableName)
          .select()
          .eq('user_id', userId)
          .eq('post_id', postId)
          .maybeSingle();

      if (response == null) return null;
      return PosProgress.fromJson(response);
    } catch (e) {
      debugPrint('[ProgressRepo] ❌ getPosProgress error: $e');
      throw ProgressRepositoryException('Gagal mengambil progress pos: $e');
    }
  }

  // ─── Update atau buat progress pos ───────────────────────────────────────
  Future<PosProgress> upsertProgress({
    required String userId,
    required int postId,
    required PosProgressStatus status,
  }) async {
    try {
      final data = {
        'user_id': userId,
        'post_id': postId,
        'status': _statusToDb(status),
      };

      debugPrint(
        '[ProgressRepo] Upserting: userId=$userId, postId=$postId, status=${_statusToDb(status)}',
      );

      final response = await supabase
          .from(_tableName)
          .upsert(data, onConflict: 'user_id,post_id')
          .select()
          .single();

      debugPrint('[ProgressRepo] ✅ Upsert response: $response');

      return PosProgress.fromJson(response);
    } catch (e) {
      debugPrint('[ProgressRepo] ❌ upsertProgress error: $e');
      throw ProgressRepositoryException('Gagal update progress: $e');
    }
  }

  // ─── Inisialisasi progress default untuk user baru ───────────────────────
  Future<void> initDefaultProgress(String userId) async {
    try {
      final rows = List.generate(3, (i) {
        return {'user_id': userId, 'post_id': i + 1, 'status': 'not_started'};
      });

      debugPrint('[ProgressRepo] Initializing default progress for $userId...');

      await supabase
          .from(_tableName)
          .upsert(rows, onConflict: 'user_id,post_id');

      debugPrint('[ProgressRepo] ✅ Default progress initialized');
    } catch (e) {
      debugPrint('[ProgressRepo] ❌ initDefaultProgress error: $e');
      throw ProgressRepositoryException('Gagal inisialisasi progress: $e');
    }
  }

  // ─── Hitung jumlah pos yang selesai ──────────────────────────────────────
  Future<int> getCompletedCount(String userId) async {
    try {
      final response = await supabase
          .from(_tableName)
          .select()
          .eq('user_id', userId)
          .eq('status', 'completed');

      return response.length;
    } catch (e) {
      throw ProgressRepositoryException('Gagal menghitung progress: $e');
    }
  }

  // ─── Helper: konversi enum ke snake_case ─────────────────────────────────
  static String _statusToDb(PosProgressStatus status) {
    switch (status) {
      case PosProgressStatus.notStarted:
        return 'not_started';
      case PosProgressStatus.inProgress:
        return 'in_progress';
      case PosProgressStatus.completed:
        return 'completed';
    }
  }
}

// ─── Custom Exception ────────────────────────────────────────────────────────
class ProgressRepositoryException implements Exception {
  final String message;
  const ProgressRepositoryException(this.message);

  @override
  String toString() => 'ProgressRepositoryException: $message';
}
