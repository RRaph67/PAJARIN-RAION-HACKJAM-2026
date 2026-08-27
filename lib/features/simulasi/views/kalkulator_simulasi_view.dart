// =============================================================================
// kalkulator_simulasi_view.dart
// Halaman kalkulator simulasi pajak.
// Struktur: HeaderFrame → InputFrame → TipsFrame → Button.
// Status PTKP & Tanggungan dibuka via popup bottom sheet radio button.
// =============================================================================

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_radio_option.dart';
import '../../../core/widgets/app_text_field.dart';

class KalkulatorSimulasiView extends StatefulWidget {
  const KalkulatorSimulasiView({super.key});

  @override
  State<KalkulatorSimulasiView> createState() => _KalkulatorSimulasiViewState();
}

class _KalkulatorSimulasiViewState extends State<KalkulatorSimulasiView> {
  final _salaryController = TextEditingController();
  final _ptkpController = TextEditingController();
  final _tanggunganController = TextEditingController();

  // ── Opsi Dropdown ──────────────────────────────────────────────────────
  static const List<String> _ptkpOptions = ['Belum Menikah', 'Sudah Menikah'];

  static const List<String> _tanggunganOptions = [
    'Tidak Ada Tanggungan',
    '1 Tanggungan',
    '2 Tanggungan',
  ];

  @override
  void dispose() {
    _salaryController.dispose();
    _ptkpController.dispose();
    _tanggunganController.dispose();
    super.dispose();
  }

  /// Cek apakah semua field sudah terisi
  bool get _isFormFilled =>
      _salaryController.text.trim().isNotEmpty &&
      _ptkpController.text.isNotEmpty &&
      _tanggunganController.text.isNotEmpty;

  void _onFieldChanged(_) {
    setState(() {});
  }

  /// Konversi string tanggungan → jumlah numeric
  int _parseTanggungan(String value) {
    switch (value) {
      case 'Tidak Ada Tanggungan':
        return 0;
      case '1 Tanggungan':
        return 1;
      case '2 Tanggungan':
        return 2;
      default:
        return 0;
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // Bottom Sheet Popup — mirip dengan comprof_view.
  // ══════════════════════════════════════════════════════════════════════════
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

  /// Navigasi ke loading → delay 3 detik → hasil kalkulasi
  void _submitForm() {
    if (!_isFormFilled) return;

    final gaji =
        double.tryParse(
          _salaryController.text.replaceAll('.', '').replaceAll(',', ''),
        ) ??
        0;
    final ptkp = _ptkpController.text;
    final tanggungan = _parseTanggungan(_tanggunganController.text);

    // Navigasi ke loading page
    context.push(
      AppRoutes.simulasiLoading,
      extra: {'gaji': gaji, 'ptkp': ptkp, 'tanggungan': tanggungan},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.orange50,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 56),
              // ═══════════════ HEADER FRAME ═══════════════
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Column(
                  children: [
                    // ── Logo ───────────────────────────────────────────
                    SvgPicture.asset(
                      'assets/svg/logo_square_outline.svg',
                      width: 60,
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 16),

                    // ── Title ──────────────────────────────────────────
                    Text(
                      'Simulasi Hitungan Pajak',
                      style: AppTypography.displaySmallExtraBold.copyWith(
                        color: AppColors.orange900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    // ── Subtitle ───────────────────────────────────────
                    Text(
                      'Biar kamu nggak bingung lagi~',
                      style: AppTypography.headlineSmallSemiBold.copyWith(
                        color: AppColors.orange900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // ═══════════════ INPUT FRAME ═══════════════
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 0, bottom: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Gaji Kamu ──────────────────────────────────────
                    _buildLabel('Gaji Kamu'),
                    const SizedBox(height: 12),
                    AppTextField(
                      controller: _salaryController,
                      hintText: 'Contoh: 5000000',
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      onChanged: _onFieldChanged,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Gaji wajib diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // ── Status PTKP ────────────────────────────────────
                    _buildLabel('Status PTKP'),
                    const SizedBox(height: 12),
                    AppTextField(
                      controller: _ptkpController,
                      hintText: 'Pilih Status PTKP',
                      readOnly: true,
                      showCursor: false,
                      trailing: const Icon(
                        Icons.keyboard_arrow_down,
                        size: 24,
                        color: AppColors.orange950,
                      ),
                      onTap: () => _openSelectSheet(
                        title: 'Status PTKP',
                        options: _ptkpOptions,
                        currentValue: _ptkpController.text,
                        onSelect: (value) =>
                            setState(() => _ptkpController.text = value),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ── TextField Tanggungan (Tanpa Label) ──────────────
                    AppTextField(
                      controller: _tanggunganController,
                      hintText: 'Pilih Jumlah Tanggungan',
                      readOnly: true,
                      showCursor: false,
                      trailing: const Icon(
                        Icons.keyboard_arrow_down,
                        size: 24,
                        color: AppColors.orange950,
                      ),
                      onTap: () => _openSelectSheet(
                        title: 'Jumlah Tanggungan',
                        options: _tanggunganOptions,
                        currentValue: _tanggunganController.text,
                        onSelect: (value) =>
                            setState(() => _tanggunganController.text = value),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Tips Frame ─────────────────────────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.orange200,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.stars,
                            size: 16,
                            color: AppColors.orange950,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Data ini diisi otomatis berdasarkan profilmu.',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.orange950,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ═══════════════ BUTTON ═══════════════
              AppButton(
                label: 'Hitung Pajaknya',
                icon: Icons.arrow_forward,
                iconPosition: IconPosition.right,
                iconSize: 16,
                enabled: _isFormFilled,
                onPressed: _submitForm,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper: Label text rata kiri untuk field input
  Widget _buildLabel(String text) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        text,
        style: AppTypography.titleLargeBold.copyWith(
          color: AppColors.orange950,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }
}
