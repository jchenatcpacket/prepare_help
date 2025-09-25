#!/bin/bash

# Change to Downloads directory
cd "$HOME/Downloads" || exit 1

# Set up variables
CCLEAR_HELP_DIR="$HOME/cclear-help"
TMP_DIR="User_Guide"
ZIP_FILE="cClear-V_User_Guide_HTML.zip"
PDF_FILE="cClear-V_User_Guide.pdf"

# Check if zip file exists
if [[ ! -f "$ZIP_FILE" ]]; then
    echo "Error: $ZIP_FILE not found in $HOME/Downloads"
    exit 1
fi

# Check if pdf file exists
if [[ ! -f "$PDF_FILE" ]]; then
    echo "Error: $PDF_FILE not found in $HOME/Downloads"
    exit 1
fi

# Check if destination directory exists
if [[ ! -d "$CCLEAR_HELP_DIR/cloud" ]]; then
    echo "Error: $CCLEAR_HELP_DIR/cloud directory not found"
    exit 1
fi

# Extract the zip file
echo "Extracting $ZIP_FILE..."
if unzip -q "$ZIP_FILE" -d "$TMP_DIR"; then
    echo "Extraction successful"
else
    echo "Error: Failed to extract $ZIP_FILE"
    exit 1
fi

# Clean up destination folder contents
echo "Cleaning up $CCLEAR_HELP_DIR/cloud..."
if [[ -d "$CCLEAR_HELP_DIR/cloud" ]]; then
    rm -rf "$CCLEAR_HELP_DIR/cloud"/* || {
        echo "Error: Failed to clean files in $CCLEAR_HELP_DIR/cloud/"
        exit 1
    }
else
    echo "Creating $CCLEAR_HELP_DIR/cloud directory..."
    mkdir -p "$CCLEAR_HELP_DIR/cloud"
fi

# Move files to destination
echo "Moving files to $CCLEAR_HELP_DIR/cloud..."
# Find the first subdirectory in TMP_DIR that contains an 'out' folder
EXTRACTED_DIR=$(find "$TMP_DIR" -maxdepth 1 -type d -not -path "$TMP_DIR" | head -1)
if [[ -n "$EXTRACTED_DIR" && -d "$EXTRACTED_DIR/out" ]]; then
    cp -r "$EXTRACTED_DIR/out"/* "$CCLEAR_HELP_DIR/cloud/" || {
        echo "Error: Failed to copy files"
        exit 1
    }
else
    echo "Error: No subdirectory with 'out' folder found after extraction"
    exit 1
fi

# Clean up transformation log
rm -f "$CCLEAR_HELP_DIR/cloud/transformation.log"

# Clean up extracted directory
rm -rf "$TMP_DIR"

echo "Moving PDF file..."
if mv "$PDF_FILE" "$CCLEAR_HELP_DIR/cloud/help.pdf"; then
    echo "PDF moved successfully"
else
    echo "Error: Failed to move PDF file"
    exit 1
fi


echo "Script completed successfully!"