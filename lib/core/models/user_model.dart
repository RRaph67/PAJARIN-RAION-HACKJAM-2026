// =============================================================================
// user_model.dart
// Model data pengguna yang merepresentasikan tabel `public.users` di Supabase.
// Kolom: id, name, email, user_type, job_title, estimated_income
// =============================================================================

class UserModel {
  final String id;
  final String name;
  final String email;
  final String userType;
  final String? jobTitle;
  final double? estimatedIncome;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.userType,
    this.jobTitle,
    this.estimatedIncome,
  });

  // ─── Factory: buat UserModel dari JSON Supabase ──────────────────────────
  // Supabase mengembalikan data sebagai Map<String, dynamic>.
  // factory ini mengubahnya menjadi objek UserModel yang type-safe.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      userType: json['user_type'] as String,
      jobTitle: json['job_title'] as String?,
      estimatedIncome: json['estimated_income'] != null
          ? (json['estimated_income'] as num).toDouble()
          : null,
    );
  }

  // ─── Method: ubah UserModel ke JSON untuk dikirim ke Supabase ────────────
  // Digunakan saat insert atau update data di tabel users.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'user_type': userType,
      'job_title': jobTitle,
      'estimated_income': estimatedIncome,
    };
  }

  // ─── Method: salin dengan perubahan (copyWith) ───────────────────────────
  // Berguna untuk update sebagian field tanpa membuat objek baru dari nol.
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? userType,
    String? jobTitle,
    double? estimatedIncome,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      userType: userType ?? this.userType,
      jobTitle: jobTitle ?? this.jobTitle,
      estimatedIncome: estimatedIncome ?? this.estimatedIncome,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, '
        'userType: $userType, jobTitle: $jobTitle, '
        'estimatedIncome: $estimatedIncome)';
  }
}
