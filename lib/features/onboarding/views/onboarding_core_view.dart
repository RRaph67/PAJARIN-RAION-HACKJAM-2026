// =============================================================================
// onboarding_core_view.dart
// Halaman core onboarding dengan 3 step.
// Struktur per step: TopFrame (back + progress bar) → ImageFrame → ContentFrame → ButtonFrame
// Anti-overflow: konten di-scroll jika melebihi layar.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_progress_bar.dart';

// ── Data Step Onboarding ──────────────────────────────────────────────────────
// Ganti placeholder ini dengan konten asli sesuai kebutuhan.
class _OnboardingStep {
  final String imagePath;
  final String title;
  final String body;

  const _OnboardingStep({
    required this.imagePath,
    required this.title,
    required this.body,
  });
}

const List<_OnboardingStep> _steps = [
  _OnboardingStep(
    imagePath: 'assets/images/ob_tax_1.jpg',
    title: 'Jadi Ngerti ke Mana Perginya Potongan Gajimu',
    body:
        'Pajarin bantu kamu breakdown rincian potongan gaji setiap bulan '
        'dengan transparan, jadi kamu tahu persis ke mana alokasi pajakmu '
        'pergi tanpa bikin pusing.',
  ),
  _OnboardingStep(
    imagePath: 'assets/images/ob_tax_2.jpg',
    title: 'Belajar Secara Bertahap dengan Sistem Pos',
    body:
        'Nikmati metode belajar materi perpajakan yang dibagi ke dalam '
        'pos-pos kecil secara terstruktur. Dijamin lebih mudah dicerna '
        'dan tidak bikin informasi menumpuk.',
  ),
  _OnboardingStep(
    imagePath: 'assets/images/ob_tax_3.jpg',
    title: 'Kalkulator Simulasi Pajak Biar Gampang Hitung-Hitung',
    body:
        'Gunakan fitur simulasi untuk memperkirakan kewajiban pajak '
        'penghasilanmu secara akurat, cepat, dan sesuai dengan regulasi '
        'terbaru yang berlaku.',
  ),
];

// =============================================================================
// View
// =============================================================================
class OnboardingCoreView extends StatefulWidget {
  const OnboardingCoreView({super.key});

  @override
  State<OnboardingCoreView> createState() => _OnboardingCoreViewState();
}

class _OnboardingCoreViewState extends State<OnboardingCoreView> {
  final PageController _pageController = PageController();
  final int _totalSteps = _steps.length;
  int _currentStep = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go(AppRoutes.home);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go(AppRoutes.onboardingIntro);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.orange50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ═══════════════ TOP FRAME ═══════════════
              // Back Button + Progress Bar
              Row(
                children: [
                  AppBackButton(onPressed: _previousStep),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppProgressBar(
                      progress: (_currentStep + 1) / _totalSteps,
                      width: double.infinity,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // ═══════════════ ISI KONTEN (scrollable) ═══════════════
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() => _currentStep = index);
                  },
                  children: _steps.map((step) {
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── ImageFrame ──────────────────────────────────
                          Center(
                            child: SizedBox(
                              width: 361,
                              height: 280,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: step.imagePath.endsWith('.svg')
                                    ? SvgPicture.asset(
                                        step.imagePath,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        step.imagePath,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // ── ContentFrame ────────────────────────────────
                          // Title
                          Text(
                            step.title,
                            style: AppTypography.displaySmallExtraBold.copyWith(
                              color: AppColors.orange950,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(height: 8),

                          // Body text
                          Text(
                            step.body,
                            style: AppTypography.bodyLargeSemiBold.copyWith(
                              color: AppColors.orange950,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

              // ═══════════════ BUTTON FRAME ═══════════════
              Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: AppButton(
                        label: 'Sebelumnya',
                        variant: ButtonVariant.secondary,
                        onPressed: _previousStep,
                      ),
                    ),
                  if (_currentStep > 0) const SizedBox(width: 16),
                  Expanded(
                    child: AppButton(
                      label: _currentStep == _totalSteps - 1
                          ? 'Selesai'
                          : 'Selanjutnya',
                      onPressed: _nextStep,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
