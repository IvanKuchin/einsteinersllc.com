#!/bin/bash

# Find all jpg and png files and process them using xargs for efficiency
find . -type f \( -iname "*.jpg" -o -iname "*.png" \) -print0 | while IFS= read -r -d '' input_file; do

    extension="${input_file##*.}"
    # Get the source filename without the extension and without the path
    src_filename="${input_file##*/}"
    src_filename="${src_filename%.*}"

    pathname="${input_file%/*}/"

    # Derive the output filename: lowercase and remove spaces and special characters
    dst_filename=$(echo "$src_filename" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9_-]/_/g')

    if [[ "$src_filename" == "$dst_filename" ]]; then
        echo "Skipping: $input_file is already in the desired format."
        continue
    fi

    echo "Renaming: $src_filename.$extension -> $dst_filename.$extension"
    # mv "$input_file" "$dst_filename"

done

echo "Image processing complete."