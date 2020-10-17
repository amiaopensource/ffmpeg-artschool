#!/usr/bin/env bash

# Combine two files using a chromakey effects

# Parameters:
# $1: File 1 (the overaly file, or the file that will be keyed)
# $2: Corruption Ammount [default: 0.1]. 0 is no error and 1 is all error. Anything abot 0.5 will likely not play
# $3: Keep temp file. The temp file is really finnicky, you only wanna keep it if you're ready for how wonky it can be!

corruption="${2:-0.1}"    # Corruption Ammount [default: 0.1].
keepTemp="${3:0}"    # Whether to keep the temp file, boolean [default: 0]


# Alter/replace FFmpeg command to desired specification
printf "\n\n*******START FFMPEG COMMANDS*******\n" >&2
echo ffmpeg -i "'$1'" -c copy -bsf noise=$2 -y "'${1%%.*}_corruptor.mov'" && ffmpeg -i "'$1'" -c:v prores -profile:v 3 -y "'${1%%.*}_corruptor.mov'"
printf "********END FFMPEG COMMANDS********\n\n " >&2

ffmpeg -i "$1" -c copy -bsf noise=$2 -y "${1%%.*}_corruptor_temp.mov" && ffmpeg -i "$1" -c:v prores -profile:v 3 -y "${1%%.*}_corruptor.mov"

if [[ "$keepTemp" != 1 ]]; then
   rm "${1%%.*}_corruptor_temp.mov"
fi
