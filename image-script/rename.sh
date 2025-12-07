#!/bin/bash

# Find all jpg and png files and process them using xargs for efficiency
find . -type f \( -iname "*.jpg" -o -iname "*.png"  -o -iname "*.JPG"  -o -iname "*.PNG" \) -print0 | while IFS= read -r -d '' input_file; do

    extension="${input_file##*.}"
    # Get the source filename without the extension and without the path
    src_filename="${input_file##*/}"
    src_filename="${src_filename%.*}"

    pathname="${input_file%/*}/"

    # Derive the output filename: lowercase and remove spaces and special characters
    dst_filename=$(echo "$src_filename" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9_-]/_/g')
    output_file="${pathname}${dst_filename}.${extension}"

    if [[ "$input_file" == "$output_file" ]]; then
        echo "Skipping: $input_file no need to rename."
        continue
    fi

    echo "Renaming: $input_file -> $output_file"
    mv "$input_file" "$output_file"

done

echo "Image processing complete."