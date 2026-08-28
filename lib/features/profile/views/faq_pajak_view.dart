// =============================================================================
// faq_pajak_view.dart
// Halaman FAQ Pajak — menampilkan daftar pertanyaan umum tentang pajak.
// Menggunakan AppFaqCard reusable widget dengan toggle expand/collapse.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_faq_card.dart';

// ─── Model Data FAQ ──────────────────────────────────────────────────────────

class FaqItem {
  final String question;
  final String answer;
  final String? source;
  final bool initiallyExpanded;

  const FaqItem({
    required this.question,
    required this.answer,
    this.source,
    this.initiallyExpanded = false,
  });
}

// ─── Dummy Data ──────────────────────────────────────────────────────────────

const List<FaqItem> _faqData = [
  FaqItem(
    question:
        'NIK-ku katanya udah otomatis jadi NPWP, tapi aku belum pernah daftar NPWP. Apa itu masalah?',
    answer:
        'Nggak masalah sama sekali! Mulai tahun 2024, Direktorat Jenderal Pajak (DJP) menerapkan kebijakan dimana setiap Warga Negara Indonesia (WNI) yang memiliki NIK (Nomor Induk Kependudukan) otomatis mendapatkan NPWP (Nomor Pokok Wajib Pajak) 16 digit. Jadi NIK-mu langsung berfungsi sebagai NPWP tanpa perlu daftar lagi. Kebijakan ini bertujuan untuk memudahkan administrasi perpajakan dan memperluas basis wajib pajak di Indonesia.',
    source:
        'Sumber: PMK No. 112/PMK.03/2022 tentang NPWP bagi Wajib Pajak Orang Pribadi',
    initiallyExpanded: true,
  ),
  FaqItem(
    question:
        'Berapa lama aku harus menyimpan bukti potong dan dokumen pajak lainnya?',
    answer:
        'Berdasarkan peraturan perpajakan yang berlaku di Indonesia, kamu wajib menyimpan bukti potong, faktur pajak, dan dokumen pajak lainnya selama minimal 10 tahun sejak tanggal yang tercantum dalam dokumen tersebut. Penyimpanan ini penting sebagai bukti pendukung jika sewaktu-waktu DJP melakukan pemeriksaan pajak. Disarankan untuk menyimpan secara digital (scan/foto) sebagai backup.',
    source:
        'Sumber: Pasal 13 ayat (4) UU KUP (Ketentuan Umum dan Tata Cara Perpajakan)',
  ),
  FaqItem(
    question:
        'Aku baru pertama kali kerja. Apa aku otomatis wajib lapor SPT Tahunan?',
    answer:
        'Ya, sebagai karyawan yang sudah memiliki penghasilan, kamu wajib melaporkan SPT Tahunan PPh Orang Pribadi. Batas waktu pelaporannya adalah paling lambat 31 Maret setiap tahunnya untuk penghasilan tahun sebelumnya. Namun, jika penghasilan bruto kamu selama setahun tidak melebihi PTKP (Penghasilan Tidak Kena Pajak), kamu tetap wajib lapor tapi tidak akan dikenakan pajak. Untuk karyawan dengan penghasilan di bawah PTKP, perusahaan biasanya akan menerbitkan Bukti Pemotongan PPh 21.',
    source: 'Sumber: Pasal 2 ayat (1) UU PPh Pasal 21 & UU KUP',
  ),
  FaqItem(
    question: 'Aku baru pindah kerja. Ada yang perlu diurus soal pajak?',
    answer:
        'Saat pindah kerja, ada beberapa hal yang perlu diperhatikan: (1) Pastikan perusahaan lama sudah menerbitkan Bukti Pemotongan PPh 21 untuk masa kerja kamu di sana. (2) Sampaikan data pajak kamu ke perusahaan baru, termasuk penghasilan dari pekerjaan sebelumnya di tahun berjalan. (3) Perusahaan baru akan menghitung ulang PPh 21 berdasarkan penghasilan kumulatif dari semua sumber. (4) Simpan semua bukti potong dari kedua perusahaan untuk keperluan pelaporan SPT Tahunan.',
    source:
        'Sumber: UU PPh Pasal 21 & Peraturan Dirjen Pajak tentang Pemotongan PPh 21',
  ),
  FaqItem(
    question:
        'Aku kerja kantoran tapi juga punya usaha sampingan kecil-kecilan. Gimana pajaknya?',
    answer:
        'Sebagai karyawan sekaligus pengusaha kecil, kamu memiliki kewajiban perpajakan ganda: (1) Penghasilan dari pekerjaan sebagai karyawan akan dipotong PPh 21 oleh perusahaan. (2) Penghasilan dari usaha sampingan dikenakan PPh Final sebesar 0,5% dari omset per bulan (untuk UMKM dengan omset di bawah Rp4,8 miliar per tahun). (3) Namun, kamu bisa memilih untuk tidak dikenakan PPh Final dan menggabungkan penghasilan usaha ke dalam SPT Tahunan. Pilih yang paling menguntungkan berdasarkan jumlah penghasilanmu.',
    source:
        'Sumber: PP No. 23/2018 tentang PPh Final atas Penghasilan dari Usaha yang Diterima atau Diperoleh Wajib Pajak...',
  ),
  FaqItem(
    question:
        'Kalau sekarang nggak punya penghasilan sama sekali, NPWP-ku gimana? Dihapus otomatis?',
    answer:
        'NPWP tidak akan dihapus secara otomatis meskipun kamu tidak memiliki penghasilan. NPWP tetap aktif selama kamu masih berstatus sebagai Warga Negara Indonesia. Namun, jika kamu tidak memiliki penghasilan, kamu tidak memiliki kewajiban untuk membayar pajak. Yang perlu kamu lakukan adalah tetap melaporkan SPT Tahunan dengan status "Tidak Ada Penghasilan" atau "Nihil". Jika dalam 2 tahun berturut-turut kamu tidak melapor, NPWP kamu bisa ditetapkan sebagai NPWP yang tidak aktif.',
    source:
        'Sumber: UU No. 7 Tahun 2021 tentang Harmonisasi Peraturan Perpajakan (HPP)',
  ),
];

// ─── View ────────────────────────────────────────────────────────────────────

class FaqPajakView extends StatelessWidget {
  const FaqPajakView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.orange50,
      body: SafeArea(
        child: Column(
          children: [
            // ═══════════════ TOP BAR ═══════════════
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              child: Row(
                children: [
                  // ── Back Button ───────────────────────────────
                  AppBackButton(onPressed: () => context.pop()),

                  // ── Title (centered) ─────────────────────────
                  Expanded(
                    child: Text(
                      'FAQ Pajak',
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
            ),

            // ═══════════════ FAQ LIST ═══════════════
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _faqData.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final faq = _faqData[index];
                  return AppFaqCard(
                    question: faq.question,
                    answer: faq.answer,
                    source: faq.source,
                    initiallyExpanded: faq.initiallyExpanded,
                  );
                },
              ),
            ),

            // ── Bottom padding ──────────────────────────────
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
