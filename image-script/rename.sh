#!/bin/bash

# Find all jpg and png files and process them using xargs for efficiency
find . -type f \( -iname "*.jpg" -o -iname "*.png" \) -print0 | while IFS= read -r -d '' input_file; do

    # Derive the output filename: lowercase and remove spaces and special characters
    output_file=$(echo "$input_file" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9.:_-]/_/g')

    if [[ "$input_file" == "$output_file" ]]; then
        echo "Skipping: $input_file is already in the desired format."
        continue
    fi

    echo "Renaming: $input_file -> $output_file"
    mv "$input_file" "$output_file"

done

echo "Image processing complete."