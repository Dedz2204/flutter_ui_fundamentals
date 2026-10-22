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

## Tahap 1 — Membaca REST Endpoint dan JSON

### Informasi Endpoint

- **URL:** https://jsonplaceholder.typicode.com/posts/1
- **HTTP Method:** GET
- **Status Code:** 200 OK (jika request berhasil)
- **Resource:** Post
- **Response Format:** JSON

### Struktur Response

| Field | Tipe Data | Keterangan |
|---|---|---|
| `userId` | Integer | ID pengguna pemilik post |
| `id` | Integer | ID post |
| `title` | String | Judul post |
| `body` | String | Isi post |

### Catatan

Endpoint ini digunakan untuk mengambil satu data post dari JSONPlaceholder. JSONPlaceholder merupakan API dummy untuk latihan. Operasi penulisan seperti POST, PUT, PATCH, dan DELETE hanya disimulasikan sehingga perubahan tidak disimpan secara permanen.
