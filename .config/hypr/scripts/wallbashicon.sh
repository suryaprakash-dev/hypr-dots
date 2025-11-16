#!/usr/bin/env bash

# Paths
DCOL_FILE="$HOME/.cache/hyde/wall.dcol"
INSTALL_SCRIPT="$HOME/.config/hypr/wallbash/Wallbash-icons/install.sh"

# Check if dcol file exists
if [[ ! -f "$DCOL_FILE" ]]; then
    echo "Error: $DCOL_FILE not found!"
    exit 1
fi

# Check if install script exists
if [[ ! -f "$INSTALL_SCRIPT" ]]; then
    echo "Error: $INSTALL_SCRIPT not found!"
    exit 1
fi

# Extract dcol_pry4 value from the dcol file
dcol_pry4=$(grep "^dcol_pry4=" "$DCOL_FILE" | cut -d'"' -f2)

if [[ -z "$dcol_pry4" ]]; then
    echo "Error: dcol_pry4 not found in $DCOL_FILE"
    exit 1
fi

# Add # prefix to make it a proper hex color
theme_color="#$dcol_pry4"

echo "Extracted color: $theme_color"

# Create backup of install script
cp "$INSTALL_SCRIPT" "$INSTALL_SCRIPT.backup"

# Update the install script - replace the icons color value
sed -i "/icons)/,/;;/ s/local -r theme_color='#[A-Fa-f0-9]\{6\}'/local -r theme_color='$theme_color'/" "$INSTALL_SCRIPT"

# Verify the change was made
if grep -q "local -r theme_color='$theme_color'" "$INSTALL_SCRIPT"; then
    echo "Successfully updated install.sh with color: $theme_color"
    echo "Backup saved as: $INSTALL_SCRIPT.backup"
    
    # Run the installation with circular icons variant
    echo "Installing Wallbash icons with extracted color..."
    cd "$(dirname "$INSTALL_SCRIPT")" || exit 1
    bash "$INSTALL_SCRIPT" -c icons
    
else
    echo "Error: Failed to update the install script"
    # Restore backup if update failed
    mv "$INSTALL_SCRIPT.backup" "$INSTALL_SCRIPT"
    exit 1
fi