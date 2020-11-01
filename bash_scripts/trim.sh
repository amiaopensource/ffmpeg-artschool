#!/usr/bin/env bash

# Trims file based upon user-defined timestamps (HH:MM:SS)

# Parameters:
# $1: Input File
# $2: Beginning timestamp
# $3: Ending timestamp

ffmpeg -i "$1" -ss $2 -to $3 -c copy -map 0 "${1%.*}_trim.mov"
printf "\n\n*******START FFMPEG COMMANDS*******\n" >&2
printf "ffmpeg -i '$1' -ss $2 -to $3 -c copy -map 0 '${1%.*}_trim.mov' \n" >&2
printf "********END FFMPEG COMMANDS********\n\n " >&2
