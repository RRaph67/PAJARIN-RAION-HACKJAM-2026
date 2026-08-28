// =============================================================================
// pos_data_model.dart
// Model data untuk pos pembelajaran + mock data + status UI config.
// Dipisahkan dari view untuk maintainability & reusability.
// =============================================================================

import 'package:flutter/material.dart';

import '../../../core/models/pos_progress_model.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_status_chip.dart';

// ─── Data Model untuk setiap Pos ─────────────────────────────────────────────

class PosData {
  final int number;
  final String moduleName;
  final String title;
  final String description;
  final String imagePath;

  const PosData({
    required this.number,
    required this.moduleName,
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

// ─── Mock Data ───────────────────────────────────────────────────────────────

const List<PosData> posListData = [
  PosData(
    number: 1,
    moduleName: 'Modul PPh 21',
    title: 'Lah, Pajak Ini Jadi Urusanku Sekarang?',
    description:
        'Pajak Penghasilan Pasal 21 adalah pemotongan pajak atas penghasilan '
        'yang diterima oleh pegawai, baik negeri maupun swasta. Di pos ini, '
        'kamu akan memahami apa itu PPh 21, siapa yang wajib memotong, '
        'serta cara menghitungnya dari dasar hingga praktik.',
    imagePath: 'assets/svg/maskot_mikir.svg',
  ),
  PosData(
    number: 2,
    moduleName: 'Modul PTKP',
    title: 'Gaji Kita Sama, Tapi Potongannya Beda. Kok Bisa?',
    description:
        'Penghasilan Tidak Kena Pajak (PTKP) menentukan berapa besar '
        'potongan pajak dari gaji kita. Semakin banyak tanggungan, semakin '
        'besar PTKP, dan semakin kecil pajak yang harus dibayar. '
        'Yuk pahami cara menentukan PTKP yang benar!',
    imagePath: 'assets/svg/maskot_takut.svg',
  ),
  PosData(
    number: 3,
    moduleName: 'Modul SPT',
    title: 'Ah Iya, Belum Bayar Pajak! Tapi Gimana Cara Hitungnya?',
    description:
        'SPT Tahunan PPh Orang Pribadi adalah laporan pajak tahunan yang '
        'wajib disetorkan. Di pos terakhir ini, kamu akan belajar '
        'cara mengisi SPT dari awal hingga akhir, termasuk memanfaatkan '
        'kredit pajak dan memahami batas waktu pelaporan.',
    imagePath: 'assets/svg/maskot_curiga.svg',
  ),
];

// ─── Status UI Config ────────────────────────────────────────────────────────

class StatusUIConfig {
  final StatusChipVariant chipVariant;
  final String chipLabel;
  final String buttonLabel;
  final ButtonVariant buttonVariant;

  const StatusUIConfig({
    required this.chipVariant,
    required this.chipLabel,
    required this.buttonLabel,
    required this.buttonVariant,
  });
}

/// Map progress status → UI config untuk jelajahi pos & profile
StatusUIConfig getStatusUIConfig(PosProgressStatus status, int posNumber) {
  switch (status) {
    case PosProgressStatus.notStarted:
      return StatusUIConfig(
        chipVariant: StatusChipVariant.secondary,
        chipLabel: 'Belum Dipelajari',
        buttonLabel: 'Masuk ke Pos $posNumber',
        buttonVariant: ButtonVariant.primary,
      );
    case PosProgressStatus.inProgress:
      return StatusUIConfig(
        chipVariant: StatusChipVariant.third,
        chipLabel: 'Sedang Dipelajari',
        buttonLabel: 'Lanjutkan Pos $posNumber',
        buttonVariant: ButtonVariant.secondary,
      );
    case PosProgressStatus.completed:
      return StatusUIConfig(
        chipVariant: StatusChipVariant.primary,
        chipLabel: 'Sudah Dipelajari',
        buttonLabel: 'Mainkan Ulang Pos $posNumber',
        buttonVariant: ButtonVariant.secondary,
      );
  }
}

/// Map progress status → chip variant saja (untuk profile view)
StatusChipVariant getProgressChipVariant(PosProgressStatus status) {
  switch (status) {
    case PosProgressStatus.notStarted:
      return StatusChipVariant.secondary;
    case PosProgressStatus.inProgress:
      return StatusChipVariant.third;
    case PosProgressStatus.completed:
      return StatusChipVariant.primary;
  }
}

/// Map progress status → chip label saja (untuk profile view)
String getProgressChipLabel(PosProgressStatus status) {
  switch (status) {
    case PosProgressStatus.notStarted:
      return 'Belum Dipelajari';
    case PosProgressStatus.inProgress:
      return 'Sedang Dipelajari';
    case PosProgressStatus.completed:
      return 'Sudah Dipelajari';
  }
}

// ─── Slide Types ────────────────────────────────────────────────────────────
// Setiap slide bisa memiliki tipe yang berbeda.
// pos_detail_view.dart akan me-render widget berbeda berdasarkan tipe ini.
// ─────────────────────────────────────────────────────────────────────────────

enum SlideType {
  /// Chat scene — bubble pesan seperti WhatsApp
  chat,

  /// Info card — teks + gambar, untuk penjelasan konsep
  info,

  /// Quiz — pertanyaan pilihan ganda
  quiz,

  /// Summary — ringkasan materi sebelum selesai
  summary,

  /// Reason cards — mascot + chat bubble + 3 reason cards + highlight takeaway
  reasonCards,

  /// Terminology — centered title + 4 education cards
  terminology,

  /// Payslip — dynamic user name + payslip card with rows
  payslip,

  /// Calculation Steps — mascot + chat bubble + numbered steps + highlight
  calculationSteps,

  /// Grid Cards — dynamic title + 2x2 grid cards + highlight info
  gridCards,

  /// Tariff Layers — stacked layer visualization for progressive tax
  tariffLayers,

  /// TER Reconciliation — mascot + chat + TER vs reconciliation sections
  terReconciliation,

  /// Completion — pos selesai, Part 1 (celebration) + Part 2 (teaser pos berikutnya)
  completion,

  /// Payslip Comparison — perbandingan slip gaji antara 2 user
  payslipComparison,

  /// PTKP Info — kenalan dengan PTKP + 2 info cards + tip box
  ptkpInfo,

  /// Profile Comparison — perbandingan profil PTKP antara 2 user
  profileComparison,

  /// PTKP Simulation — toggle di bawah/di atas PTKP dengan dynamic bar
  ptkpSimulation,
}

// ─── Chat Message Model ─────────────────────────────────────────────────────

enum ChatSender { user, other }

class ChatMessage {
  final String senderName;
  final String text;
  final ChatSender sender;
  final bool isChoice; // true = bubble user response (right-aligned)

  const ChatMessage({
    required this.senderName,
    required this.text,
    required this.sender,
    this.isChoice = false,
  });
}

// ─── Quiz Data Model ────────────────────────────────────────────────────────

class QuizOption {
  final String label; // A, B, C, D
  final String text;
  final bool isCorrect;

  const QuizOption({
    required this.label,
    required this.text,
    required this.isCorrect,
  });
}

class QuizData {
  final String question;
  final List<QuizOption> options;
  final String explanation; // penjelasan setelah jawab

  const QuizData({
    required this.question,
    required this.options,
    required this.explanation,
  });
}

// ─── Reason Card Data ──────────────────────────────────────────────────────
// Untuk slide tipe reasonCards (Scene 3: "Kenapa gak nanti aja?")
// ─────────────────────────────────────────────────────────────────────────────

class ReasonCardItem {
  final IconData icon;
  final String title;
  final String subtitle;

  const ReasonCardItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

// ─── Terminology Data ───────────────────────────────────────────────────────
// Untuk slide tipe terminology (Scene 4: "Kenalan dulu yuk...")
// ─────────────────────────────────────────────────────────────────────────────

class TerminologyItem {
  final IconData? icon; // optional — bisa tanpa icon
  final String title;
  final String description;

  const TerminologyItem({
    this.icon,
    required this.title,
    required this.description,
  });
}

// ─── Payslip Row Data ───────────────────────────────────────────────────────
// Untuk slide tipe payslip (Scene 5: "Simulasi Slip Gaji")
// ─────────────────────────────────────────────────────────────────────────────

class PayslipRow {
  final String label;
  final String value;
  final bool isBold;
  final bool showDividerBefore;

  const PayslipRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.showDividerBefore = false,
  });
}

// ─── Calculation Step Data ────────────────────────────────────────────────
// Untuk slide tipe calculationSteps (Scene 6: "Uang gajiku ke mana?")
// ─────────────────────────────────────────────────────────────────────────────

class CalculationStep {
  final int number;
  final String title;
  final String formula; // teks formula utama
  final String? caption; // caption kecil (misal: *PTKP)

  const CalculationStep({
    required this.number,
    required this.title,
    required this.formula,
    this.caption,
  });
}

// ─── Grid Card Data ──────────────────────────────────────────────────────
// Untuk slide tipe gridCards (Scene 7: "Pajak [Nama] gak hilang...")
// ─────────────────────────────────────────────────────────────────────────────

class GridCardItem {
  final IconData icon;
  final String title;
  final String subtitle;

  const GridCardItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

// ─── Tariff Layer Data ─────────────────────────────────────────────────────
// Untuk slide tipe tariffLayers (Scene 8 & 9: "Tarif Progresif")
// ─────────────────────────────────────────────────────────────────────────────

class TariffLayer {
  final int number; // 1, 2, 3
  final String label; // "Lapisan 1 - Tarif 5%"
  final Color color; // warna layer
  final Color textColor; // warna teks
  final String? value; // nilai (misal: "Rp50 jt")

  const TariffLayer({
    required this.number,
    required this.label,
    required this.color,
    required this.textColor,
    this.value,
  });
}

// ─── TER Section Data ─────────────────────────────────────────────────────
// Untuk slide tipe terReconciliation (Scene 10: "TER vs Rekonsiliasi")
// ─────────────────────────────────────────────────────────────────────────────

class TerSection {
  final String headerLabel; // "Januari - November" atau "Desember"
  final String title; // "Memakai TER" atau "Rekonsiliasi"
  final String subtitle; // deskripsi
  final IconData? icon; // icon opsional (untuk Rekonsiliasi)

  const TerSection({
    required this.headerLabel,
    required this.title,
    required this.subtitle,
    this.icon,
  });
}

// ─── Payslip Comparison Data ────────────────────────────────────────────────
// Untuk slide tipe payslipComparison (Pos 2 Scene 1 & 3)
// ─────────────────────────────────────────────────────────────────────────────

class PayslipComparisonCard {
  final String title; // "Slip Gaji [Nama]" atau "Profil [Nama]"
  final List<PayslipComparisonRow> rows;

  const PayslipComparisonCard({required this.title, required this.rows});
}

class PayslipComparisonRow {
  final String label;
  final String value;
  final bool isBold;

  const PayslipComparisonRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });
}

// ─── PTKP Info Card Data ────────────────────────────────────────────────────
// Untuk slide tipe ptkpInfo (Pos 2 Scene 2)
// ─────────────────────────────────────────────────────────────────────────────

class PtkpInfoCard {
  final IconData icon;
  final String label;

  const PtkpInfoCard({required this.icon, required this.label});
}

// ─── PosSlide Model ──────────────────────────────────────────────────────────
// Model untuk satu slide di dalam detail pos.
// Setiap slide memiliki tipe yang menentukan widget apa yang di-render.
// ─────────────────────────────────────────────────────────────────────────────

class PosSlide {
  final int slideNumber;
  final SlideType type;
  final String title;
  final String? body; // untuk info & summary
  final String? imagePath; // untuk info
  final List<ChatMessage>? messages; // untuk chat
  final QuizData? quiz; // untuk quiz

  // ── Fields untuk reasonCards ──
  final String? mascotImagePath; // mascot image path
  final String? chatBubbleText; // teks di bubble chat
  final List<ReasonCardItem>? reasonCards; // 3 reason cards
  final String? highlightTitle; // title takeaway box
  final String? highlightBody; // body takeaway box

  // ── Fields untuk terminology ──
  final List<TerminologyItem>? terminologyItems; // 4 istilah

  // ── Fields untuk payslip ──
  final String? subtitle; // subtitle text
  final List<PayslipRow>? payslipRows; // rows gaji

  // ── Fields untuk calculationSteps ──
  final String? sectionTitle; // section title (misal: "Dari Gaji Bruto Kamu:")
  final List<CalculationStep>? calculationSteps; // numbered steps

  // ── Fields untuk gridCards ──
  final List<GridCardItem>? gridCards; // 2x2 grid items

  // ── Fields untuk tariffLayers ──
  final String? description; // deskripsi text (footer/body)
  final List<TariffLayer>? tariffLayers; // 3 stacked layers

  // ── Fields untuk terReconciliation ──
  final List<TerSection>? terSections; // 2 sections (TER + Rekonsiliasi)

  // ── Fields untuk payslipComparison & profileComparison ──
  final List<PayslipComparisonCard>?
  comparisonCards; // 2 cards untuk perbandingan
  final List<PayslipComparisonRow>? infoRows; // key-value rows untuk info card

  // ── Fields untuk ptkpInfo ──
  final List<PtkpInfoCard>? ptkpInfoCards; // 2 info cards
  final String? tipTitle; // tip box title
  final String? tipBody; // tip box body

  // ── Custom button label ──
  final String? buttonLabel; // custom tombol bawah

  final bool isLastSlide;

  const PosSlide({
    required this.slideNumber,
    required this.type,
    required this.title,
    this.body,
    this.imagePath,
    this.messages,
    this.quiz,
    this.mascotImagePath,
    this.chatBubbleText,
    this.reasonCards,
    this.highlightTitle,
    this.highlightBody,
    this.terminologyItems,
    this.subtitle,
    this.payslipRows,
    this.sectionTitle,
    this.calculationSteps,
    this.gridCards,
    this.description,
    this.tariffLayers,
    this.terSections,
    this.comparisonCards,
    this.infoRows,
    this.ptkpInfoCards,
    this.tipTitle,
    this.tipBody,
    this.buttonLabel,
    this.isLastSlide = false,
  });
}

// ─── Mock Slides per Pos ────────────────────────────────────────────────────
// Tiap pos bisa mix berbagai tipe slide.
// Tinggal ganti/isi konten saat slicing desain sebenarnya.
// ─────────────────────────────────────────────────────────────────────────────

// ═══════════════════════════════════════════════════════════════════════════
// POS 1 — Modul PPh 21
// Flow: Chat → Info → Quiz → ReasonCards → Terminology → Payslip → ...
// ═══════════════════════════════════════════════════════════════════════════
final List<PosSlide> pos1Slides = [
  // ── Slide 1: Chat (intro) ──
  PosSlide(
    slideNumber: 1,
    type: SlideType.chat,
    title: 'Apa Itu PPh 21?',
    messages: [
      ChatMessage(
        senderName: 'Rafi',
        text: 'Guys, aku baru dapet offering letter nih! 🎉',
        sender: ChatSender.other,
      ),
      ChatMessage(
        senderName: 'Rafi',
        text:
            'Gajinya lumayan, tapi ada tulisan "dipotong sesuai ketentuan perpajakan"',
        sender: ChatSender.other,
      ),
      ChatMessage(
        senderName: 'Kamu',
        text: 'Itu maksudnya apa ya?',
        sender: ChatSender.user,
        isChoice: true,
      ),
      ChatMessage(
        senderName: 'Dinda',
        text: 'Eh, itu tuh PPh 21 ☝️',
        sender: ChatSender.other,
      ),
      ChatMessage(
        senderName: 'Rafi',
        text: 'Hah? Emang sekarang aku udah kena pajak?',
        sender: ChatSender.other,
      ),
    ],
  ),

  // ── Slide 2: Quiz (Cek pemahaman awal) ──
  PosSlide(
    slideNumber: 2,
    type: SlideType.quiz,
    title: 'Cek Pemahamanmu!',
    quiz: QuizData(
      question:
          'Menurutmu, kapan seseorang harus mulai peduli tentang pajak penghasilan?',
      options: [
        QuizOption(label: 'A', text: 'Setelah gajinya besar', isCorrect: false),
        QuizOption(
          label: 'B',
          text: 'Setelah kerja full-time',
          isCorrect: false,
        ),
        QuizOption(
          label: 'C',
          text: 'Begitu mulai punya penghasilan',
          isCorrect: true,
        ),
        QuizOption(
          label: 'D',
          text: 'Saat sudah waktunya lapor pajak',
          isCorrect: false,
        ),
      ],
      explanation:
          'Mulai punya penghasilan berarti sudah waktunya mulai memahami '
          'bagaimana pajak bekerja. Jangan tunggu bingung dulu!',
    ),
  ),

  // ── Slide 3: Reason Cards ("Kenapa gak nanti aja?") ──
  PosSlide(
    slideNumber: 3,
    type: SlideType.reasonCards,
    title: 'Kenapa gak nanti aja?',
    mascotImagePath: 'assets/svg/logo_square_outline.svg',
    chatBubbleText: 'Kenapa gak nanti aja?',
    reasonCards: [
      ReasonCardItem(
        icon: Icons.receipt_long_outlined,
        title: 'Gaji mulai dipotong',
        subtitle: 'Tiba-tiba ada potongan di slip gaji.',
      ),
      ReasonCardItem(
        icon: Icons.assignment_outlined,
        title: 'HR lalu bertanya',
        subtitle: '"Status NPWP kamu bagaimana?"',
      ),
      ReasonCardItem(
        icon: Icons.calendar_today_outlined,
        title: 'SPT itu punya batas waktu',
        subtitle: 'Baru mau belajar pas harus lapor?',
      ),
    ],
    highlightTitle: 'Pajak lebih enak dipelajari sebelum kamu butuh.',
    highlightBody: 'Kamu gak perlu nunggu bingung dulu.',
    buttonLabel: 'Lanjut',
  ),

  // ── Slide 4: Terminology ("Kenalan dulu yuk...") ──
  PosSlide(
    slideNumber: 4,
    type: SlideType.terminology,
    title: 'Sebelum itu, kenalan dulu yuk sama istilah-istilah ini!',
    terminologyItems: [
      TerminologyItem(
        icon: Icons.account_balance_outlined,
        title: 'Direktorat Jenderal Pajak',
        description:
            'Disingkat DJP, yaitu otoritas yang mengurus perpajakan di Indonesia.',
      ),
      TerminologyItem(
        icon: Icons.badge_outlined,
        title: 'NIK sebagai NPWP',
        description:
            'Untuk wajib pajak orang pribadi, NIK berfungsi sebagai NPWP.',
      ),
      TerminologyItem(
        icon: Icons.payments_outlined,
        title: 'Pajak Penghasilan Pasal 21',
        description:
            'Disingkat PPh 21, yaitu pajak atas penghasilan dari pekerjaan.',
      ),
      TerminologyItem(
        icon: Icons.person_outline,
        title: 'Wajib Pajak',
        description: 'Orang atau badan yang memiliki kewajiban perpajakan.',
      ),
    ],
    buttonLabel: 'Paham',
  ),

  // ── Slide 5: Payslip ("Simulasi Slip Gaji") ──
  PosSlide(
    slideNumber: 5,
    type: SlideType.payslip,
    title: 'Ini adalah slip gaji nantinya.',
    subtitle: 'Belum terbiasa ya melihatnya?',
    payslipRows: [
      PayslipRow(label: 'Gaji Pokok', value: 'Rp5.000.000'),
      PayslipRow(label: 'Tunjangan', value: 'Rp500.000'),
      PayslipRow(
        label: 'Bruto',
        value: 'Rp5.500.000',
        isBold: true,
        showDividerBefore: true,
      ),
      PayslipRow(label: 'Biaya Jabatan', value: 'Rp275.000'),
      PayslipRow(label: 'PPh 21', value: 'Rp xxx.xxx'),
      PayslipRow(
        label: 'Take-Home Pay',
        value: 'Rp x.xxx.xxx',
        isBold: true,
        showDividerBefore: true,
      ),
    ],
    buttonLabel: 'Jelasin Dong',
  ),

  // ── Slide 6: Terminology ("Istilah ini juga perlu diketahui.") ──
  PosSlide(
    slideNumber: 6,
    type: SlideType.terminology,
    title: 'Istilah ini juga perlu diketahui.',
    terminologyItems: [
      TerminologyItem(
        title: 'Tunjangan',
        description:
            'Tambahan pendapatan di luar gaji pokok dari perusahaan atau instansi.',
      ),
      TerminologyItem(
        title: 'Bruto',
        description: 'Total gaji kotor sebelum dikurangi pajak.',
      ),
      TerminologyItem(
        title: 'Biaya Jabatan',
        description:
            'Pengurang standar dari penghasilan bruto sebelum perhitungan pajak. '
            'Bukan uang tambahan yang masuk rekeningmu.',
      ),
      TerminologyItem(
        title: 'Take-Home Pay',
        description: 'Uang bersih yang akhirnya masuk ke rekening kamu.',
      ),
    ],
    buttonLabel: 'Paham',
  ),

  // ── Slide 7: Calculation Steps ("Uang gajiku ke mana?") ──
  PosSlide(
    slideNumber: 7,
    type: SlideType.calculationSteps,
    title: 'Uang gajiku ke mana?',
    mascotImagePath: 'assets/svg/logo_square_outline.svg',
    chatBubbleText: 'Uang gajiku ke mana?',
    sectionTitle: 'Dari Gaji Bruto Kamu:',
    calculationSteps: [
      CalculationStep(
        number: 1,
        title: 'Gaji Bruto – Biaya Jabatan',
        formula: '= Penghasilan Neto',
      ),
      CalculationStep(
        number: 2,
        title: 'Penghasilan Neto – PTKP*',
        caption: '*Penghasilan Tidak Kena Pajak',
        formula: '= PKP (Penghasilan Kena Pajak)',
      ),
      CalculationStep(number: 3, title: 'PKP × Tarif', formula: '= PPh 21'),
    ],
    highlightTitle: 'Itulah pajak penghasilan yang dipotong dari gajimu.',
    highlightBody: 'Emang bakal dipake buat apa, sih?',
    buttonLabel: 'Ayo Cari Tau',
  ),

  // ── Slide 8: Tariff Layers ("Kenalan dengan Tarif Progresif") ──
  PosSlide(
    slideNumber: 8,
    type: SlideType.tariffLayers,
    title: 'Kenalan dengan Tarif Progresif',
    subtitle:
        'Tarif progresif berarti semakin besar Penghasilan Kena Pajak (PKP) '
        'seseorang, semakin tinggi tarif yang dikenakan pada lapisan '
        'penghasilan yang lebih tinggi.',
    tariffLayers: [
      const TariffLayer(
        number: 3,
        label: 'Lapisan 3 - Tarif 15%',
        color: Color(0xFF8F6200),
        textColor: Colors.white,
      ),
      const TariffLayer(
        number: 2,
        label: 'Lapisan 2 - Tarif 12%',
        color: Color(0xFFD99000),
        textColor: Colors.white,
      ),
      const TariffLayer(
        number: 1,
        label: 'Lapisan 1 - Tarif 5%',
        color: Color(0xFFE9C159),
        textColor: Color(0xFF4A2C00),
      ),
    ],
    description:
        'Namun, yang perlu dipahami adalah **naik ke lapisan yang lebih tinggi '
        'bukan berarti seluruh penghasilan dikenai tarif lapisan tersebut.**',
    buttonLabel: 'Maksudnya?',
  ),

  // ── Slide 9: Tariff Layers ("Ini yang sering disalahpahami.") ──
  PosSlide(
    slideNumber: 9,
    type: SlideType.tariffLayers,
    title: 'Ini yang sering disalahpahami.',
    subtitle:
        'Naik ke lapisan berikutnya bukan berarti semua penghasilanmu kena '
        'tarif yang lebih tinggi. **Tarif baru hanya berlaku untuk bagian PKP '
        'yang masuk ke lapisan tersebut.**',
    sectionTitle: 'Misalnya PKP [Nama User] = Rp120 juta',
    tariffLayers: [
      const TariffLayer(
        number: 3,
        label: 'Lapisan 3',
        value: 'Rp20 jt',
        color: Color(0xFF8F6200),
        textColor: Colors.white,
      ),
      const TariffLayer(
        number: 2,
        label: 'Lapisan 2',
        value: 'Rp50 jt',
        color: Color(0xFFD99000),
        textColor: Colors.white,
      ),
      const TariffLayer(
        number: 1,
        label: 'Lapisan 1',
        value: 'Rp50 jt',
        color: Color(0xFFE9C159),
        textColor: Color(0xFF4A2C00),
      ),
    ],
    description:
        'Rp50 juta pertama dikenai tarif Lapisan 1. Bagian berikutnya yang '
        'masuk Lapisan 2 dikenai tarif Lapisan 2, dan seterusnya.',
    buttonLabel: 'Lanjut',
  ),

  // ── Slide 10: TER Reconciliation ("Kok potongan Desember bisa beda?") ──
  PosSlide(
    slideNumber: 10,
    type: SlideType.terReconciliation,
    title: 'Kok potongan bulan Desember bisa beda?',
    mascotImagePath: 'assets/svg/logo_square_outline.svg',
    chatBubbleText: 'Kok potongan bulan Desember bisa beda?',
    terSections: [
      const TerSection(
        headerLabel: 'Januari - November',
        title: 'Memakai TER',
        subtitle:
            'Atau Tarif Efektif Rata-Rata untuk mempermudah penghitungan '
            'potongan bulanan.',
      ),
      const TerSection(
        headerLabel: 'Desember',
        title: 'Rekonsiliasi',
        subtitle:
            'Penghitungan ulang dilakukan berdasarkan tarif progresif atas '
            'penghasilan selama satu tahun.',
        icon: Icons.sync_outlined,
      ),
    ],
    buttonLabel: 'Lanjut',
  ),

  // ── Slide 11: Completion ("Pos 1 Selesai!" + "Masih ada satu hal...") ──
  PosSlide(
    slideNumber: 11,
    type: SlideType.completion,
    title: 'Pos 1 Selesai!',
    subtitle: 'Masih ada satu hal...',
    mascotImagePath: 'assets/svg/maskot_login.svg',
    chatBubbleText:
        '[Nama User] dan temannya punya gaji yang sama. '
        'Tapi... Kenapa potongan pajaknya bisa beda?',
    highlightTitle:
        'Sekarang, kamu sudah punya bekal dasar untuk memahami pajak penghasilan.',
    imagePath: 'assets/svg/logo_square_outline.svg',
    buttonLabel: 'Lanjut di Pos 2',
    isLastSlide: true,
  ),
];

// ═══════════════════════════════════════════════════════════════════════════
// POS 2 — Modul PTKP
// Flow: Chat → Info → Quiz → Info → Summary
// ═══════════════════════════════════════════════════════════════════════════
final List<PosSlide> pos2Slides = [
  // ── Slide 1: Payslip Comparison ("Gaji kita sama, kok potongannya beda?") ──
  PosSlide(
    slideNumber: 1,
    type: SlideType.payslipComparison,
    title: '',
    mascotImagePath: 'assets/svg/logo_square_outline.svg',
    chatBubbleText: 'Gaji kita sama, kok potongannya beda?',
    comparisonCards: [
      PayslipComparisonCard(
        title: 'Slip Gaji [Nama User]',
        rows: const [
          PayslipComparisonRow(label: 'Gaji Bruto', value: 'Rp5.500.000'),
          PayslipComparisonRow(label: 'PPh 21', value: 'Rp 100.000'),
        ],
      ),
      PayslipComparisonCard(
        title: 'Slip Gaji Dinda',
        rows: const [
          PayslipComparisonRow(label: 'Gaji Bruto', value: 'Rp5.500.000'),
          PayslipComparisonRow(label: 'PPh 21', value: 'Rp 50.000'),
        ],
      ),
    ],
    buttonLabel: 'Ayo Cari Tau',
  ),

  // ── Slide 2: PTKP Info ("Kenalan dengan PTKP") ──
  PosSlide(
    slideNumber: 2,
    type: SlideType.ptkpInfo,
    title: 'Kenalan dengan PTKP',
    subtitle: '(Penghasilan Tidak Kena Pajak)',
    description:
        'PTKP adalah bagian dari penghasilan yang tidak dikenai pajak. '
        '**Besarnya PTKP bisa berbeda karena dipengaruhi oleh status '
        'pernikahan dan jumlah tanggungan yang diakui.** Perubahan status '
        'bisa memengaruhi perhitungan pajaknya.',
    ptkpInfoCards: const [
      PtkpInfoCard(icon: Icons.favorite_outline, label: 'Status Pernikahan'),
      PtkpInfoCard(
        icon: Icons.family_restroom_outlined,
        label: 'Jumlah Tanggungan',
      ),
    ],
    tipTitle:
        'Semakin besar PTKP, semakin kecil bagian penghasilan yang menjadi PKP.',
    tipBody: 'Penghasilan Neto - PTKP = PKP',
    buttonLabel: 'Lanjut',
  ),

  // ── Slide 3: Profile Comparison ("Perbandingan Detail Profil PTKP") ──
  PosSlide(
    slideNumber: 3,
    type: SlideType.payslipComparison,
    title: '',
    description:
        'Meskipun gaji brutonya sama, **karena PTKP Dinda lebih besar, '
        'bagian penghasilannya yang menjadi PKP jadi lebih kecil.**',
    comparisonCards: [
      PayslipComparisonCard(
        title: 'Profil [Nama User]',
        rows: const [
          PayslipComparisonRow(label: 'Gaji Bruto', value: 'Rp5.500.000'),
          PayslipComparisonRow(
            label: 'Status Nikah',
            value: 'Belum menikah',
            isBold: true,
          ),
          PayslipComparisonRow(
            label: 'Jumlah Tanggungan',
            value: 'Tidak ada',
            isBold: true,
          ),
        ],
      ),
      PayslipComparisonCard(
        title: 'Profil Dinda',
        rows: const [
          PayslipComparisonRow(label: 'Gaji Bruto', value: 'Rp5.500.000'),
          PayslipComparisonRow(
            label: 'Status Nikah',
            value: 'Menikah',
            isBold: true,
          ),
          PayslipComparisonRow(
            label: 'Jumlah Tanggungan',
            value: '1 Orang',
            isBold: true,
          ),
        ],
      ),
    ],
    tipTitle:
        'Meskipun gaji brutonya sama, karena PTKP Dinda lebih besar, bagian '
        'penghasilannya yang menjadi PKP jadi lebih kecil.',
    buttonLabel: 'Jadi Begitu Ya!',
  ),

  // ── Slide 4: PTKP Simulation ("Bagaimana kalau penghasilan netomu...") ──
  PosSlide(
    slideNumber: 4,
    type: SlideType.ptkpSimulation,
    title: 'Bagaimana kalau penghasilan netomu masih di bawah PTKP?',
    description:
        'Tidak semua penghasilan kena pajak, ada ambang batas yang perlu '
        'diperhatikan. **Kalau penghasilan masih berada di bawah batas PTKP, '
        'PPh 21 kamu bisa saja Rp0.**',
    buttonLabel: 'Lanjut',
  ),

  // ── Slide 5: Info (Daftar Status PTKP) ──
  PosSlide(
    slideNumber: 5,
    type: SlideType.info,
    title: 'Daftar Status PTKP',
    body:
        'TK/0: Belum menikah, 0 tanggungan\n'
        'TK/1: Belum menikah, 1 tanggungan\n'
        'K/0: Menikah, 0 tanggungan\n'
        'K/1: Menikah, 1 tanggungan\n'
        'K/2: Menikah, 2 tanggungan\n'
        'K/3: Menikah, 3 tanggungan',
    imagePath: 'assets/svg/maskot_takut.svg',
  ),

  // ── Slide 6: Summary (Completion) ──
  PosSlide(
    slideNumber: 6,
    type: SlideType.completion,
    title: 'Pos 2 Selesai!',
    subtitle: 'Masih ada satu hal...',
    mascotImagePath: 'assets/svg/maskot_takut.svg',
    chatBubbleText:
        '[Nama User] dan temannya punya gaji yang sama. '
        'Tapi... Kenapa potongan pajaknya bisa beda?',
    highlightTitle:
        'Sekarang, kamu sudah paham bagaimana PTKP memengaruhi pajakmu.',
    imagePath: 'assets/svg/logo_square_outline.svg',
    buttonLabel: 'Lanjut di Pos 3',
    isLastSlide: true,
  ),
];

// ═══════════════════════════════════════════════════════════════════════════
// POS 3 — Modul SPT
// Flow: Chat → Info → Chat → Quiz → Summary
// ═══════════════════════════════════════════════════════════════════════════
const List<PosSlide> pos3Slides = [
  // ── Slide 1: Chat ──
  PosSlide(
    slideNumber: 1,
    type: SlideType.chat,
    title: 'Belum Bayar Pajak!',
    messages: [
      ChatMessage(
        senderName: 'Rafi',
        text: 'Eh guys, aku belum lapor pajak tahun lalu 😰',
        sender: ChatSender.other,
      ),
      ChatMessage(
        senderName: 'Dinda',
        text: 'Waduh, itu bisa kena denda lho!',
        sender: ChatSender.other,
      ),
      ChatMessage(
        senderName: 'Kamu',
        text: 'Gimana cara lapor pajaknya sih?',
        sender: ChatSender.user,
        isChoice: true,
      ),
      ChatMessage(
        senderName: 'Dinda',
        text: 'Caranya lewat SPT Tahunan — laporan pajak tahunan wajib pajak.',
        sender: ChatSender.other,
      ),
    ],
  ),

  // ── Slide 2: Info ──
  PosSlide(
    slideNumber: 2,
    type: SlideType.info,
    title: 'Apa Itu SPT Tahunan?',
    body:
        'SPT Tahunan PPh Orang Pribadi adalah laporan pajak tahunan yang '
        'wajib disetorkan setiap tahun. Di SPT, kamu melaporkan seluruh '
        'penghasilan dan pajak yang sudah dipotong selama setahun penuh. '
        'Batas waktu: 31 Maret tahun berikutnya.',
    imagePath: 'assets/svg/maskot_curiga.svg',
  ),

  // ── Slide 3: Chat ──
  PosSlide(
    slideNumber: 3,
    type: SlideType.chat,
    title: 'Cara Isi SPT',
    messages: [
      ChatMessage(
        senderName: 'Dinda',
        text: 'Sekarang bisa online lho, lewat DJP Online.',
        sender: ChatSender.other,
      ),
      ChatMessage(
        senderName: 'Rafi',
        text: 'Mudah nggak? Aku gaptek nih 😅',
        sender: ChatSender.other,
      ),
      ChatMessage(
        senderName: 'Kamu',
        text: 'Aku juga belum pernah coba, tapi kayaknya seru!',
        sender: ChatSender.user,
        isChoice: true,
      ),
      ChatMessage(
        senderName: 'Dinda',
        text:
            'Gampang kok! Login, isi formulir, upload dokumen, submit. Selesai deh!',
        sender: ChatSender.other,
      ),
    ],
  ),

  // ── Slide 4: Quiz ──
  PosSlide(
    slideNumber: 4,
    type: SlideType.quiz,
    title: 'Cek Pemahamanmu!',
    quiz: QuizData(
      question: 'Batas waktu pelaporan SPT Tahunan PPh Orang Pribadi adalah?',
      options: [
        QuizOption(label: 'A', text: '31 Desember', isCorrect: false),
        QuizOption(label: 'B', text: '31 Januari', isCorrect: false),
        QuizOption(
          label: 'C',
          text: '31 Maret tahun berikutnya',
          isCorrect: true,
        ),
        QuizOption(label: 'D', text: '30 April', isCorrect: false),
      ],
      explanation:
          'Batas waktu SPT Tahunan PPh Orang Pribadi adalah 31 Maret tahun '
          'berikutnya. Contoh: SPT tahun 2025 harus dilaporkan paling lambat '
          '31 Maret 2026.',
    ),
  ),

  // ── Slide 5: Summary ──
  PosSlide(
    slideNumber: 5,
    type: SlideType.summary,
    title: 'Ringkasan SPT',
    body:
        '✅ SPT Tahunan = laporan pajak tahunan wajib pajak.\n'
        '✅ Batas waktu: 31 Maret tahun berikutnya.\n'
        '✅ Bisa dilaporkan via DJP Online.\n'
        '✅ Jangan lupa lapor agar tidak kena denda!',
    isLastSlide: true,
  ),
];

// ─── Helpers ────────────────────────────────────────────────────────────────

/// Dapatkan slides berdasarkan posId
List<PosSlide> getSlidesForPos(int posId) {
  switch (posId) {
    case 1:
      return pos1Slides;
    case 2:
      return pos2Slides;
    case 3:
      return pos3Slides;
    default:
      return pos1Slides;
  }
}

/// Total slides untuk pos tertentu
int getTotalSlides(int posId) => getSlidesForPos(posId).length;
