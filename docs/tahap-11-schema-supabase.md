# Tahap 11 - Schema Database Supabase

## Tabel courses

Tabel `public.courses` dibuat melalui Supabase Dashboard.

| Kolom | Tipe Data | Keterangan |
|---|---|---|
| id | BIGINT IDENTITY | Primary key |
| code | TEXT | Kode mata kuliah |
| title | TEXT | Judul mata kuliah |
| credits | INT | Jumlah SKS |
| status | TEXT | planned, active, atau done |
| created_at | TIMESTAMPTZ | Waktu pembuatan otomatis |

## Constraint

Kolom `status` menggunakan CHECK constraint
yang membatasi nilai menjadi `planned`, `active`,
atau `done`.

## Data Awal

| Code | Title | Credits | Status |
|---|---|---|---|
| IF101 | Pemrograman Mobile | 3 | active |
| IF102 | Jaringan Komputer | 3 | planned |
| IF103 | Basis Data | 3 | done |

## Row Level Security (RLS)

RLS diaktifkan pada tabel `public.courses`.

Policy yang dibuat untuk kebutuhan praktikum:

- Lab allow read courses (SELECT)
- Lab allow insert courses (INSERT)
- Lab allow update courses (UPDATE)
- Lab allow delete courses (DELETE)

Keempat policy diterapkan pada role `anon`
dengan aturan permisif untuk kebutuhan praktikum.
Konfigurasi ini bukan rekomendasi untuk produksi.

## Catatan

Tabel, data awal, dan policy dibuat melalui
Supabase Dashboard. File ini mendokumentasikan
konfigurasi tersebut dan bukan skrip untuk
dijalankan ulang pada database yang sama.
