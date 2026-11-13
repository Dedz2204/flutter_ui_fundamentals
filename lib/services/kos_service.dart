import 'package:supabase_flutter/supabase_flutter.dart';

class KosService {
  final SupabaseClient _client = Supabase.instance.client;

  // Mengambil ID user yang sedang login
  String get _uid {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception('User belum login.');
    }

    return user.id;
  }

  // Mengambil seluruh data kos
  Future<List<Map<String, dynamic>>> fetchAll() async {
    final data = await _client
        .from('kos')
        .select()
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(data);
  }

  // Menambahkan data kos
  Future<void> add({
    required String name,
    required String address,
    required int price,
  }) async {
    await _client.from('kos').insert({
      'owner_id': _uid,
      'name': name,
      'address': address,
      'price': price,
    });
  }

  // Mengubah data kos milik sendiri
  Future<bool> update(
    String id,
    Map<String, dynamic> values,
  ) async {
    // Hanya mengizinkan perubahan kolom berikut
    const allowedFields = ['name', 'address', 'price'];

    final safeValues = {
      for (final entry in values.entries)
        if (allowedFields.contains(entry.key))
          entry.key: entry.value,
    };

    if (safeValues.isEmpty) {
      throw ArgumentError('Tidak ada data yang dapat diperbarui.');
    }

    final rows = await _client
        .from('kos')
        .update(safeValues)
        .eq('id', id)
        .select();

    return rows.isNotEmpty;
  }

  // Menghapus data kos milik sendiri
  Future<bool> delete(String id) async {
    final rows = await _client
        .from('kos')
        .delete()
        .eq('id', id)
        .select();

    return rows.isNotEmpty;
  }
}