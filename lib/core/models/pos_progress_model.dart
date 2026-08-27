// =============================================================================
// pos_progress_model.dart
// Model untuk progress user terhadap setiap pos pembelajaran.
// Sinkron dengan tabel `user_progress` di Supabase:
//   - id (serial), user_id (uuid), post_id (integer)
//   - status (not_started / in_progress / completed)
//   - quiz_score (integer), updated_at (timestamptz)
// =============================================================================

/// Status progress user terhadap satu pos
enum PosProgressStatus { notStarted, inProgress, completed }

/// Konversi enum ke string snake_case untuk Supabase
String _statusToDb(PosProgressStatus status) {
  switch (status) {
    case PosProgressStatus.notStarted:
      return 'not_started';
    case PosProgressStatus.inProgress:
      return 'in_progress';
    case PosProgressStatus.completed:
      return 'completed';
  }
}

/// Model progress satu pos untuk satu user
class PosProgress {
  final int? id; // serial primary key
  final String userId;
  final int postId; // post_id = pos number (1, 2, 3)
  final PosProgressStatus status;
  final int quizScore;
  final DateTime? updatedAt;

  const PosProgress({
    this.id,
    required this.userId,
    required this.postId,
    this.status = PosProgressStatus.notStarted,
    this.quizScore = 0,
    this.updatedAt,
  });

  /// Konversi dari JSON Supabase (tabel user_progress)
  factory PosProgress.fromJson(Map<String, dynamic> json) {
    return PosProgress(
      id: json['id'] as int?,
      userId: json['user_id'] as String,
      postId: json['post_id'] as int,
      status: _parseStatus(json['status'] as String?),
      quizScore: (json['quiz_score'] as num?)?.toInt() ?? 0,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  /// Konversi ke JSON untuk Supabase
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'post_id': postId,
      'status': _statusToDb(status),
      'quiz_score': quizScore,
    };
  }

  /// Parse status dari string snake_case
  static PosProgressStatus _parseStatus(String? status) {
    switch (status) {
      case 'in_progress':
        return PosProgressStatus.inProgress;
      case 'completed':
        return PosProgressStatus.completed;
      default:
        return PosProgressStatus.notStarted;
    }
  }

  /// Copy with
  PosProgress copyWith({PosProgressStatus? status, int? quizScore}) {
    return PosProgress(
      id: id,
      userId: userId,
      postId: postId,
      status: status ?? this.status,
      quizScore: quizScore ?? this.quizScore,
      updatedAt: DateTime.now(),
    );
  }
}

/// Label tampilan untuk setiap status
String posProgressStatusLabel(PosProgressStatus status) {
  switch (status) {
    case PosProgressStatus.notStarted:
      return 'Belum Dipelajari';
    case PosProgressStatus.inProgress:
      return 'Sedang Dipelajari';
    case PosProgressStatus.completed:
      return 'Sudah Dipelajari';
  }
}
