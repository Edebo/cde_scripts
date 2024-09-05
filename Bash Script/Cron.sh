#!/bin/bash
# Make this script executable (self-modifying)
chmod +x "$0"
# Path to the script to be scheduled
etl_script="./etl.sh"

# Cron job that runs every day at 12:00 AM
cron_job="0 0 * * * $etl_script"

# Check if the cron job already exists
crontab -l | grep -q "$etl_script"

# If the cron job doesn't exist, add it
if [ $? -eq 1 ]; then
    (crontab -l; echo "$cron_job") | crontab -
    echo "Scheduled $etl_script to run daily at 12:00 AM."
else
    echo "The script is already scheduled."
fi
