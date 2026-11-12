import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/profile_service.dart';

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

    // Mengambil profil pengguna ketika halaman dibuka.
    _profileFuture = ProfileService().getMyProfile();
  }

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
        SnackBar(
          content: Text('Gagal logout: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),

      body: FutureBuilder<UserProfile?>(
        future: _profileFuture,
        builder: (context, snapshot) {
          // Menampilkan loading ketika mengambil profil.
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Menangani jika profil gagal dimuat.
          if (snapshot.hasError || snapshot.data == null) {
            return const Center(
              child: Text('Gagal memuat profil pengguna'),
            );
          }

          final profile = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const SizedBox(height: 20),

              const Icon(
                Icons.account_circle,
                size: 80,
              ),

              const SizedBox(height: 16),

              const Center(
                child: Text(
                  'Login Berhasil!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Informasi Nama.
              Card(
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Nama'),
                  subtitle: Text(
                    profile.name.isEmpty ? '-' : profile.name,
                  ),
                ),
              ),

              // Informasi Email.
              Card(
                child: ListTile(
                  leading: const Icon(Icons.email),
                  title: const Text('Email'),
                  subtitle: Text(profile.email),
                ),
              ),

              // Informasi Role.
              Card(
                child: ListTile(
                  leading: const Icon(Icons.badge),
                  title: const Text('Role'),
                  subtitle: Text(profile.role),
                ),
              ),

              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}