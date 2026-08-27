// =============================================================================
// profile_view.dart
// Konten halaman profil user — menampilkan data dari tabel `users` Supabase.
// Memungkinkan user melihat dan mengupdate profil mereka.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/router/app_router.dart';
import '../../../core/models/user_model.dart';
import '../../../core/theme/app_colors.dart';
import '../viewmodels/profile_viewmodel.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  bool _isEditing = false;

  late TextEditingController _nameController;
  late TextEditingController _jobTitleController;
  late TextEditingController _incomeController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _jobTitleController = TextEditingController();
    _incomeController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfile();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _jobTitleController.dispose();
    _incomeController.dispose();
    super.dispose();
  }

  void _loadProfile() {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId != null) {
      ref.read(profileViewModelProvider.notifier).fetchProfile(userId);
    }
  }

  void _toggleEdit(UserModel user) {
    setState(() {
      _isEditing = !_isEditing;
      if (_isEditing) {
        _nameController.text = user.name;
        _jobTitleController.text = user.jobTitle ?? '';
        _incomeController.text = user.estimatedIncome?.toStringAsFixed(0) ?? '';
      }
    });
  }

  void _saveProfile() {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    final estimatedIncome = double.tryParse(_incomeController.text);

    ref
        .read(profileViewModelProvider.notifier)
        .updateProfile(
          userId: userId,
          name: _nameController.text.trim(),
          jobTitle: _jobTitleController.text.trim().isNotEmpty
              ? _jobTitleController.text.trim()
              : null,
          estimatedIncome: estimatedIncome,
        );

    setState(() => _isEditing = false);
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Apakah kamu yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Keluar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(authViewModelProvider.notifier).logout();
      if (mounted) context.go(AppRoutes.splash);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileViewModelProvider);

    ref.listen<ProfileState>(profileViewModelProvider, (previous, next) {
      if (next.message != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message!),
            backgroundColor: next.status == ProfileStatus.error
                ? Colors.red
                : Colors.green,
          ),
        );
        ref.read(profileViewModelProvider.notifier).resetStatus();
      }
    });

    return Column(
      children: [
        // ── Header ─────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Profil Saya',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: _logout,
                tooltip: 'Keluar',
              ),
            ],
          ),
        ),

        // ── Body ───────────────────────────────────────────────────
        Expanded(child: _buildBody(profileState)),
      ],
    );
  }

  Widget _buildBody(ProfileState profileState) {
    if (profileState.status == ProfileStatus.loading &&
        profileState.user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (profileState.status == ProfileStatus.error &&
        profileState.user == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(profileState.message ?? 'Gagal memuat profil'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadProfile,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    final user = profileState.user;
    if (user == null) {
      return const Center(child: Text('Data profil tidak tersedia'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 16),
          CircleAvatar(
            radius: 48,
            backgroundColor: AppColors.orange500,
            child: Text(
              user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
              style: const TextStyle(
                fontSize: 36,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          _isEditing ? _buildEditMode(user) : _buildDisplayMode(user),
          const SizedBox(height: 24),
          if (_isEditing) ...[
            ElevatedButton.icon(
              onPressed: _saveProfile,
              icon: const Icon(Icons.save),
              label: const Text('Simpan Perubahan'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => _toggleEdit(user),
              child: const Text('Batal'),
            ),
          ] else ...[
            OutlinedButton.icon(
              onPressed: () => _toggleEdit(user),
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profil'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDisplayMode(UserModel user) {
    return Column(
      children: [
        _InfoTile(
          icon: Icons.badge_outlined,
          label: 'Tipe Pengguna',
          value: user.userType.toUpperCase(),
        ),
        const SizedBox(height: 12),
        _InfoTile(
          icon: Icons.work_outline,
          label: 'Pekerjaan',
          value: user.jobTitle ?? 'Belum diisi',
        ),
        const SizedBox(height: 12),
        _InfoTile(
          icon: Icons.attach_money,
          label: 'Estimasi Penghasilan',
          value: user.estimatedIncome != null
              ? 'Rp ${user.estimatedIncome!.toStringAsFixed(0)}'
              : 'Belum diisi',
        ),
      ],
    );
  }

  Widget _buildEditMode(UserModel user) {
    return Column(
      children: [
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Nama',
            prefixIcon: Icon(Icons.person_outline),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _jobTitleController,
          decoration: const InputDecoration(
            labelText: 'Pekerjaan',
            prefixIcon: Icon(Icons.work_outline),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _incomeController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Estimasi Penghasilan',
            prefixIcon: Icon(Icons.attach_money),
          ),
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.orange500),
      title: Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      contentPadding: EdgeInsets.zero,
    );
  }
}
