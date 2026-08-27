// =============================================================================
// simulasi_loading_view.dart
// Halaman loading saat menghitung simulasi pajak.
// Menggunakan AppLoadingView reusable, delay 3 detik, lalu navigasi ke hasil.
// =============================================================================

import 'dart:async';

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
  void initState() {
    super.initState();
    _startCountdown();
  }

  Future<void> _startCountdown() async {
    // Delay 3 detik sebelum navigasi ke hasil
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // Navigasi ke halaman hasil, replace supaya tidak bisa back ke loading
    context.pushReplacement(
      AppRoutes.simulasiHasil,
      extra: {
        'gaji': widget.gaji,
        'ptkp': widget.ptkp,
        'tanggungan': widget.tanggungan,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppLoadingView(
      title: 'Menghitung Pajak...',
      subtitle: 'Mohon tunggu sebentar',
      mascotAsset: 'assets/svg/maskot_mikir.svg',
      mascotWidth: 250,
      mascotHeight: 250,
      loadingText: 'Memuat hasil simulasi',
      onBackPressed: () => context.pop(),
    );
  }
}
