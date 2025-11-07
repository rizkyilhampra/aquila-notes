#!/bin/bash

# Script to rename files with QTVK in the name
# Converts Unix timestamp to YYYYMMDDHHmmss format

cd /home/aquila/Notes/aquila-notes/attachment || exit 1

# Process all files containing QTVK
for file in *QTVK*.png; do
    # Skip if no files match
    [ -e "$file" ] || continue

    # Extract the Unix timestamp (the number before -QTVK)
    timestamp=$(echo "$file" | grep -oP '^\d+')

    if [ -n "$timestamp" ]; then
        # Convert Unix timestamp to YYYYMMDDHHmmss format
        datetime=$(date -d @"$timestamp" '+%Y%m%d%H%M%S')

        # Create new filename by replacing the timestamp and removing QTVK
        newfile=$(echo "$file" | sed "s/^${timestamp}-QTVK/${datetime}/")

        # Rename the file
        echo "Renaming: $file -> $newfile"
        mv "$file" "$newfile"
    else
        echo "Warning: Could not extract timestamp from $file"
    fi
done

echo "Renaming complete!"
