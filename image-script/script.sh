#!/bin/bash

# --- Configuration ---
MAX_WIDTH=1024
MAX_HEIGHT=768
SUFFIX=".resized"
# ---------------------

# Check if ffmpeg is installed
if ! command -v ffmpeg &> /dev/null
then
    echo "Error: ffmpeg is not installed or not in your PATH."
    echo "Please install ffmpeg before running this script."
    exit 1
fi

echo "Starting image resize operation..."
echo "Max dimensions: ${MAX_WIDTH}x${MAX_HEIGHT}. Suffix: ${SUFFIX}"

# Find all jpg and png files and process them using xargs for efficiency
find . -type f \( -iname "*.jpg" -o -iname "*.png" \) -print0 | while IFS= read -r -d '' input_file; do

    # Derive the output filename: insert the suffix before the extension
    extension="${input_file##*.}"
    filename="${input_file%.*}"
    output_file="${filename}${SUFFIX}.${extension}"

    # Check if the output file already exists to prevent reprocessing
    if [[ -f "$output_file" ]]; then
        echo "Skipping: $output_file already exists."
        continue
    fi
    
    echo "Processing: $input_file -> $output_file"

    # Run the ffmpeg command
    ffmpeg -i "$input_file" -vf "scale='min($MAX_WIDTH,iw)':min'($MAX_HEIGHT,ih)':force_original_aspect_ratio=decrease" -q:v 2 "$output_file"

    if [[ $? -eq 0 ]]; then
        echo "Successfully resized $input_file" > ./success.log
        mv "$output_file" "$input_file"
    else
        echo "Failed to resize $input_file" > ./error.log
    fi

done

echo "Image processing complete."