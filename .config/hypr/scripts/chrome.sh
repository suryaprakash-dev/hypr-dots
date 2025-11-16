#!/bin/bash
# This script generates a Chrome theme based on HyDE color scheme
# Modified for HyDE environment
# shellcheck disable=SC2154
# shellcheck disable=SC1091

# Set your cache directory
cacheDir="/home/suryaprakash/.cache/hyde"

# Load colors from wall.dcol file
if ! source "${cacheDir}/wall.dcol"; then
  echo "ERROR: Failed to load 'wall.dcol' file from ${cacheDir}"
  exit 1
fi

THEME_NAME="Wallbash"
THEME_DIR="${cacheDir}/$THEME_NAME-chrome-theme"

if [ -e "$THEME_DIR" ]; then
  rm -fr "$THEME_DIR"
fi

# Converts hex colors into rgb joined with comma
# #fff -> 255, 255, 255
hexToRgb() {
  # Remove '#' character from hex color if present
  plain=${1#*#}
  printf "%d, %d, %d" "0x${plain:0:2}" "0x${plain:2:2}" "0x${plain:4:2}"
}

prepare() {
  if [ -d "$THEME_DIR" ]; then
    rm -rf "$THEME_DIR"
  fi
  mkdir -p "$THEME_DIR/images"
  
  # Copy wallpaper so it can be used in theme
  background_image="images/theme_ntp_background_norepeat.png"
  
  # Get screen resolution for resizing
  SCREEN_RES=$(xrandr 2>/dev/null | grep '*' | head -n1 | awk '{print $1}' | cut -d'x' -f1-2)
  if [ -z "$SCREEN_RES" ]; then
    SCREEN_RES="1920x1080"  # Default fallback
  fi
  
  # Look for wallpaper and resize it to fill screen
  if [ -f "${cacheDir}/wall.set" ]; then
    if command -v convert >/dev/null 2>&1; then
      echo "📐 Resizing wallpaper to ${SCREEN_RES} to fill screen..."
      convert "${cacheDir}/wall.set" -resize "${SCREEN_RES}!" "$THEME_DIR/$background_image"
    else
      echo "⚠️  ImageMagick not found. Using original image (may not fill screen)"
      cp "${cacheDir}/wall.set" "$THEME_DIR/$background_image"
    fi
  elif [ -f "${cacheDir}/wall.blur" ]; then
    if command -v convert >/dev/null 2>&1; then
      echo "📐 Resizing wallpaper to ${SCREEN_RES} to fill screen..."
      convert "${cacheDir}/wall.blur" -resize "${SCREEN_RES}!" "$THEME_DIR/$background_image"
    else
      cp "${cacheDir}/wall.blur" "$THEME_DIR/$background_image"
    fi
  elif [ -f "${cacheDir}/wall" ]; then
    if command -v convert >/dev/null 2>&1; then
      echo "📐 Resizing wallpaper to ${SCREEN_RES} to fill screen..."
      convert "${cacheDir}/wall" -resize "${SCREEN_RES}!" "$THEME_DIR/$background_image"
    else
      cp "${cacheDir}/wall" "$THEME_DIR/$background_image"
    fi
  else
    echo "WARNING: No wallpaper found. Theme will work but without background image."
    background_image=""
  fi
}

# Map HyDE colors to Chrome theme colors
# Using your dcol_* variables
background=$(hexToRgb "${dcol_pry1}")      # Primary dark background
foreground=$(hexToRgb "${dcol_txt1}")      # Primary text (white)
accent=$(hexToRgb "${dcol_1xa6}")          # Accent color (purple-ish)
secondary=$(hexToRgb "${dcol_pry2}")       # Secondary background
tab_background=$(hexToRgb "${dcol_1xa2}")  # Tab background
button_color=$(hexToRgb "${dcol_1xa4}")    # Button colors

# Generates the manifest.json file
generate() {
  cat >"$THEME_DIR/manifest.json" <<EOF
{
  "manifest_version": 3,
  "version": "1.0",
  "name": "$THEME_NAME Theme",
  "theme": {
    $(if [ -n "$background_image" ]; then
      echo "    \"images\": {"
      echo "      \"theme_ntp_background\" : \"$background_image\""
      echo "    },"
    fi)
    "colors": {
      "frame": [$background],
      "frame_inactive": [$background],
      "frame_incognito": [$secondary],
      "frame_incognito_inactive": [$secondary],
      "toolbar": [$tab_background],
      "tab_text": [$foreground],
      "tab_background_text": [$foreground],
      "bookmark_text": [$foreground],
      "ntp_background": [$background],
      "ntp_text": [$foreground],
      "ntp_link": [$accent],
      "ntp_section": [$secondary],
      "button_background": [$button_color],
      "toolbar_button_icon": [$foreground],
      "toolbar_text": [$foreground],
      "omnibox_background": [$background],
      "omnibox_text": [$foreground],
      "tab_background_text_inactive": [$foreground],
      "toolbar_top_separator": [$accent],
      "toolbar_vertical_separator": [$accent]
    },
    "properties": {
      "ntp_background_alignment": "center",
      "ntp_background_repeat": "no-repeat"
    }
  }
}
EOF
}

# Main execution
prepare
generate

echo "✅ Generated 'Hyde Chrome Theme' at '$THEME_DIR'"
echo "📁 To install: Go to chrome://extensions/ -> Enable Developer Mode -> Load unpacked -> Select '$THEME_DIR'"
echo "🎨 Colors used:"
echo "   Background: #${dcol_pry1}"
echo "   Text: #${dcol_txt1}" 
echo "   Accent: #${dcol_1xa6}"
echo "   Secondary: #${dcol_pry2}"
echo ""
echo "📐 Screen resolution detected: ${SCREEN_RES:-Auto-detected}"
if ! command -v convert >/dev/null 2>&1; then
  echo "💡 Install ImageMagick for automatic wallpaper resizing: sudo pacman -S imagemagick"
fi