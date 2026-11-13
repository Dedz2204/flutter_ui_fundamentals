import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/kos_service.dart';
import '../services/profile_service.dart';

class KosPage extends StatefulWidget {
  const KosPage({super.key});

  @override
  State<KosPage> createState() => _KosPageState();
}

class _KosPageState extends State<KosPage> {
  final KosService _kosService = KosService();
  final ProfileService _profileService = ProfileService();

  late Future<List<Map<String, dynamic>>> _kosFuture;

  UserProfile? _profile;
  bool _isLoadingProfile = true;

  String get _myId {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      throw Exception('User belum login.');
    }

    return user.id;
  }

  bool get _canManageKos =>
      _profile?.isOwner == true || _profile?.isAdmin == true;

  @override
  void initState() {
    super.initState();
    _loadKos();
    _loadProfile();
  }

  // Memuat daftar kos
  void _loadKos() {
    _kosFuture = _kosService.fetchAll();
  }

  // Memuat ulang daftar kos
  Future<void> _refreshKos() async {
    setState(_loadKos);
    await _kosFuture;
  }

  // Mengambil profil pengguna
  Future<void> _loadProfile() async {
    try {
      final profile = await _profileService.getMyProfile();

      if (!mounted) return;

      setState(() {
        _profile = profile;
        _isLoadingProfile = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoadingProfile = false;
      });

      _showMessage(
        'Gagal mengambil profil: $e',
        success: false,
      );
    }
  }

  // Menampilkan pesan
  void _showMessage(
    String message, {
    bool success = true,
  }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? Colors.green : Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Menampilkan dialog tambah kos
  Future<void> _showAddKosDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return _AddKosDialog(
          onSave: (name, address, price) async {
            await _kosService.add(
              name: name,
              address: address,
              price: price,
            );
          },
        );
      },
    );

    if (!mounted) return;

    if (result == true) {
      setState(_loadKos);

      _showMessage('Data kos berhasil ditambahkan!');
    }
  }

  // Pengujian INSERT menggunakan akun login
  Future<void> _testInsertRLS() async {
    try {
      await _kosService.add(
        name: 'Kos Pengujian RLS',
        address: 'Singaraja, Bali',
        price: 500000,
      );

      if (!mounted) return;

      setState(_loadKos);

      _showMessage('INSERT berhasil dilakukan!');
    } on PostgrestException catch (e) {
      _showMessage(
        'INSERT ditolak: ${e.code} - ${e.message}',
        success: false,
      );
    } catch (e) {
      _showMessage(
        'Gagal melakukan INSERT: $e',
        success: false,
      );
    }
  }

  // Pengujian INSERT atas nama pengguna lain
  Future<void> _testInsertAsUserA() async {
    final controller = TextEditingController();

    try {
      final userAId = await showDialog<String>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Uji INSERT Atas Nama User A'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'UUID User A',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(
                  dialogContext,
                  controller.text.trim(),
                ),
                child: const Text('Uji'),
              ),
            ],
          );
        },
      );

      if (!mounted) return;

      if (userAId == null || userAId.isEmpty) return;

      if (userAId == _myId) {
        _showMessage(
          'UUID harus berbeda dari akun yang sedang login.',
          success: false,
        );
        return;
      }

      try {
        await Supabase.instance.client.from('kos').insert({
          'owner_id': userAId,
          'name': 'Kos Palsu',
          'address': 'Percobaan Security Testing',
          'price': 500000,
        });

        if (!mounted) return;

        _showMessage(
          'FAIL: INSERT atas nama User A berhasil!',
          success: false,
        );

        setState(_loadKos);
      } on PostgrestException catch (e) {
        _showMessage(
          'PASS: INSERT ditolak RLS (${e.code})',
        );
      }
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'Terjadi kesalahan: $e',
        success: false,
      );
    } finally {
      controller.dispose();
    }
  }

  // Pengujian UPDATE RLS
  Future<void> _testUpdateRLS(
    Map<String, dynamic> kos,
  ) async {
    try {
      final currentName = kos['name'].toString();

      // Mengubah nama agar hasil UPDATE terlihat
      final updatedName = currentName.endsWith(' (Updated)')
          ? currentName.replaceAll(' (Updated)', '')
          : '$currentName (Updated)';

      final updated = await _kosService.update(
        kos['id'].toString(),
        {'name': updatedName},
      );

      if (!mounted) return;

      if (updated) {
        await _refreshKos();

        if (!mounted) return;

        _showMessage('UPDATE berhasil! Nama kos diperbarui.');
      } else {
        _showMessage(
          'UPDATE ditolak oleh RLS. Data tidak berubah.',
          success: false,
        );
      }
    } on PostgrestException catch (e) {
      _showMessage(
        'UPDATE ditolak: ${e.code} - ${e.message}',
        success: false,
      );
    } catch (e) {
      _showMessage(
        'Gagal menguji UPDATE: $e',
        success: false,
      );
    }
  }

  // Pengujian DELETE RLS
  Future<void> _testDeleteRLS(
    Map<String, dynamic> kos,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Uji DELETE RLS'),
          content: Text(
            'Apakah ingin menguji penghapusan data '
            '"${kos['name']}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(
                dialogContext,
                false,
              ),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(
                dialogContext,
                true,
              ),
              child: const Text('Uji Hapus'),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmed != true) return;

    try {
      final deleted = await _kosService.delete(
        kos['id'].toString(),
      );

      if (!mounted) return;

      _showMessage(
        deleted
            ? 'DELETE berhasil! Data kos telah dihapus.'
            : 'PASS: DELETE ditolak oleh RLS.',
      );

      setState(_loadKos);
    } on PostgrestException catch (e) {
      _showMessage(
        'DELETE ditolak: ${e.code} - ${e.message}',
        success: false,
      );
    } catch (e) {
      _showMessage(
        'Gagal menguji DELETE: $e',
        success: false,
      );
    }
  }

  // Kartu data kos
  Widget _buildKosCard(Map<String, dynamic> kos) {
    final isMine = kos['owner_id'] == _myId;

    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade50,
                child: const Icon(
                  Icons.home_work,
                  color: Colors.blue,
                ),
              ),
              title: Text(
                kos['name']?.toString() ?? '-',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(kos['address']?.toString() ?? '-'),
                  const SizedBox(height: 5),
                  Text(
                    'Rp ${kos['price'] ?? 0} / bulan',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    isMine
                        ? 'Data milik Anda'
                        : 'Data milik pengguna lain',
                    style: TextStyle(
                      fontSize: 11,
                      color: isMine ? Colors.green : Colors.orange,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _testUpdateRLS(kos),
                icon: const Icon(Icons.edit, size: 17),
                label: const Text('Uji UPDATE RLS'),
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _testDeleteRLS(kos),
                icon: const Icon(
                  Icons.delete_outline,
                  size: 17,
                  color: Colors.red,
                ),
                label: const Text(
                  'Uji DELETE RLS',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Kos'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: _refreshKos,
            icon: const Icon(Icons.refresh),
          ),

          if (!_isLoadingProfile && _canManageKos)
            IconButton(
              tooltip: 'Tambah Kos',
              onPressed: _showAddKosDialog,
              icon: const Icon(Icons.add),
            ),
        ],
      ),
      body: Column(
        children: [
          if (_isLoadingProfile)
            const LinearProgressIndicator()
          else
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                'Role: ${_profile?.role ?? 'Tidak diketahui'}',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _testInsertRLS,
                icon: const Icon(Icons.security, size: 17),
                label: const Text('Uji INSERT RLS'),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 4,
            ),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _testInsertAsUserA,
                icon: const Icon(Icons.person_off, size: 17),
                label: const Text('Uji INSERT Atas Nama User A'),
              ),
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _kosFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Gagal memuat data: ${snapshot.error}',
                    ),
                  );
                }

                final items = snapshot.data ?? [];

                if (items.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: _refreshKos,
                    child: ListView(
                      children: const [
                        SizedBox(height: 150),
                        Center(
                          child: Text('Belum ada data kos'),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _refreshKos,
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return _buildKosCard(items[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Dialog tambah kos
typedef SaveKosCallback = Future<void> Function(
  String name,
  String address,
  int price,
);

class _AddKosDialog extends StatefulWidget {
  final SaveKosCallback onSave;

  const _AddKosDialog({
    required this.onSave,
  });

  @override
  State<_AddKosDialog> createState() => _AddKosDialogState();
}

class _AddKosDialogState extends State<_AddKosDialog> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _priceController = TextEditingController();

  bool _isSaving = false;
  String? _errorMessage;

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      await widget.onSave(
        _nameController.text.trim(),
        _addressController.text.trim(),
        int.parse(_priceController.text.trim()),
      );

      if (!mounted) return;

      Navigator.of(context).pop(true);
    } on PostgrestException catch (e) {
      if (!mounted) return;

      setState(() {
        _isSaving = false;
        _errorMessage = 'Gagal menyimpan: ${e.code} - ${e.message}';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isSaving = false;
        _errorMessage = 'Gagal menambahkan kos: $e';
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _priceController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tambah Kos'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Kos',
                  prefixIcon: Icon(Icons.home),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama kos wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Alamat Kos',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Alamat kos wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Harga per Bulan',
                  prefixText: 'Rp ',
                  prefixIcon: Icon(Icons.payments),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final price = int.tryParse(value?.trim() ?? '');

                  if (price == null || price <= 0) {
                    return 'Masukkan harga yang valid';
                  }

                  return null;
                },
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving
              ? null
              : () => Navigator.of(context).pop(false),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _save,
          child: _isSaving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : const Text('Simpan'),
        ),
      ],
    );
  }
}