#!/usr/bin/env bash

# creates audio visualization overlay by blending video and audio using dispalce and showcqt

# Parameters:
# $1: Input File 1, audio
# $2: Input File 2, video
# $3: Blend Mode

filterString="\
color=0x808080:s=720x480,format=rgb24,loop=-1:size=2[base];\
[0:a]showcqt=s=720x480:basefreq=73.41:endfreq=1567.98,format=rgb24,geq='p(X,363)',setsar=1,colorkey=black:similarity=0.1[vcqt];\
[base][vcqt]overlay,split[vcqt1][vcqt2];\
[1:v]scale=720x480,format=rgb24,setsar=1[bgv];\
[bgv][vcqt1][vcqt2]displace=edge=blank,format=yuv420p10le[v]"

# Alter/replace FFmpeg command to desired specification
printf "\n\n*******START FFMPEG COMMANDS*******\n" >&2
echo ffmpeg -y -i "'$1'" -i "'$2'" -c:v prores -profile:v 3 -filter_complex \"${filterString}\" -map '[v]' -map '0:a' -shortest "'${1%%.*}_audioviz.mov'"
printf "********END FFMPEG COMMANDS********\n\n " >&2

ffmpeg -y -i "$1" -i "$2" -c:v prores -profile:v 3 -filter_complex $filterString -map '[v]' -map '0:a' -shortest "${1%%.*}_audioviz.mov"
