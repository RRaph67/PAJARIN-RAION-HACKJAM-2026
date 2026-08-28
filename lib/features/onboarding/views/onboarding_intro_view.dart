// =============================================================================
// onboarding_intro_view.dart
// Halaman pengenalan onboarding yang muncul setelah user melengkapi profil.
// Struktur: MainWrapper → FrameAtas (FrameLogo, TitleFrame, SubtitleFrame)
//                         → FrameBawah (Button Lewati, Button Ikuti Tur)
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_button.dart';

class OnboardingIntroView extends StatelessWidget {
  const OnboardingIntroView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.orange50,
      body: SafeArea(
        // ── MainWrapper ────────────────────────────────────────────────────────
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            // Gap vertical auto antara konten atas dan button bawah
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ═══════════════ KONTEN ATAS ═══════════════
              Column(
                children: [
                  // ── Back Button & Progress Bar (posisi di atas) ──────────
                  Row(
                    children: [
                      AppBackButton(
                        onPressed: () => context.go(AppRoutes.linkup),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // ── FrameAtas ──────────────────────────────────────────
                  // FrameLogo
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // ─── Layer Belakang: Elips Gepeng Persis Seperti Gambar ───
                        Positioned(
                          bottom:
                              20, // Sesuaikan posisi vertikal di bawah maskot
                          child: ClipOval(
                            child: Container(
                              width: 117,
                              height: 24,
                              color: const Color(
                                0xFF493000,
                              ).withValues(alpha: 0.25),
                            ),
                          ),
                        ),

                        // ─── Layer Depan: Maskot SVG ───
                        SvgPicture.asset(
                          'assets/svg/maskot_login.svg',
                          width: 360,
                          height: 333,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // TitleFrame
                  Text(
                    'Ayo kenalan dengan Pajarin!',
                    style: AppTypography.displayLargeExtraBold.copyWith(
                      color: AppColors.orange950,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // SubtitleFrame
                  Text(
                    'Mari kita kenali fitur pajak bersama.',
                    style: AppTypography.headlineMediumSemiBold.copyWith(
                      color: AppColors.orange950,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              // ═══════════════ FRAME BAWAH (gap auto) ═══════════════
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Lewati',
                      variant: ButtonVariant.secondary,
                      onPressed: () {
                        // Langsung ke home, lewati onboarding
                        context.go(AppRoutes.home);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppButton(
                      label: 'Ikuti Tur',
                      onPressed: () {
                        // Mulai core onboarding (nanti akan ke step 1)
                        context.go(AppRoutes.onboardingCore);
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
  }
}
