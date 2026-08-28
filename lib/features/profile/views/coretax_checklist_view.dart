// =============================================================================
// coretax_checklist_view.dart
// Halaman CoreTax Checklist — daftar persiapan untuk pelaporan pajak via CoreTax.
// Menggunakan AppChecklistCard reusable widget dengan toggle checked/unchecked.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_checklist_card.dart';

// ─── Model Data Checklist ────────────────────────────────────────────────────

class ChecklistSection {
  final String title;
  final List<ChecklistItem> items;

  const ChecklistSection({required this.title, required this.items});
}

class ChecklistItem {
  final String label;
  final bool defaultChecked;

  const ChecklistItem({required this.label, this.defaultChecked = false});
}

// ─── Dummy Data ──────────────────────────────────────────────────────────────

const List<ChecklistSection> _checklistData = [
  // ── Section 1: Daftar yang Harus Disiapkan ────────────────────────────
  ChecklistSection(
    title: 'Daftar yang Harus Disiapkan',
    items: [
      ChecklistItem(label: 'NIK berstatus "padan" sebagai NPWP'),
      ChecklistItem(label: 'Akun Coretax sudah bisa diakses'),
      ChecklistItem(label: 'Kode Otorisasi DJP sudah dibuat'),
      ChecklistItem(label: 'Data profil sudah diperbarui'),
      ChecklistItem(label: 'Verifikasi dua langkah (2FA) sudah diaktifkan'),
    ],
  ),

  // ── Section 2: Tambahan untuk Karyawan ─────────────────────────────────
  ChecklistSection(
    title: 'Tambahan untuk Karyawan',
    items: [
      ChecklistItem(
        label: 'Bukti Potong 1721-A1 sudah muncul dan sesuai di akun Coretax',
      ),
      ChecklistItem(
        label:
            'Data harta dan utang per 31 Desember sudah dicek dan diperbarui',
      ),
    ],
  ),

  // ── Section 3: Tambahan untuk Pelaku Usaha/UMKM ───────────────────────
  ChecklistSection(
    title: 'Tambahan untuk Pelaku Usaha/UMKM',
    items: [
      ChecklistItem(
        label: 'KLU (kode jenis usaha) sudah diperbarui di akun Coretax',
      ),
      ChecklistItem(
        label:
            'Skema pajak yang berlaku sudah dipahami (PPh Final 0,5% atau tarif umum)',
      ),
      ChecklistItem(
        label:
            'Pemberitahuan NPPN sudah disampaikan (jika tidak pakai PPh Final UMKM)',
      ),
      ChecklistItem(
        label:
            'Surat Keterangan PP 55/2022 sudah diajukan (jika klien meminta)',
      ),
      ChecklistItem(
        label:
            'Catatan peredaran bruto bulanan dan bukti setor PPh Pasal 4 ayat (2) sudah disiapkan',
      ),
    ],
  ),
];

// ─── View ────────────────────────────────────────────────────────────────────

class CoreTaxChecklistView extends StatefulWidget {
  const CoreTaxChecklistView({super.key});

  @override
  State<CoreTaxChecklistView> createState() => _CoreTaxChecklistViewState();
}

class _CoreTaxChecklistViewState extends State<CoreTaxChecklistView> {
  /// Status checked setiap item — key = "sectionIndex-itemIndex".
  late Map<String, bool> _checkedState;

  @override
  void initState() {
    super.initState();
    // Inisialisasi state dari defaultChecked
    _checkedState = {};
    for (var s = 0; s < _checklistData.length; s++) {
      for (var i = 0; i < _checklistData[s].items.length; i++) {
        final key = '$s-$i';
        _checkedState[key] = _checklistData[s].items[i].defaultChecked;
      }
    }
  }

  void _toggleItem(String key) {
    setState(() {
      _checkedState[key] = !(_checkedState[key] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.orange50,
      body: SafeArea(
        child: Column(
          children: [
            // ═══════════════ TOP BAR ═══════════════
            _buildTopBar(context),

            // ═══════════════ SCROLLABLE CONTENT ═══════════════
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Checklist Sections ──────────────────────────────
                    for (var s = 0; s < _checklistData.length; s++) ...[
                      if (s > 0) const SizedBox(height: 20),
                      _buildSectionHeader(_checklistData[s].title),
                      const SizedBox(height: 12),
                      _buildSectionItems(s, _checklistData[s].items),
                    ],

                    const SizedBox(height: 24),

                    // ── Navigation Card "Apa Itu CoreTax?" ─────────────
                    _buildCoreTaxNavCard(context),

                    const SizedBox(height: 12),

                    // ── Disclaimer ─────────────────────────────────────
                    _buildDisclaimer(),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Top Bar ────────────────────────────────────────────────────────────────
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Row(
        children: [
          AppBackButton(onPressed: () => context.pop()),
          Expanded(
            child: Text(
              'CoreTax Checklist',
              style: AppTypography.titleLargeBold.copyWith(
                color: AppColors.orange950,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 48), // Spacer penyeimbang
        ],
      ),
    );
  }

  // ─── Section Header ─────────────────────────────────────────────────────────
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTypography.titleMediumBold.copyWith(color: AppColors.orange950),
    );
  }

  // ─── Section Items ──────────────────────────────────────────────────────────
  Widget _buildSectionItems(int sectionIndex, List<ChecklistItem> items) {
    return Column(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(height: 10),
          AppChecklistCard(
            title: items[i].label,
            isChecked: _checkedState['$sectionIndex-$i'] ?? false,
            onTap: () => _toggleItem('$sectionIndex-$i'),
          ),
        ],
      ],
    );
  }

  // ─── Navigation Card "Apa Itu CoreTax?" ─────────────────────────────────────
  Widget _buildCoreTaxNavCard(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.apaItuCoretax),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.green200, // Hijau pastel sage
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Apa Itu CoreTax?',
                style: AppTypography.titleMediumBold.copyWith(
                  color: AppColors.green900,
                ),
              ),
            ),
            Icon(Icons.chevron_right, size: 24, color: AppColors.green900),
          ],
        ),
      ),
    );
  }

  // ─── Disclaimer ─────────────────────────────────────────────────────────────
  Widget _buildDisclaimer() {
    return Text(
      'Proses pelaporan dan aktivasi akun dilakukan di situs resmi CoreTax, bukan di aplikasi Pajarin.',
      style: AppTypography.bodySmallSemiBold.copyWith(
        color: AppColors.orange950,
      ),
      textAlign: TextAlign.center,
    );
  }
}
