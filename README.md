# Course Data Manager

Aplikasi mobile berbasis Flutter untuk mengelola data mata kuliah. Proyek ini dikembangkan sebagai bagian dari praktikum dengan menggunakan Provider untuk pengelolaan state dan Supabase sebagai backend database.

## Identitas Mahasiswa

- **Nama:** Putu Agus Dedy Putra Adnyana
- **NIM:** 2415051104

## Fitur Aplikasi

- Menampilkan daftar mata kuliah.
- Menambahkan data mata kuliah.
- Mengedit data mata kuliah.
- Menghapus data mata kuliah.
- Mengelola mata kuliah favorit.
- Menampilkan status loading dan error.
- Menyediakan navigasi responsif.
- Menangani kegagalan request dan kesalahan pemetaan data.

## Teknologi yang Digunakan

- **Flutter:** framework untuk mengembangkan aplikasi mobile.
- **Dart:** bahasa pemrograman yang digunakan.
- **Provider:** pengelolaan state aplikasi menggunakan `ChangeNotifier`.
- **Supabase:** backend dan database berbasis PostgreSQL.
- **HTTP:** digunakan pada tahap pembelajaran REST API sebelumnya.

## Struktur Folder

- `models/`: menyimpan model data mata kuliah.
- `providers/`: mengelola state aplikasi.
- `repositories/`: menjadi perantara antara Provider dan Service.
- `services/`: menangani komunikasi dengan sumber data.
- `screens/`: menyimpan halaman aplikasi.
- `widgets/`: menyimpan komponen antarmuka yang dapat digunakan kembali.
- `test/`: menyimpan pengujian otomatis.

## Arsitektur Aplikasi

Alur arsitektur aplikasi:

`Screens/Widgets → Provider → Repository → Service/Data Source`

Penjelasan setiap bagian:

- **Screens/Widgets:** menampilkan antarmuka dan menerima interaksi pengguna.
- **Provider:** mengelola state dan menyediakan data kepada antarmuka.
- **Repository:** menjadi perantara pengelolaan dan pengambilan data.
- **Service/Data Source:** menangani komunikasi dengan sumber data.
- **Model:** merepresentasikan struktur data mata kuliah.

## Backend dan Database

Aplikasi menggunakan Supabase dengan database PostgreSQL untuk menyimpan data mata kuliah. Operasi CRUD (Create, Read, Update, Delete) dilakukan terhadap tabel `courses`.

Kolom utama tabel meliputi:

- `id`: identitas mata kuliah.
- `code`: kode mata kuliah.
- `title`: nama mata kuliah.
- `credits`: jumlah SKS.
- `status`: status mata kuliah.
- `created_at`: waktu pembuatan data.

Row Level Security (RLS) digunakan untuk mengatur akses ke database sesuai dengan kebijakan yang diterapkan.

## Persiapan dan Cara Menjalankan

1. Instal Flutter SDK dan siapkan perangkat atau emulator.
2. Clone repository proyek ini.
3. Buka folder proyek menggunakan VS Code.
4. Unduh dependensi dengan menjalankan:

   ```bash
   flutter pub get
   ```

5. Pastikan URL dan publishable key atau anon key Supabase telah dikonfigurasi sesuai dengan konfigurasi proyek.
6. Jalankan aplikasi menggunakan:

   ```bash
   flutter run
   ```

## Pengujian

Untuk memeriksa kesalahan analisis kode, jalankan:

```bash
flutter analyze
```

Untuk menjalankan pengujian otomatis, gunakan:

```bash
flutter test
```

## Keamanan

- Jangan menyimpan `service_role` key, password, atau token rahasia di dalam source code maupun repository.
- Jangan mengunggah file `.env` yang berisi informasi rahasia.
- Terapkan RLS dan kebijakan database yang sesuai untuk mengatur akses data.
- Validasi pada antarmuka tidak menggantikan validasi dan otorisasi di backend.
- Gunakan hanya publishable key atau anon key yang sesuai untuk aplikasi klien, dengan kebijakan akses database yang benar.