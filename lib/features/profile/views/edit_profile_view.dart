// =============================================================================
// edit_profile_view.dart
// Halaman "Ubah Profil & Data Diri" — form untuk memperbarui data profil user.
// Menggunakan AppTextField dengan modal bottom sheet picker untuk pekerjaan
// dan penghasilan, terintegrasi dengan Supabase via ProfileRepository.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_radio_option.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../viewmodels/edit_profile_viewmodel.dart';

class EditProfileView extends ConsumerStatefulWidget {
  const EditProfileView({super.key});

  @override
  ConsumerState<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _jobController = TextEditingController();
  final _incomeController = TextEditingController();

  // ── Opsi Dropdown ──────────────────────────────────────────────────────
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

  @override
  void initState() {
    super.initState();
    _populateFromProfile();
  }

  void _populateFromProfile() {
    final user = ref.read(authViewModelProvider).user;
    if (user != null) {
      _nameController.text = user.name;
      _emailController.text = user.email;
      _jobController.text = user.jobTitle ?? '';
      _incomeController.text = _incomeToRange(user.estimatedIncome);
    }
  }

  String _incomeToRange(double? income) {
    if (income == null) return '';
    if (income < 3000000) return '< Rp 3.000.000';
    if (income <= 5000000) return 'Rp 3 juta - Rp 5 juta';
    if (income <= 10000000) return 'Rp 5 juta - Rp 10 juta';
    if (income <= 20000000) return 'Rp 10 juta - Rp 20 juta';
    return '> Rp 20 juta';
  }

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

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _jobController.dispose();
    _incomeController.dispose();
    super.dispose();
  }

  // ══════════════════════════════════════════════════════════════════
  // Bottom Sheet Modal Picker — sama persis dengan complete_profile
  // ══════════════════════════════════════════════════════════════════
  Future<void> _openSelectSheet({
    required String title,
    required List<String> options,
    required String currentValue,
    required ValueChanged<String> onSelect,
  }) {
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
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(sheetContext).size.height * 0.7,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ── Title ────────────────────────────────────────
                      Text(
                        title,
                        style: AppTypography.headlineSmallBold.copyWith(
                          color: AppColors.orange950,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),

                      // ── Options List ────────────────────────────────
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

                      // ── Buttons ─────────────────────────────────────
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

  Future<void> _handleSubmit() async {
    FocusScope.of(context).unfocus();

    final authState = ref.read(authViewModelProvider);
    final userId = authState.user?.id;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: User tidak ditemukan.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final success = await ref
        .read(editProfileViewModelProvider.notifier)
        .updateProfile(
          userId: userId,
          name: _nameController.text.trim(),
          jobTitle: _jobController.text.isNotEmpty ? _jobController.text : null,
          estimatedIncome: _incomeController.text.isNotEmpty
              ? _parseIncome(_incomeController.text)
              : null,
        );

    if (!mounted) return;

    if (success) {
      await ref.read(authViewModelProvider.notifier).refreshProfile();
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil berhasil diperbarui!'),
          backgroundColor: AppColors.green600,
        ),
      );
      context.pop();
    } else {
      final error = ref.read(editProfileViewModelProvider).message;
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: AppColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final editState = ref.watch(editProfileViewModelProvider);
    final user = ref.watch(authViewModelProvider).user;
    final initial = (user?.name ?? 'U').isNotEmpty
        ? (user?.name ?? 'U')[0].toUpperCase()
        : '?';

    return Scaffold(
      backgroundColor: AppColors.orange50,
      body: SafeArea(
        child: Column(
          children: [
            // ═══════════════ SCROLLABLE CONTENT ═══════════════
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Top Bar ──────────────────────────────────────
                    _buildTopBar(),

                    const SizedBox(height: 24),

                    // ── Profile Picture Header ───────────────────────
                    _buildProfileHeader(initial),

                    const SizedBox(height: 24),

                    // ── Section Data Pribadi ────────────────────────
                    Text(
                      'Data Pribadi',
                      style: AppTypography.titleMediumBold.copyWith(
                        color: AppColors.orange950,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ── Form Fields ──────────────────────────────────
                    _buildFormFields(),
                  ],
                ),
              ),
            ),

            // ═══════════════ BOTTOM BUTTON ═══════════════
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: AppButton(
                label: editState.status == EditProfileStatus.loading
                    ? 'Menyimpan...'
                    : 'Simpan Perubahan',
                onPressed: editState.status == EditProfileStatus.loading
                    ? null
                    : _handleSubmit,
                width: double.infinity,
                height: 52,
                isLoading: editState.status == EditProfileStatus.loading,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Top Bar (centered title — sama seperti FAQ Pajak) ────────────────
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          // ── Back Button ───────────────────────────────
          AppBackButton(onPressed: () => context.pop()),

          // ── Title (centered) ─────────────────────────
          Expanded(
            child: Text(
              'Ubah Profil & Data Diri',
              style: AppTypography.titleLargeBold.copyWith(
                color: AppColors.orange950,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // ── Spacer penyeimbang (lebar = AppBackButton) ─
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  // ─── Profile Picture Header (warna sama seperti ProfileView) ──────────
  Widget _buildProfileHeader(String initial) {
    return Center(
      child: Column(
        children: [
          // ── Avatar (orange500 — sama seperti profile_view) ───────
          CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.orange500,
            child: Text(
              initial,
              style: const TextStyle(
                fontSize: 40,
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // ── Ubah Foto Profil Button ─────────────────────────────
          GestureDetector(
            onTap: () {
              // Dummy — fitur ubah foto belum dibuat
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.green100, // Hijau pastel sage
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.edit_outlined,
                    size: 20,
                    color: AppColors.orange950,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Ubah Foto Profil',
                    style: AppTypography.titleSmallBold.copyWith(
                      color: AppColors.orange950,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Form Fields (icons & trailing sama seperti comprof) ──────────────
  Widget _buildFormFields() {
    return Column(
      children: [
        // ── Nama ───────────────────────────────────────────────────
        AppTextField(
          controller: _nameController,
          hintText: 'Nama Pengguna',
          prefixIcon: Icons.person_outline,
          width: double.infinity,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 12),

        // ── Email (readonly) ──────────────────────────────────────
        AppTextField(
          controller: _emailController,
          hintText: 'Email',
          prefixIcon: Icons.email_outlined,
          width: double.infinity,
          readOnly: true,
          showCursor: false,
        ),
        const SizedBox(height: 12),

        // ── Pekerjaan (popup picker — icon sama seperti comprof) ──
        AppTextField(
          controller: _jobController,
          hintText: 'Pekerjaan Saat Ini',
          prefixIcon: Icons.business_center_outlined,
          readOnly: true,
          showCursor: false,
          width: double.infinity,
          trailing: const Icon(
            Icons.keyboard_arrow_down,
            size: 24,
            color: AppColors.orange950,
          ),
          onTap: () => _openSelectSheet(
            title: 'Pekerjaan Saat Ini',
            options: _jobOptions,
            currentValue: _jobController.text,
            onSelect: (value) => setState(() => _jobController.text = value),
          ),
        ),
        const SizedBox(height: 12),

        // ── Penghasilan (popup picker — icon sama seperti comprof) ─
        AppTextField(
          controller: _incomeController,
          hintText: 'Range Penghasilan',
          prefixIcon: Icons.payments_outlined,
          readOnly: true,
          showCursor: false,
          width: double.infinity,
          trailing: const Icon(
            Icons.keyboard_arrow_down,
            size: 24,
            color: AppColors.orange950,
          ),
          onTap: () => _openSelectSheet(
            title: 'Range Penghasilan',
            options: _incomeOptions,
            currentValue: _incomeController.text,
            onSelect: (value) => setState(() => _incomeController.text = value),
          ),
        ),
      ],
    );
  }
}
