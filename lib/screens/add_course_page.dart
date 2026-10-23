import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';

class AddCoursePage extends StatefulWidget {
  const AddCoursePage({super.key});

  @override
  State<AddCoursePage> createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  final _formKey = GlobalKey<FormState>();

  final _codeController = TextEditingController();
  final _titleController = TextEditingController();
  final _creditsController = TextEditingController();

  String _status = 'planned';

  @override
  void dispose() {
    _codeController.dispose();
    _titleController.dispose();
    _creditsController.dispose();
    super.dispose();
  }

  Future<void> _saveCourse() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final courseProvider = context.read<CourseProvider>();

    final course = Course(
      id: DateTime.now().millisecondsSinceEpoch,
      code: _codeController.text.trim(),
      title: _titleController.text.trim(),
      credits: int.parse(_creditsController.text.trim()),
      status: _status,
    );

    try {
      await courseProvider.createCourse(course);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mata kuliah berhasil ditambahkan.'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan mata kuliah: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Mata Kuliah'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Putu Agus Dedy Putra Adnyana',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Text('NIM: 2415051104'),
              const SizedBox(height: 24),

              // Input kode mata kuliah
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Kode Mata Kuliah',
                  hintText: 'Contoh: PTI701',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.code),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Kode mata kuliah wajib diisi.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Input nama mata kuliah
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Nama Mata Kuliah',
                  hintText: 'Contoh: Pemrograman Mobile',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.book),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama mata kuliah wajib diisi.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Input jumlah SKS
              TextFormField(
                controller: _creditsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah SKS',
                  hintText: 'Contoh: 3',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.numbers),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Jumlah SKS wajib diisi.';
                  }

                  final credits = int.tryParse(value.trim());

                  if (credits == null) {
                    return 'Jumlah SKS harus berupa angka bulat.';
                  }

                  if (credits <= 0) {
                    return 'Jumlah SKS harus lebih dari 0.';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Pilihan status
              DropdownButtonFormField<String>(
                initialValue: _status,
                decoration: const InputDecoration(
                  labelText: 'Status Mata Kuliah',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.flag),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'planned',
                    child: Text('Planned'),
                  ),
                  DropdownMenuItem(
                    value: 'active',
                    child: Text('Active'),
                  ),
                  DropdownMenuItem(
                    value: 'done',
                    child: Text('Done'),
                  ),
                ],
                onChanged: provider.isSaving
                    ? null
                    : (value) {
                        if (value != null) {
                          setState(() {
                            _status = value;
                          });
                        }
                      },
              ),
              const SizedBox(height: 24),

              // Tombol simpan dengan indikator loading
              ElevatedButton.icon(
                onPressed: provider.isSaving ? null : _saveCourse,
                icon: provider.isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(
                  provider.isSaving
                      ? 'Menyimpan...'
                      : 'Simpan Mata Kuliah',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
