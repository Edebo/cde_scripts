#!/bin/bash

# Make this script executable (self-modifying)
chmod +x "$0"

# URL of the CSV file
url="https://www.stats.govt.nz/assets/Uploads/Annual-enterprise-survey/Annual-enterprise-survey-2023-financial-year-provisional/Download-data/annual-enterprise-survey-2023-financial-year-provisional.csv"

# Output filename# Configuration
HOST="your_host"        # PostgreSQL host
PORT="5432"             # PostgreSQL port (default is 5432)
USER="your_user"        # PostgreSQL user
DBNAME="posey"        # PostgreSQL database name
TABLE="financial"      # Target table in PostgreSQL
# Extract the file name
filename=$(basename "${url%%\?*}")
# Download the file using curl
curl -O "$url"

# Check if the CSV file exists
if [ ! -f "$CSV_FILE" ]; then
    echo "Error: CSV file not found at $CSV_FILE"
    exit 1
fi

# Import CSV into PostgreSQL using \COPY
psql -h "$HOST" -p "$PORT" -U "$USER" -d "$DBNAME" -c "\COPY $TABLE FROM '$CSV_FILE' DELIMITER ',' CSV HEADER;"

# Check if the import was successful
if [ $? -eq 0 ]; then
    echo "CSV file imported successfully into $TABLE."
else
    echo "Error importing CSV file into $TABLE."
    exit 1
fi