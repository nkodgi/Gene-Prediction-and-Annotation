#!/bin/bash

# Get the current directory
WORKING_DIR=$(pwd)
LOG_FILE="$WORKING_DIR/conversion.log"

# Start the log file
echo "Starting annotation conversion on $(date)" > "$LOG_FILE"

# Process each .annotations file in the directory
for file in "$WORKING_DIR"/*.annotations; do
    if [[ -f "$file" ]]; then
        # Generate output .tsv filename
        output_file="${file%.annotations}.tsv"
        
        # Log file being processed
        echo "Processing: $file -> $output_file" | tee -a "$LOG_FILE"

        # Extract the header
        grep '^#query_name' "$file" > "$output_file"

        # Extract non-comment lines and append
        grep -v '^#' "$file" >> "$output_file"

        echo "Finished processing: $file" | tee -a "$LOG_FILE"
    fi
done

echo "Annotation conversion completed on $(date)" | tee -a "$LOG_FILE"

