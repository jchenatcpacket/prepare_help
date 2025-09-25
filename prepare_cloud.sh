#!/bin/bash

# Change to Downloads directory
cd "$HOME/Downloads" || exit 1

# Set up variables
CCLEAR_HELP_DIR="$HOME/cclear-help"
VMWARE_DIR="cClear_for_VMware_User_Guide"
ZIP_FILE="cClear_for_VMware_User_Guide_HTML.zip"
PDF_FILE="cClear_for_VMware_User_Guide.pdf"

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
if [[ ! -d "$CCLEAR_HELP_DIR/vmware" ]]; then
    echo "Error: $CCLEAR_HELP_DIR/vmware directory not found"
    exit 1
fi

# Extract the zip file
echo "Extracting $ZIP_FILE..."
if unzip -q "$ZIP_FILE" -d "$VMWARE_DIR"; then
    echo "Extraction successful"
else
    echo "Error: Failed to extract $ZIP_FILE"
    exit 1
fi

# Clean up destination folder contents
echo "Cleaning up $CCLEAR_HELP_DIR/vmware..."
if [[ -d "$CCLEAR_HELP_DIR/vmware" ]]; then
    rm -rf "$CCLEAR_HELP_DIR/vmware"/* || {
        echo "Error: Failed to clean files in $CCLEAR_HELP_DIR/vmware/"
        exit 1
    }
else
    echo "Creating $CCLEAR_HELP_DIR/vmware directory..."
    mkdir -p "$CCLEAR_HELP_DIR/vmware"
fi

# Move files to destination
echo "Moving files to $CCLEAR_HELP_DIR/vmware..."
if [[ -d "$VMWARE_DIR/cClear_for_VMware_User_Guide/out" ]]; then
    cp -r "$VMWARE_DIR/cClear_for_VMware_User_Guide/out"/* "$CCLEAR_HELP_DIR/vmware/" || {
        echo "Error: Failed to copy files"
        exit 1
    }
else
    echo "Error: $VMWARE_DIR/cClear_for_VMware_User_Guide/out directory not found after extraction"
    exit 1
fi

# Clean up transformation log
rm -f "$CCLEAR_HELP_DIR/vmware/transformation.log"

# Clean up extracted directory
rm -rf "$VMWARE_DIR"

echo "Moving PDF file..."
if mv "$PDF_FILE" "$CCLEAR_HELP_DIR/cloud/help.pdf"; then
    echo "PDF moved successfully"
else
    echo "Error: Failed to move PDF file"
    exit 1
fi


echo "Script completed successfully!"