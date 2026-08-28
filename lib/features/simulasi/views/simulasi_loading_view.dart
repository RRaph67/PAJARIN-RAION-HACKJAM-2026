// =============================================================================
// simulasi_loading_view.dart
// Halaman loading saat menghitung simulasi pajak.
// Menggunakan AppLoadingView reusable, delay 3 detik, lalu navigasi ke hasil.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/widgets/app_loading_view.dart';

class SimulasiLoadingView extends StatefulWidget {
  /// Data input dari form kalkulator.
  final double gaji;
  final String ptkp;
  final int tanggungan;

  const SimulasiLoadingView({
    super.key,
    required this.gaji,
    required this.ptkp,
    required this.tanggungan,
  });

  @override
  State<SimulasiLoadingView> createState() => _SimulasiLoadingViewState();
}

class _SimulasiLoadingViewState extends State<SimulasiLoadingView> {
  @override
  Widget build(BuildContext context) {
    return AppLoadingView(
      mascotPath: 'assets/svg/maskot_mikir.svg',
      subtitle: 'Simulasi Kalkulator Pajak',
      title: 'Menghitung Pajak...',
      mascotSize: 200,
      delayDuration: const Duration(seconds: 5),
      onLoadingDone: () {
        if (!mounted) return;
        context.go(
          AppRoutes.simulasiHasil,
          extra: {
            'gaji': widget.gaji,
            'ptkp': widget.ptkp,
            'tanggungan': widget.tanggungan,
          },
        );
      },
      onBack: () => context.pop(),
    );
  }
}
