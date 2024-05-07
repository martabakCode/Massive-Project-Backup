# Script Pencadangan dan Transfer File dan Database

Skrip Bash ini mengotomatisasi proses pencadangan file web dan database, memampatkan mereka, dan mentransfer pencadangan yang sudah dipampatkan ke server lain menggunakan rsync.

## Fitur

- Mencadangkan file web dari direktori yang ditentukan.
- Mencadangkan database MySQL atau MariaDB.
- Memampatkan pencadangan menjadi arsip tar.gz.
- Mentransfer pencadangan yang sudah dipampatkan ke server lain secara aman menggunakan rsync.
- Opsional membersihkan pencadangan lokal yang sudah tidak diperlukan.

## Prasyarat

- Sistem operasi mirip Unix (Linux, macOS, dll.).
- Shell Bash.
- Akses SSH ke server tujuan untuk rsync.
- Utilitas `mysqldump` terinstal untuk pencadangan database (untuk database MySQL atau MariaDB).

## Penggunaan

1. Clone atau unduh repositori ke mesin lokal Anda:

    ```
    git clone https://github.com/yourusername/web-files-and-db-backup.git
    ```

2. Ubah variabel konfigurasi dalam skrip `backup.sh`:

    - `source_dir`: Jalur ke direktori yang berisi file web Anda.
    - `destination_server`: Nama pengguna SSH dan alamat IP server tujuan.
    - `destination_dir`: Jalur ke direktori di server tujuan di mana Anda ingin menyalin file.
    - `backup_dir`: Direktori lokal di mana arsip pencadangan akan disimpan.
    - `db_user`: Nama pengguna untuk database MySQL atau MariaDB.
    - `db_password`: Kata sandi untuk database MySQL atau MariaDB.
    - `db_name`: Nama database MySQL atau MariaDB yang ingin Anda cadangkan.

3. Jadikan skrip tersebut dapat dieksekusi:

    ```
    chmod +x backup.sh
    ```

4. Jadwalkan skrip untuk berjalan secara berkala menggunakan cron jobs. Misalnya, untuk menjalankannya setiap Minggu pukul 01:00 pagi:

    ```
    0 1 * * 0 /path/to/backup.sh
    ```

    Ganti `/path/to/backup.sh` dengan jalur aktual ke skrip.

5. (Opsional) Sesuaikan perilaku pembersihan:
    - Jika Anda ingin menghapus arsip pencadangan lama untuk menghemat ruang disk, hilangkan komentar pada baris yang relevan dalam skrip.

## Lisensi

Projek ini dilisensikan di bawah oleh Sisingamangaraja team.
