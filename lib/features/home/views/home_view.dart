// =============================================================================
// home_view.dart
// Halaman utama (placeholder) untuk RaionHackJam15.
// [PLACEHOLDER] Ganti seluruh konten dengan desain UI asli dari Figma
// setelah tim UI/UX menyelesaikan rancangan.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        // [PLACEHOLDER] Ganti dengan judul halaman yang sesuai
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline_rounded),
            onPressed: () {
              context.go(AppRoutes.profile);
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ikon sementara sebagai penanda halaman belum jadi
            Icon(
              Icons.construction_rounded,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              '🚀 Halaman Home',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              // [PLACEHOLDER] Ganti teks ini dengan konten UI asli dari Figma
              '[PLACEHOLDER] Ganti dengan tampilan home\nsesuai desain Figma dari tim UI/UX.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
      // [PLACEHOLDER] Tambahkan BottomNavigationBar atau NavigationBar jika diperlukan
      // bottomNavigationBar: BottomNavigationBar( ... ),
    );
  }
}
