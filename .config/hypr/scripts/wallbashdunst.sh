#!/usr/bin/env sh

# set variables

scrDir=`dirname "$(realpath "$0")"`
source $scrDir/globalcontrol.sh
dstDir="${confDir}/dunst"

# regen conf

# Remove previous wallbash sections and add new one
sed '/# BEGIN WALLBASH/,/# END WALLBASH/d' "${dstDir}/dunstrc" > "${dstDir}/dunstrc.tmp"
echo "# BEGIN WALLBASH" >> "${dstDir}/dunstrc.tmp"
envsubst < "${dstDir}/wallbash.conf" >> "${dstDir}/dunstrc.tmp"
echo "# END WALLBASH" >> "${dstDir}/dunstrc.tmp"
mv "${dstDir}/dunstrc.tmp" "${dstDir}/dunstrc"
killall dunst
dunst &

