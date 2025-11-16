#!/usr/bin/env sh

# Define paths
scrDir=$(dirname "$(realpath "$0")")
source "$scrDir/globalcontrol.sh"
config_dir="$HOME/.config"
animations_dir="$config_dir/hypr/animations"
animations_conf="$config_dir/hypr/animations.conf"
rofi_theme="$config_dir/rofi/clipboard.rasi"

# Set rofi scaling
[[ "${rofiScale}" =~ ^[0-9]+$ ]] || rofiScale=10
r_scale="configuration {font: \"JetBrainsMono Nerd Font ${rofiScale}\";}"
wind_border=$((hypr_border * 3 / 2))
elem_border=$([ $hypr_border -eq 0 ] && echo "5" || echo $hypr_border)

r_override="window{border:${hypr_width}px;border-radius:${wind_border}px;} wallbox{border-radius:${elem_border}px;} element{border-radius:${elem_border}px;}"

# Ensure the animations directory exists
if [ ! -d "$animations_dir" ]; then
    notify-send "Error" "Animations directory does not exist at $animations_dir"
    exit 1
fi

# List available .conf files in animations directory
animation_files=$(ls "$animations_dir"/*.conf 2>/dev/null)
if [ -z "$animation_files" ]; then
    notify-send "Error" "No .conf files found in $animations_dir"
    exit 1
fi

# Display options using Rofi with custom scaling, positioning, and placeholder
selected_animation=$(echo "$animation_files" | awk -F/ '{print $NF}' | \
    rofi -dmenu \
         -p "Select animation" \
         -theme-str "entry { placeholder: \"Select animation...\"; }" \
         -theme-str "${r_scale}" \
         -theme-str "${r_override}" \
         -theme "$rofi_theme")

# Exit if no selection was made
if [ -z "$selected_animation" ]; then
    exit 0
fi

# Generate the new source line
selected_path="$animations_dir/$selected_animation"
new_source_line="source = $selected_path"

# Update the animations.conf file
if grep -q "^source = " "$animations_conf"; then
    sed -i "s|^source = .*|$new_source_line|" "$animations_conf"
else
    echo "$new_source_line" >> "$animations_conf"
fi

# Notify the user
notify-send "Animation Updated" "Sourced $selected_animation"