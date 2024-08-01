# WHM Backup Checker

A Bash script to check WHM/cPanel backup files for common issues before restoration.

## Features

- Verifies file existence
- Checks file permissions
- Ensures sufficient disk space
- Confirms file integrity
- Checks MySQL/MariaDB service

## Usage

```bash
./check_backup.sh /path/to/backup_file.tar.gz

