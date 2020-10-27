#!/usr/bin/env bash

# Turn an input video file into a gif

# Parameters:
# $1: Input File

palette=$(dirname "$1")/palette.png

printf "\n\n*******START FFMPEG COMMANDS*******\n" >&2
echo ffmpeg -i "$1" -filter_complex "fps=10,scale=500:-1:flags=lanczos,palettegen=stats_mode=diff" "${palette}"
echo ffmpeg -i "$1" -i "${palette}" -filter_complex "[0:v]fps=10, scale=500:-1:flags=lanczos[v], [v][1:v]paletteuse=dither=bayer:bayer_scale=5:diff_mode=rectangle" "${1%%.*}.gif"
printf "********END FFMPEG COMMANDS********\n\n " >&2

ffmpeg -i "$1" -filter_complex "fps=10,scale=500:-1:flags=lanczos,palettegen=stats_mode=diff" "${palette}"
ffmpeg -i "$1" -i "${palette}" -filter_complex "[0:v]fps=10, scale=500:-1:flags=lanczos[v], [v][1:v]paletteuse=dither=bayer:bayer_scale=5:diff_mode=rectangle" "${1%%.*}.gif"
rm "${palette}"
