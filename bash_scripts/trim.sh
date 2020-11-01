#!/usr/bin/env bash

# Trims file based upon user-defined timestamps (HH:MM:SS)

# Parameters:
# $1: Input File
# $2: Beginning timestamp
# $3: Ending timestamp

printf "\n\n*******START FFMPEG COMMANDS*******\n" >&2
echo ffmpeg -i "$1" -ss $2 -to $3 -c copy -map 0 "${1%.*}_trim.mov"
printf "********END FFMPEG COMMANDS********\n\n " >&2

ffmpeg -i "$1" -ss $2 -to $3 -c copy -map 0 "${1%.*}_trim.mov"
