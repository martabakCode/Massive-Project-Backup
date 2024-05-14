#!/usr/bin/expect -f

# Mendefinisikan variabel
set backup_script "backup_enkripsi.sh"
set password "redhat"

# Menjalankan backup.sh
spawn ./$backup_script

# Menunggu permintaan masukan kata sandi
expect "Enter password:"

# Mengirimkan kata sandi
send "$password\r"

# Menunggu proses selesai
expect eof
