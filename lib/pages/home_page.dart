import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../screens/course_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _logout(BuildContext context) async {
    try {
      await AuthService.instance.logout();

      if (!context.mounted) return;

      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login',
        (route) => false,
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal logout: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.account_circle,
                size: 80,
              ),
              const SizedBox(height: 16),
              const Text(
                'Login Berhasil!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text('Email: ${user?.email ?? '-'}'),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const CoursePage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.school),
                  label: const Text('Buka Course Data Manager'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}