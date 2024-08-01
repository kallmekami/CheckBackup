#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 /path/to/backup_file"
    exit 1
}

# Check if backup file path is provided
if [ -z "$1" ]; then
    usage
fi

BACKUP_FILE="$1"

# 1. Verify if the backup file exists
if [ ! -f "$BACKUP_FILE" ]; then
    echo "Error: Backup file '$BACKUP_FILE' not found."
    exit 1
fi
echo "Backup file '$BACKUP_FILE' found."

# 2. Check the file permissions
if [ ! -r "$BACKUP_FILE" ]; then
    echo "Error: Backup file '$BACKUP_FILE' is not readable."
    exit 1
fi
echo "Backup file '$BACKUP_FILE' is readable."

# 3. Ensure there is enough disk space
REQUIRED_SPACE=$(du -sh "$BACKUP_FILE" | cut -f1)
AVAILABLE_SPACE=$(df -h "$(dirname "$BACKUP_FILE")" | awk 'NR==2 {print $4}')
echo "Required space for restore: $REQUIRED_SPACE"
echo "Available space: $AVAILABLE_SPACE"

# Convert space to a format for comparison
required_space_bytes=$(du -sb "$BACKUP_FILE" | awk '{print $1}')
available_space_bytes=$(df --output=avail -k "$(dirname "$BACKUP_FILE")" | awk 'NR==2 {print $1}' | awk '{print $1*1024}')

if (( required_space_bytes > available_space_bytes )); then
    echo "Error: Not enough disk space available."
    exit 1
fi
echo "Sufficient disk space available."

# 4. Check if the file is corrupted (using tar)
if ! tar tzf "$BACKUP_FILE" > /dev/null 2>&1; then
    echo "Error: Backup file '$BACKUP_FILE' is corrupted."
    exit 1
fi
echo "Backup file '$BACKUP_FILE' is valid and not corrupted."

# 5. Verify the MySQL service is running
if ! systemctl is-active --quiet mysql && ! systemctl is-active --quiet mariadb; then
    echo "Error: MySQL/MariaDB service is not running."
    exit 1
fi
echo "MySQL/MariaDB service is running."

echo "All checks passed. The backup file '$BACKUP_FILE' is ready for restoration."
