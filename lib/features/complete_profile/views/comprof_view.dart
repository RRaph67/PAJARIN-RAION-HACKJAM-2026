// =============================================================================
// comprof_view.dart
// Halaman pelengkapan profil (RegistrationProcess).
// Struktur: ButtonBack → TitleFrame → InputFrame → Button.
// Field pekerjaan/penghasilan/pemahaman pajak membuka bottom sheet radio button.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_radio_option.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../viewmodels/comprof_viewmodel.dart';

class LinkupView extends ConsumerStatefulWidget {
  const LinkupView({super.key});

  @override
  ConsumerState<LinkupView> createState() => _LinkupViewState();
}

class _LinkupViewState extends ConsumerState<LinkupView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _jobController = TextEditingController();
  final _incomeController = TextEditingController();
  final _taxLevelController = TextEditingController();

  // ── Opsi Dropdown ──────────────────────────────────────────────
  static const List<String> _jobOptions = [
    'Karyawan Swasta',
    'Pegawai Negeri/BUMN',
    'Freelancer/Pekerja Lepas',
    'Wiraswasta/Pemilik Usaha',
    'Pelajar/Mahasiswa',
    'Lainnya',
  ];

  static const List<String> _incomeOptions = [
    '< Rp 3.000.000',
    'Rp 3 juta - Rp 5 juta',
    'Rp 5 juta - Rp 10 juta',
    'Rp 10 juta - Rp 20 juta',
    '> Rp 20 juta',
  ];

  static const List<String> _taxLevelOptions = [
    'Belum Paham',
    'Cukup Paham',
    'Sudah Paham',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _jobController.dispose();
    _incomeController.dispose();
    _taxLevelController.dispose();
    super.dispose();
  }

  /// Cek apakah semua field sudah terisi
  bool get _isFormFilled =>
      _nameController.text.trim().isNotEmpty &&
      _jobController.text.isNotEmpty &&
      _incomeController.text.isNotEmpty &&
      _taxLevelController.text.isNotEmpty;

  void _onFieldChanged(_) {
    setState(() {});
  }

  /// Konversi range penghasilan string → numeric (rata-rata range)
  double _parseIncome(String range) {
    switch (range) {
      case '< Rp 3.000.000':
        return 2000000;
      case 'Rp 3 juta - Rp 5 juta':
        return 4000000;
      case 'Rp 5 juta - Rp 10 juta':
        return 7500000;
      case 'Rp 10 juta - Rp 20 juta':
        return 15000000;
      case '> Rp 20 juta':
        return 25000000;
      default:
        return 0;
    }
  }

  // ══════════════════════════════════════════════════════════════════
  // Bottom Sheet Popup — muncul dari bawah, berisi opsi radio button.
  // Tinggi frame menyesuaikan isi; opsi bisa di-scroll jika banyak.
  // Pilihan baru diterapkan saat user menekan "Pilih".
  // ══════════════════════════════════════════════════════════════════
  Future<void> _openSelectSheet({
    required String title,
    required List<String> options,
    required String currentValue,
    required ValueChanged<String> onSelect,
  }) {
    // Pilihan sementara di dalam popup — belum diterapkan ke form
    String tempSelected = currentValue;

    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.orange50,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            return SafeArea(
              child: ConstrainedBox(
                // Maksimal 70% layar — jika opsi lebih panjang, list di-scroll
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(sheetContext).size.height * 0.7,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        title,
                        style: AppTypography.headlineSmallBold.copyWith(
                          color: AppColors.orange950,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            children: options.map((option) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: AppRadioOption(
                                  label: option,
                                  selected: option == tempSelected,
                                  onTap: () => setSheetState(
                                    () => tempSelected = option,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ── FrameButtonPopup ────────────────────────────────
                      Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              label: 'Batal',
                              variant: ButtonVariant.secondary,
                              onPressed: () => Navigator.of(sheetContext).pop(),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: AppButton(
                              label: 'Pilih',
                              enabled: tempSelected.isNotEmpty,
                              onPressed: () {
                                onSelect(tempSelected);
                                Navigator.of(sheetContext).pop();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    // Ambil user ID: prioritas dari auth state, fallback ke session Supabase
    // (berguna jika app di-restart — state Riverpod hilang tapi session masih ada)
    final authState = ref.read(authViewModelProvider);
    final userId =
        authState.user?.id ?? Supabase.instance.client.auth.currentUser?.id;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: User tidak ditemukan'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    ref
        .read(linkupViewModelProvider.notifier)
        .completeProfile(
          userId: userId,
          name: _nameController.text.trim(),
          jobTitle: _jobController.text,
          estimatedIncome: _parseIncome(_incomeController.text),
          taxUnderstandingLevel: _taxLevelController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final linkupState = ref.watch(linkupViewModelProvider);

    // Dengarkan perubahan state → navigasi atau tampilkan error
    ref.listen<LinkupState>(linkupViewModelProvider, (previous, next) {
      if (next.status == LinkupStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message ?? 'Profil berhasil dilengkapi!'),
            backgroundColor: AppColors.success,
          ),
        );
        context.go(AppRoutes.onboardingIntro);
      }

      if (next.status == LinkupStatus.error && next.message != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message!),
            backgroundColor: AppColors.error,
          ),
        );
        ref.read(linkupViewModelProvider.notifier).resetStatus();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.orange50,
      body: SafeArea(
        // ── FrameUtama: RegistrationProcess ────────────────────────────────
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              // Gap vertical auto antara konten atas dan button bawah
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ═══════════════ KONTEN ATAS ═══════════════
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── FrameButtonBack ────────────────────────────────
                    GestureDetector(
                      onTap: () => context.go(AppRoutes.login),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.green600,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          size: 24,
                          color: AppColors.green50,
                        ),
                      ),
                    ),
                    const SizedBox(height: 95),

                    // ── TitleFrame ─────────────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          Text(
                            'Lengkapi Profil Kamu!',
                            style: AppTypography.displayMediumExtraBold
                                .copyWith(color: AppColors.orange950),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Lengkapi data untuk pengalaman lebih personal.',
                            style: AppTypography.headlineSmallMedium.copyWith(
                              color: AppColors.orange950,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 95),

                    // ── InputFrame ─────────────────────────────────────
                    Column(
                      children: [
                        // Nama Pengguna (ketik manual)
                        AppTextField(
                          controller: _nameController,
                          hintText: 'Nama Pengguna',
                          prefixIcon: Icons.person_outline,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          onChanged: _onFieldChanged,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Nama wajib diisi';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),

                        // Pekerjaan Saat Ini (pilih via popup)
                        AppTextField(
                          controller: _jobController,
                          hintText: 'Pekerjaan Saat Ini',
                          prefixIcon: Icons.business_center_outlined,
                          readOnly: true,
                          showCursor: false,
                          trailing: const Icon(
                            Icons.keyboard_arrow_down,
                            size: 24,
                            color: AppColors.orange950,
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Pekerjaan wajib dipilih'
                              : null,
                          onTap: () => _openSelectSheet(
                            title: 'Pekerjaan Saat Ini',
                            options: _jobOptions,
                            currentValue: _jobController.text,
                            onSelect: (value) =>
                                setState(() => _jobController.text = value),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Range Penghasilan (pilih via popup)
                        AppTextField(
                          controller: _incomeController,
                          hintText: 'Range Penghasilan',
                          prefixIcon: Icons.payments_outlined,
                          readOnly: true,
                          showCursor: false,
                          trailing: const Icon(
                            Icons.keyboard_arrow_down,
                            size: 24,
                            color: AppColors.orange950,
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Range penghasilan wajib dipilih'
                              : null,
                          onTap: () => _openSelectSheet(
                            title: 'Range Penghasilan',
                            options: _incomeOptions,
                            currentValue: _incomeController.text,
                            onSelect: (value) =>
                                setState(() => _incomeController.text = value),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Tingkat Pemahaman Pajak (pilih via popup)
                        AppTextField(
                          controller: _taxLevelController,
                          hintText: 'Tingkat Pemahaman Pajak',
                          prefixIcon: Icons.psychology_outlined,
                          readOnly: true,
                          showCursor: false,
                          trailing: const Icon(
                            Icons.keyboard_arrow_down,
                            size: 24,
                            color: AppColors.orange950,
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Tingkat pemahaman wajib dipilih'
                              : null,
                          onTap: () => _openSelectSheet(
                            title: 'Tingkat Pemahaman Pajak',
                            options: _taxLevelOptions,
                            currentValue: _taxLevelController.text,
                            onSelect: (value) => setState(
                              () => _taxLevelController.text = value,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // ═══════════════ FRAME BAWAH (gap auto) ═══════════════
                AppButton(
                  label: 'Simpan',
                  isLoading: linkupState.status == LinkupStatus.loading,
                  enabled: _isFormFilled,
                  onPressed: _submitForm,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
