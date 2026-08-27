// =============================================================================
// module_model.dart
// Model data untuk modul pembelajaran pajak.
// Berisi enum status, model data, dan mock data hardcode.
// =============================================================================

/// Status modul bagi user
enum ModuleStatus { notStarted, inProgress, completed }

/// Label tampilan untuk setiap status
String moduleStatusLabel(ModuleStatus status) {
  switch (status) {
    case ModuleStatus.notStarted:
      return 'Belum Dipelajari';
    case ModuleStatus.inProgress:
      return 'Sedang Dipelajari';
    case ModuleStatus.completed:
      return 'Sudah Dipelajari';
  }
}

/// Model satu modul pembelajaran
class ModuleModel {
  final int id;
  final String title;
  final String description;
  final ModuleStatus status;

  const ModuleModel({
    required this.id,
    required this.title,
    required this.description,
    this.status = ModuleStatus.notStarted,
  });

  ModuleModel copyWith({ModuleStatus? status}) {
    return ModuleModel(
      id: id,
      title: title,
      description: description,
      status: status ?? this.status,
    );
  }
}

// ─── Mock Data ────────────────────────────────────────────────────────────────
// Hardcode semua modul di sini. Untuk saat ini semua status notStarted.
// Nanti bisa diganti berdasarkan progress user dari Supabase.
const List<ModuleModel> mockModules = [
  ModuleModel(
    id: 1,
    title: 'Modul PPh 21',
    description:
        'Pelajari cara menghitung Pajak Penghasilan Pasal 21 untuk '
        'pegawai tetap, penerima pensiun, dan penerima penghasilan lainnya.',
    status: ModuleStatus.notStarted,
  ),
  ModuleModel(
    id: 2,
    title: 'Modul PPh 23',
    description:
        'Pahami mekanisme pemotongan PPh 23 atas sewa, jasa, dan '
        'penghasilan lain yang dikenakan pemotongan.',
    status: ModuleStatus.notStarted,
  ),
  ModuleModel(
    id: 3,
    title: 'Modul PPh Final',
    description:
        'Kenali berbagai jenis Pajak Penghasilan Final untuk UMKM, '
        'jual beli saham, dan penghasilan lainnya.',
    status: ModuleStatus.notStarted,
  ),
];
