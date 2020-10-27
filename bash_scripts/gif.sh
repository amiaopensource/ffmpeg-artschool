#!/usr/bin/env bash

# Turn an input video file into a gif

# Parameters:
# $1: Input File
# $2: Quality: 0 = more compressed smaller file, 1 = less compressed bigger file

qualityMode="${2:-0}"         # selects the plane mode. We've created templates that make cool patterns

if [[ $qualityMode = 0 ]]
then
   palletteFilter="fps=10,scale=500:-1:flags=lanczos,palettegen=stats_mode=diff"
   gifFilter="[0:v]fps=10,scale=500:-1:flags=lanczos[v],[v][1:v]paletteuse=dither=bayer:bayer_scale=5:diff_mode=rectangle"
elif [[ $qualityMode = 1 ]]
then
   palletteFilter="fps=10,scale=500:-1:flags=lanczos,palettegen"
   gifFilter="[0:v]fps=10,scale=500:-1:flags=lanczos[v],[v][1:v]paletteuse"
else
   printf "ERROR: Quality must be either 0 (more compresstion) or 1 (less compression)\n" >&2
   exit
fi

palette=$(dirname "$1")/palette.png

printf "\n\n*******START FFMPEG COMMANDS*******\n" >&2
echo ffmpeg -i "'$1'" -filter_complex $palletteFilter "'${palette}'"
echo ffmpeg -i "'$1'" -i "${palette}" -filter_complex $gifFilter "'${1%%.*}.gif'"
printf "********END FFMPEG COMMANDS********\n\n " >&2

ffmpeg -i "$1" -filter_complex $palletteFilter "${palette}"
ffmpeg -i "$1" -i "${palette}" -filter_complex $gifFilter "${1%%.*}.gif"
rm "${palette}"
