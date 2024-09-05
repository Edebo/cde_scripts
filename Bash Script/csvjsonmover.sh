#!/bin/bash
# Make this script executable (self-modifying)
chmod +x "$0"
# Source folder (the folder where the CSV and JSON files are located)
source_folder="./Files"

# Destination folder (where the CSV and JSON files will be moved)
destination_folder="json_and_CSV"

# Create the destination folder if it doesn't exist
if [ ! -d "$destination_folder" ]; then
    mkdir -p "$destination_folder"
    echo "Created destination folder: $destination_folder"
fi

# Move all CSV and JSON files to the destination folder
mv "$source_folder"/*.csv "$source_folder"/*.json "$destination_folder" 2>/dev/null

# Check if the move was successful
if [ $? -eq 0 ]; then
    echo "Successfully moved all CSV and JSON files to $destination_folder."
else
    echo "No CSV or JSON files found in $source_folder or an error occurred."
fi
