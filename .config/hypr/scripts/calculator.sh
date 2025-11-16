#!/usr/bin/env bash
# Define paths
scrDir=$(dirname "$(realpath "$0")")
source "$scrDir/globalcontrol.sh"
config_dir="$HOME/.config"
rofi_theme="$config_dir/rofi/clipboard.rasi"

# Set rofi scaling
[[ "${rofiScale}" =~ ^[0-9]+$ ]] || rofiScale=10
r_scale="configuration {font: \"JetBrainsMono Nerd Font ${rofiScale}\";}"
wind_border=$((hypr_border * 3 / 2))
elem_border=$([ $hypr_border -eq 0 ] && echo "5" || echo $hypr_border)

r_override="window{border:${hypr_width}px;border-radius:${wind_border}px;} wallbox{border-radius:${elem_border}px;} element{border-radius:${elem_border}px;}"


main() {

    if [[ -v customRoFile ]]; then
        rofi -show calc -modi calc -no-show-match -no-sort -config "${customRoFile}"
    else
        rofi -show calc -modi calc -theme-str "entry { placeholder: \"Calculator...\"; }" -no-show-match -no-sort -theme-str "${r_scale}" -theme-str "${r_override}" -config "${roFile:-clipboard}"
    fi
}

usage() {
    cat <<EOF
--rasi <PATH>     Set custom .rasi file. Note that this removes all overrides

EOF
    exit 1
}

while (($# > 0)); do
    case $1 in
    --rasi)
        [[ -z ${2} ]] && echo "[error] --rasi requires a file.rasi config file" && exit 1
        customRoFile=${2}
        shift
        ;;
    *)
        echo "Unknown option: $1"
        usage
        ;;
    esac
    shift
done

main "$@"
