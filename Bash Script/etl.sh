#!/bin/bash

# Make this script executable (self-modifying)
chmod +x "$0"

# URL of the CSV file
url="https://www.stats.govt.nz/assets/Uploads/Annual-enterprise-survey/Annual-enterprise-survey-2023-financial-year-provisional/Download-data/annual-enterprise-survey-2023-financial-year-provisional.csv"
rawFolder="raw"
transformFile="2023_year_finance.csv"
transformFolder="Transformed"
loadFolder="Gold"
transformFilePath="$transformFolder/$transformFile"
# Output filename
# Extract the file name
filename=$(basename "${url%%\?*}")
echo $rawFolder

rawFullFilePath="$rawFolder/$filename"
#create a folder name raw
mkdir -p "$rawFolder"

# Download the file using curl
curl -O "$url"

# Check if the download was successful
if [ $? -eq 0 ]; then
  echo "CSV file downloaded successfully as $filename."
  mv "$filename" "$rawFullFilePath"
  sed -i '1s/Variable_code/variable_code/' "$rawFullFilePath"
  
  mkdir -p "$transformFolder"
  cd "$transformFolder"
  touch "$transformFile"
  cd ..
  
  ####TASK 1:TRANSFORM
# Columns to select (by name)
  columns=("Year" "Value" "Units" "variable_code")

  # Create an associative array to map column names to their indices
  declare -A column_indices

  # Read the header (first line) to get column names and their positions
  header=$(head -n 1 "$rawFullFilePath")
  echo "$header"


  # Initialize a counter for the column position
  i=1
  IFS=',' read -ra headers <<< "$header"
  for col in "${headers[@]}"; do
      column_indices["$col"]=$i
      ((i++))
  done

# Prepare awk column extraction string based on selected column names
awk_script="{ print "
for col in "${columns[@]}"; do
    awk_script+="$"$(echo "${column_indices[$col]}")","
done
awk_script="${awk_script%,} }"  # Remove trailing comma and close print statement

# # Print the header for the selected columns
#echo "${columns[*]}" | tr ' ' ',' > selected_columns.csv

# # Use awk to extract the desired columns based on calculated indices
awk -F',' "$awk_script" "$rawFullFilePath" >> "$transformFilePath"

# # Output a success message
echo "Selected columns have been written to $transformFilePath"

# Check if the file exists
if [ -f "$transformFilePath" ]; then
    echo "File $transformFilePath exists."
    
    mkdir -p "$loadFolder"
    mv $transformFilePath "$loadFolder/$transformFile"
else
    echo "File $csv_file does not exist."
fi

else
  echo "Failed to download the CSV file."


fi
