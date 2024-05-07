#!/bin/bash

# Source directory where your web files are located
source_dir="/var/www/html"

# Destination server details
destination_server="root@serverb"
destination_dir="~/serverlogs"

# Backup directory
backup_dir="/path/to/backup/directory"

# Create a timestamp for the backup folder name
timestamp=$(date +"%Y%m%d%H%M%S")

# Create a new directory for the backup using the timestamp
backup_folder="${backup_dir}/backup_${timestamp}"

#Database Configuration
db_user="root"
db_password="root"
db_name="backup_project"

# Create the backup directory if it doesn't exist
mkdir -p "$backup_folder"

# Perform the backup
cp -r "$source_dir" "$backup_folder"

# Check if the backup was successful
if [ $? -eq 0 ]; then
    echo "Backup completed successfully. Files copied to: $backup_folder"
else
    echo "Backup failed."
    exit 1
fi

# Database backup
db_backup_file="${backup_folder}/${db_name}_backup.sql"
mysqldump -u "$db_user" -p"$db_password" "$db_name" > "$db_backup_file"

# Check if database backup was successful
if [ $? -eq 0 ]; then
    echo "Database backup completed successfully. File saved as: $db_backup_file"
else
    echo "Database backup failed."
    exit 1
fi


# Compress the backup folder
backup_archive="${backup_folder}.tar.gz"
tar -czf "$backup_archive" -C "$backup_dir" "backup_${timestamp}"

# Check if compression was successful
if [ $? -eq 0 ]; then
    echo "Compression completed successfully. Backup archive created: $backup_archive"
else
    echo "Compression failed."
    exit 1
fi

# Transfer the backup archive to the destination server using rsync
rsync -avz --progress "$backup_archive" "$destination_server:$destination_dir"

# Check if rsync was successful
if [ $? -eq 0 ]; then
    echo "Backup archive transferred successfully to $destination_server:$destination_dir"
else
    echo "Transfer failed."
    exit 1
fi

# Cleanup: Remove the local backup archive
rm -f "$backup_archive"

# Optionally, you may want to remove older backups to save disk space
# Example: find "$backup_dir" -type f -name "backup_*.tar.gz" -mtime +7 -exec rm {} \;