#!/bin/bash

# Direktori sumber di mana berkas web Anda berada
source_dir="/var/www/html/backup.com/public"

# Detail server tujuan
destination_server="root@node2"
destination_dir="~/serverlogs"

# Direktori backup
backup_dir="/home/backup"

# Buat penanda waktu untuk nama folder backup
timestamp=$(date +"%Y%m%d%H%M%S")

# Buat direktori baru untuk backup menggunakan penanda waktu
backup_folder="${backup_dir}/backup_${timestamp}"

# Konfigurasi Database
db_user_encrypted="U2FsdGVkX19Zd3J2bk3lPU/8VK3MW+XN"
db_password_encrypted="U2FsdGVkX1/wwn6BfTC5p40DCG+D5Bpl"
db_name="backup_project"

# Dekripsi user dan password database
db_user=$(echo "$db_user_encrypted" | openssl enc -aes-256-cbc -pbkdf2 -d -a -salt -pass pass:redhat)
db_password=$(echo "$db_password_encrypted" | openssl enc -aes-256-cbc -pbkdf2 -d -a -salt -pass pass:redhat)

# Buat direktori backup jika belum ada
mkdir -p "$backup_folder"

# Lakukan backup
cp -r "$source_dir" "$backup_folder"

# Periksa apakah backup berhasil
if [ $? -eq 0 ]; then
    echo "Backup berhasil. Berkas disalin ke: $backup_folder"
else
    echo "Backup gagal."
    exit 1
fi

# Backup database
db_backup_file="${backup_folder}/${db_name}_backup.sql"
mysqldump -u "$db_user" -p"$db_password" "$db_name" > "$db_backup_file"

# Periksa apakah backup database berhasil
if [ $? -eq 0 ]; then
    echo "Backup database berhasil. Berkas disimpan sebagai: $db_backup_file"
else
    echo "Backup database gagal."
    exit 1
fi

# Kompresi folder backup
backup_archive="${backup_folder}.tar.gz"
tar -czf "$backup_archive" -C "$backup_dir" "backup_${timestamp}"

# Periksa apakah kompresi berhasil
if [ $? -eq 0 ]; then
    echo "Kompresi berhasil. Arsip backup dibuat: $backup_archive"
else
    echo "Kompresi gagal."
    exit 1
fi

# Enkripsi file tar.gz
openssl enc -aes-256-cbc -pbkdf2 -salt -in "$backup_archive" -out "${backup_archive}.enc" -pass pass:redhat

# Periksa apakah enkripsi berhasil
if [ $? -eq 0 ]; then
    echo "Enkripsi berhasil. Arsip backup dienkripsi: ${backup_archive}.enc"
else
    echo "Enkripsi gagal."
    exit 1
fi

# Transfer arsip backup ke server tujuan menggunakan rsync
rsync -avz --progress "${backup_archive}.enc" "$destination_server:$destination_dir"

# Periksa apakah rsync berhasil
if [ $? -eq 0 ]; then
    echo "Arsip backup berhasil ditransfer ke $destination_server:$destination_dir"
else
    echo "Transfer gagal."
    exit 1
fi

# Pembersihan: Hapus arsip backup lokal
rm -f "$backup_archive" "${backup_archive}.enc"
rm -rf "$backup_folder"
# Opsional, Anda mungkin ingin menghapus backup lama untuk menghemat ruang disk
# Contoh: find "$backup_dir" -type f -name "backup_*.tar.gz" -mtime +7 -exec rm {} \;
