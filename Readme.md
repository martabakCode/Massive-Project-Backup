# Web Files Backup and Transfer Script

This Bash script automates the process of backing up web files, compressing them, and transferring the compressed backup to another server using rsync.

## Features

- Backup web files from a specified directory.
- Compress the backup into a tar.gz archive.
- Transfer the compressed backup to another server securely using rsync.
- Optional cleanup to remove local backup archives.

## Prerequisites

- Unix-like operating system (Linux, macOS, etc.).
- Bash shell.
- SSH access to the destination server for rsync.

## Usage

1. Clone or download the repository to your local machine:

    ```
    git clone https://github.com/yourusername/web-files-backup.git
    ```

2. Modify the configuration variables in the `backup.sh` script:

    - `source_dir`: Path to the directory containing your web files.
    - `destination_server`: SSH username and IP address of the destination server.
    - `destination_dir`: Path to the directory on the destination server where you want to copy the files.
    - `backup_dir`: Local directory where backup archives will be stored.

3. Make the script executable:

    ```
    chmod +x backup.sh
    ```

4. Schedule the script to run periodically using cron jobs. For example, to run it every Sunday at 01:00 AM:

    ```
    0 1 * * 0 /path/to/backup.sh
    ```

    Replace `/path/to/backup.sh` with the actual path to the script.

5. (Optional) Customize cleanup behavior:
    - If you want to remove older backup archives to save disk space, uncomment the relevant lines in the script.

## License

This project is licensed under the [Sisingamangaraja License].