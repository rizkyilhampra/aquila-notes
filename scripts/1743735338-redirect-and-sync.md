---
id: 1743735359-redirect-and-sync
alias: redirect and sync
tags: []
---
# Redirect and Sync
```bash
#!/bin/bash

# --- Configuration ---
# Source directory (the one to redirect *from*)
SOURCE_DIR="/opt/lampp/htdocs/PICare"
# Target directory (the one to redirect *to* and sync *to*)
TARGET_DIR="/opt/lampp/htdocs/picare"
# --- End Configuration ---

# Derive other paths
SOURCE_BASENAME=$(basename "$SOURCE_DIR") # Should be PICare
TARGET_BASENAME=$(basename "$TARGET_DIR") # Should be picare
HTACCESS_FILE="$SOURCE_DIR/.htaccess"
SOURCE_UPLOAD_DIR="$SOURCE_DIR/upload"
TARGET_UPLOAD_DIR="$TARGET_DIR/upload"

echo "--- Configuration ---"
echo "Source Directory (From): $SOURCE_DIR"
echo "Target Directory (To):   $TARGET_DIR"
echo "Source Upload Dir:       $SOURCE_UPLOAD_DIR"
echo "Target Upload Dir:       $TARGET_UPLOAD_DIR"
echo "Htaccess File to create: $HTACCESS_FILE"
echo "---------------------"
echo

# --- Safety Checks ---
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory '$SOURCE_DIR' does not exist."
    exit 1
fi

if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Target directory '$TARGET_DIR' does not exist."
    exit 1
fi

# --- Step 1: Create Redirect .htaccess ---
echo "Creating redirect .htaccess file in '$SOURCE_DIR'..."

# Create the .htaccess content using a heredoc
cat > "$HTACCESS_FILE" <<EOF
# Automatically generated redirect script
# Redirects all traffic from /$SOURCE_BASENAME/* to /$TARGET_BASENAME/*

<IfModule mod_rewrite.c>
    RewriteEngine On

    # Rule to redirect requests for this directory to the target directory
    # Example: /PICare/some/page?query=1 -> /picare/some/page?query=1
    RewriteCond %{REQUEST_URI} ^/$SOURCE_BASENAME/(.*)$ [NC]
    RewriteRule ^(.*)$ /$TARGET_BASENAME/%1 [R=302,L,NC,QSA]

    # If someone accesses the root /PICare (without trailing slash), redirect too
    RewriteCond %{REQUEST_URI} ^/$SOURCE_BASENAME$ [NC]
    RewriteRule ^(.*)$ /$TARGET_BASENAME/ [R=302,L,NC,QSA]
</IfModule>

# Prevent directory listing for this old directory
Options -Indexes
EOF

# Check if the file was created successfully
if [ $? -eq 0 ]; then
    echo "Successfully created '$HTACCESS_FILE'."
    # Set reasonable permissions (optional, adjust if needed)
    chmod 644 "$HTACCESS_FILE"
    echo "Permissions set to 644 for '$HTACCESS_FILE'."
else
    echo "Error: Failed to create '$HTACCESS_FILE'."
    exit 1
fi
echo

# --- Step 2: Sync Upload Directories ---
echo "Synchronizing upload directories..."
echo "Source: $SOURCE_UPLOAD_DIR"
echo "Target: $TARGET_UPLOAD_DIR"

# Check if source upload directory exists
if [ ! -d "$SOURCE_UPLOAD_DIR" ]; then
    echo "Warning: Source upload directory '$SOURCE_UPLOAD_DIR' does not exist. Skipping sync."
    echo "---------------------"
    echo "Script finished. Redirect is set up."
    exit 0
fi

# Ensure target upload directory exists
if [ ! -d "$TARGET_UPLOAD_DIR" ]; then
    echo "Target upload directory '$TARGET_UPLOAD_DIR' does not exist. Creating it..."
    mkdir -p "$TARGET_UPLOAD_DIR"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to create target upload directory '$TARGET_UPLOAD_DIR'."
        exit 1
    fi
    echo "Created '$TARGET_UPLOAD_DIR'."
fi

# Perform the sync using rsync
# -a: archive mode (recursive, preserves permissions, times, etc.)
# -v: verbose (show files being transferred)
# --delete: delete files in TARGET that are not in SOURCE (makes it a mirror)
# --dry-run: simulate the run without making changes (useful for testing)

echo
echo "Performing DRY RUN of rsync first to show what would be changed:"
rsync -av --dry-run --delete "$SOURCE_UPLOAD_DIR/" "$TARGET_UPLOAD_DIR/"
echo
read -p "Review the dry run. Proceed with the actual sync? (y/N): " confirm_sync

if [[ "$confirm_sync" =~ ^[Yy]$ ]]; then
    echo "Running actual rsync..."
    rsync -av --delete "$SOURCE_UPLOAD_DIR/" "$TARGET_UPLOAD_DIR/"
    if [ $? -eq 0 ]; then
        echo "Successfully synchronized '$SOURCE_UPLOAD_DIR/' to '$TARGET_UPLOAD_DIR/'."
    else
        echo "Error: rsync command failed."
        exit 1
    fi
else
    echo "Sync aborted by user."
fi

echo
echo "---------------------"
echo "Script finished."
echo "Redirect from '$SOURCE_DIR' to '$TARGET_DIR' should be active."
echo "Upload directory '$TARGET_UPLOAD_DIR' has been synchronized from '$SOURCE_UPLOAD_DIR'."
echo "Test the redirect by accessing http://<your_server>/PICare/ in your browser."
echo "Remember: If you add new files to '$SOURCE_UPLOAD_DIR', you need to run this sync again or set up a cron job."
echo "Consider changing R=302 to R=301 in '$HTACCESS_FILE' for a permanent redirect once confirmed working."

exit 0
```