#!/usr/bin/env bash

# Combine two files using a lumakey effect

# Parameters:
# $1: File 1 (the overaly file, or the file that will be keyed)
# $2: File 2 (the background file)
# $3: Threshold value [default: 0]. 0 will key out black, 1 will key out white
# $4: Tolerance value [default 0.1]. If threshold is 0, then use a low number like 0.1 to key out darks. If threshold is 1, use a high number like 0.7 to key out whites
# $5: Softness value [default: 0.2]. this softens the key. 0 has sharp edges, 1 is totally soft, however it's not advisable to go above 0.4


thresh="${3:-0}"    # Threshold value [default: 0]
tol="${4:-0.1}"    # Tolerance value [default 0.1]
soft="${5:-0.2}"  # Softness value [default: 0.2]

# Build filter string
filter_complex="[0:v][1:v]scale2ref[v0][v1];[v1]lumakey=threshold=$thresh:tolerance=$tol:softness=$soft[1v];[v0][1v]overlay,format=yuv422p10le[v]"

# Alter/replace FFmpeg command to desired specification
printf "\n\n*******START FFMPEG COMMANDS*******\n" >&2
echo ffmpeg -i "'$2'" -i "'$1'" -c:v prores -profile:v 3 -filter_complex $filter_complex -map '[v]' "'${1%%.*}_lumakey.mov'"
printf "********END FFMPEG COMMANDS********\n\n " >&2

ffmpeg -i "$2" -i "$1" -c:v prores -profile:v 3 -filter_complex $filter_complex -map '[v]' "${1%%.*}_lumakey.mov"
