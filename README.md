# flutter_application_1

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## Struktur Folder dan Tanggung Jawab

- **models/**: Menyimpan model data mata kuliah.
- **providers/**: Mengelola state menggunakan ChangeNotifier dan memberi tahu UI saat terjadi perubahan.
- **repositories/**: Menjadi perantara antara Provider dan Service dalam pengambilan data.
- **services/**: Membaca data JSON dan mengubahnya menjadi objek model.
- **screens/**: Menyediakan halaman utama, detail mata kuliah, dan halaman favorit.
- **widgets/**: Menyimpan komponen UI yang dapat digunakan kembali.

### Arah Dependency

Arah dependency aplikasi adalah Screens/Widgets → Provider → Repository → Service/Data Source. UI tidak membaca JSON secara langsung, Service tidak menangani tampilan, dan Provider tidak menyimpan BuildContext sebagai state.
