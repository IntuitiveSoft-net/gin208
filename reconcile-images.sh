#!/bin/bash

# Directory containing PNG files
image_dir="./images"

# Iterate through each PNG file
for png_file in "$image_dir"/*.png; do
    png_filename=$(basename "$png_file")
    referenced=false

    # Iterate through each .md file
    for md_file in *.md; do
        if grep -q "$png_filename" "$md_file"; then
            referenced=true
            break
        fi
    done

    # If PNG is not referenced, print its filename
    if [ "$referenced" = false ]; then
        echo "$png_filename"
        mv "images/$png_filename" .tbd/
    fi
done


# Loop through all Markdown files in the current directory
for md_file in *.md; do
  echo "Checking $md_file..."
  # Extract image paths from Markdown file
  grep -o '!\[\([^]]*\)\](\([^)]*\))' "$md_file" | while IFS= read -r line; do
    # Extract the actual path (removing Markdown link formatting)
    img_path=$(echo "$line" | sed -E 's/!\[[^]]*\]\(([^)]*)\)/\1/')
    # Check if the image file exists in the images directory
    if [ -f "$img_path" ]; then
        true
    else
      echo "Missing: $img_path"
      cp "../exed-devops/$img_path" "$image_dir/"
    fi
  done
done