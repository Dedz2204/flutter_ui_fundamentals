import 'package:flutter/material.dart';

import '../services/kos_service.dart';

class KosDetailPage extends StatefulWidget {
  const KosDetailPage({
    super.key,
    required this.kosId,
  });

  final String kosId;

  @override
  State<KosDetailPage> createState() => _KosDetailPageState();
}

class _KosDetailPageState extends State<KosDetailPage> {
  final KosService _kosService = KosService();

  late Future<Map<String, dynamic>?> _kosFuture;

  @override
  void initState() {
    super.initState();
    _kosFuture = _kosService.fetchById(widget.kosId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Kos'),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _kosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Gagal mengambil detail kos: ${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          final kos = snapshot.data;

          if (kos == null) {
            return const Center(
              child: Text('Data kos tidak ditemukan.'),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Icon(
                    Icons.home_work,
                    size: 90,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  kos['name']?.toString() ?? '-',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  'Alamat Kos',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(kos['address']?.toString() ?? '-'),

                const SizedBox(height: 20),

                const Text(
                  'Harga per Bulan',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Rp ${kos['price'] ?? 0}',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'ID Kos',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                SelectableText(widget.kosId),
              ],
            ),
          );
        },
      ),
    );
  }
}