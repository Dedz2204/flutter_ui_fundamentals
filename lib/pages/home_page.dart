import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/auth_service.dart';
import '../services/profile_service.dart';
import '../services/kos_service.dart';
import '../widgets/role_guard.dart';
import 'kos_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Future<UserProfile?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = ProfileService().getMyProfile();
  }

  // Logout pengguna.
  Future<void> _logout() async {
    try {
      await AuthService.instance.logout();

      if (!mounted) return;

      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login',
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal logout: $e')),
      );
    }
  }

  // Membuka halaman Kos.
  void _openKosPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const KosPage(),
      ),
    );
  }

  // Dialog untuk memasukkan ID kos dan ID User A.
  Future<void> _showSecurityTestDialog() async {
    final kosIdController = TextEditingController();
    final ownerIdController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Pengujian Security RLS'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Masukkan UUID kos dan UUID pemilik (User A). '
                  'Pastikan aplikasi sedang login sebagai User B.',
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: kosIdController,
                  decoration: const InputDecoration(
                    labelText: 'UUID Kos milik User A',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: ownerIdController,
                  decoration: const InputDecoration(
                    labelText: 'UUID User A',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (kosIdController.text.trim().isEmpty ||
                    ownerIdController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('UUID tidak boleh kosong.'),
                    ),
                  );
                  return;
                }

                Navigator.pop(dialogContext, true);
              },
              child: const Text('Mulai Pengujian'),
            ),
          ],
        );
      },
    );

    if (result == true && mounted) {
      await _securityTest(
        kosIdController.text.trim(),
        ownerIdController.text.trim(),
      );
    }

    kosIdController.dispose();
    ownerIdController.dispose();
  }

  // Pengujian UPDATE, DELETE, dan INSERT menggunakan sesi User B.
  Future<void> _securityTest(
    String kosIdMilikUserA,
    String userAId,
  ) async {
    final kos = KosService();
    final client = Supabase.instance.client;

    final results = <String>[];

    // Pastikan pengguna sudah login.
    final currentUser = client.auth.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pengguna belum login.'),
        ),
      );
      return;
    }

    debugPrint('========== SECURITY TEST ==========');
    debugPrint('User B ID: ${currentUser.id}');
    debugPrint('User A ID: $userAId');
    debugPrint('Kos ID: $kosIdMilikUserA');

    if (currentUser.id == userAId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Gunakan akun User B, bukan akun pemilik data.',
          ),
        ),
      );
      return;
    }

    // 1. Pengujian UPDATE.
    try {
      final updated = await kos.update(
        kosIdMilikUserA,
        {'name': 'DIUBAH USER B'},
      );

      if (updated) {
        debugPrint(
          '[FAIL] User B berhasil mengubah data User A',
        );
        results.add('UPDATE: GAGAL (berhasil diubah)');
      } else {
        debugPrint('[PASS] UPDATE ditolak oleh RLS');
        results.add('UPDATE: PASS (ditolak RLS)');
      }
    } catch (e) {
      debugPrint('[PASS] UPDATE ditolak: $e');
      results.add('UPDATE: PASS (operasi ditolak)');
    }

    // 2. Pengujian DELETE.
    try {
      final deleted = await kos.delete(kosIdMilikUserA);

      if (deleted) {
        debugPrint(
          '[FAIL] User B berhasil menghapus data User A',
        );
        results.add('DELETE: GAGAL (berhasil dihapus)');
      } else {
        debugPrint('[PASS] DELETE ditolak oleh RLS');
        results.add('DELETE: PASS (ditolak RLS)');
      }
    } catch (e) {
      debugPrint('[PASS] DELETE ditolak: $e');
      results.add('DELETE: PASS (operasi ditolak)');
    }

    // 3. Pengujian INSERT atas nama User A.
    try {
      await client.from('kos').insert({
        'owner_id': userAId,
        'name': 'Kos Palsu',
        'address': 'Percobaan Security Testing',
        'price': 500000,
      });

      debugPrint(
        '[FAIL] INSERT atas nama User A berhasil',
      );
      results.add('INSERT: GAGAL (berhasil disimpan)');
    } on PostgrestException catch (e) {
      debugPrint(
        '[PASS] INSERT ditolak: ${e.code} - ${e.message}',
      );
      results.add('INSERT: PASS (ditolak RLS)');
    } catch (e) {
      debugPrint('[ERROR] INSERT: $e');
      results.add('INSERT: ERROR (periksa koneksi)');
    }

    debugPrint('========== HASIL PENGUJIAN ==========');

    for (final item in results) {
      debugPrint(item);
    }

    debugPrint('====================================');

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: Text(results.join('\n')),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserProfile?>(
      future: _profileFuture,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final p = snap.data;

        if (snap.hasError || p == null) {
          return const Scaffold(
            body: Center(
              child: Text('Gagal memuat profil'),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('KosFinder (${p.role})'),
            actions: [
              IconButton(
                tooltip: 'Logout',
                icon: const Icon(Icons.logout),
                onPressed: _logout,
              ),
            ],
          ),

          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Informasi pengguna.
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(
                  p.name.isEmpty ? p.email : p.name,
                ),
                subtitle: Text('${p.email} • ${p.role}'),
              ),

              const Divider(),

              // Daftar Kos.
              ListTile(
                leading: const Icon(Icons.list),
                title: const Text('Daftar Kos'),
                onTap: _openKosPage,
              ),

              // Detail Kos.
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Detail Kos'),
                onTap: _openKosPage,
              ),

              // My Kos hanya untuk Owner dan Admin.
              if (p.isOwner || p.isAdmin)
                ListTile(
                  leading: const Icon(Icons.home_work),
                  title: const Text('My Kos'),
                  onTap: _openKosPage,
                ),

              // Kelola Data hanya untuk Admin.
              if (p.isAdmin)
                const ListTile(
                  leading: Icon(Icons.admin_panel_settings),
                  title: Text('Kelola Data (Admin)'),
                ),

              const Divider(),

              // Tombol pengujian sementara untuk Praktik 6.
              ListTile(
                leading: const Icon(Icons.security),
                title: const Text('Uji Security RLS'),
                subtitle: const Text(
                  'Uji UPDATE, DELETE, dan INSERT',
                ),
                onTap: _showSecurityTestDialog,
              ),
            ],
          ),

          // Tombol Tambah Kos untuk Owner dan Admin.
          floatingActionButton: RoleGuard(
            role: p.role,
            allowed: const ['owner', 'admin'],
            child: FloatingActionButton.extended(
              onPressed: _openKosPage,
              icon: const Icon(Icons.add_home),
              label: const Text('Tambah Kos'),
            ),
          ),
        );
      },
    );
  }
}