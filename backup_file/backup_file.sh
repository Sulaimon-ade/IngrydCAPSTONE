#!/bin/bash

# Backup Configuration
# gave permision to the paths where I am backing  up and where to back up to.
BACKUP_SOURCE="/home/king" #"/path/to/important/files"
BACKUP_DESTINATION="/backups" #"/path/to/backup/folder"
BACKUP_NAME="backup_$(date +%Y%m%d_%H%M%S)"
LOG_FILE="/backups/backup_script.log"
EMAIL_ADDRESS="okunoyesouleiman@gmail.com"

#make $USER the owner of the backup folder and log files
#chown $USER:$USER $BACKUP_DESTINATION 

# Function to create backup archive
create_backup() {
    sudo tar -czf "$BACKUP_DESTINATION/$BACKUP_NAME.tar.gz" "$BACKUP_SOURCE"
}

# Function for rotation policy
rotate_backups() {
    sudo find "$BACKUP_DESTINATION" -type f -name "backup_*" -mtime +7 -exec rm {} \;
}

# Function for logging
log_backup() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Backup executed successfully" | sudo tee -a  "$LOG_FILE" > /dev/null
}

# Function to send email with the backup file
send_email() {
    echo "Sending backup file to $EMAIL_ADDRESS..."
    uuencode "$BACKUP_DESTINATION/$BACKUP_NAME.tar.gz" "$BACKUP_NAME.tar.gz" | mail -s "Backup File" "$EMAIL_ADDRESS"
    echo "Backup file sent successfully."
}

# Main function
main() {
    echo "Running Backup Automation Script..."

    create_backup
    rotate_backups
    log_backup

    echo "Backup Automation Script completed."
}

# Run the main function
main

