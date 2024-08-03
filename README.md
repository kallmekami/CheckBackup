# WHM Backup Checker
This Bash script checks WHM/cPanel backup files for common issues before restoration. It verifies file existence, checks permissions, ensures sufficient disk space, confirms file integrity, and checks that MySQL/MariaDB service is running. Use it to identify and resolve potential problems with your backup files.


## Features

- Verifies file existence
- Checks file permissions
- Ensures sufficient disk space
- Confirms file integrity
- Checks MySQL/MariaDB service

## Usage

```bash
./check_backup.sh /path/to/backup_file.tar.gz

