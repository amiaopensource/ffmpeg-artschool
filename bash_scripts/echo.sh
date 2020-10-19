#!/usr/bin/env bash

# Combine two files using a lumakey effect

# Parameters:
# $1: File 1 (the overaly file, or the file that will be keyed)
# $2: Echo rate
# $3: Number of trails

echoRate="${2:-0.1}"          # Echo rate
trails="${3:-1}"    # Number of trails
echofeedback=""
testvariable="1234"

for (( i=1;i<${trails};i++ ))
{
   # 'bc' command used for floating point addition
   echofeedback="[wet]split[wet2Blend][wet2Feedback],[wet2Feedback]setpts=PTS+$echoRate/TB[wetFromFeedback];[wet2Blend]lutyuv=y=val*0.75[wet2Blend];[wetFromFeedback]lutyuv=y=val*0.50[wetFromFeedback];[wetFromFeedback][wet2Blend]blend=all_mode=screen[wet];"$echofeedback
}

echofilter="format=rgb24,split[dry][toEcho];[toEcho]setpts=PTS+$echoRate/TB[wet];$echofeedback[dry]lutyuv=y=val*0.75[dry];[wet]lutyuv=y=val*0.50[wet];[wet][dry]blend=all_mode=screen,format=yuv422p10le[out]"

# Alter/replace FFmpeg command to desired specification
printf "\n\n*******START FFMPEG COMMANDS*******\n" >&2
echo ffmpeg -i "'$1'" -c:v prores -profile:v 3 -filter_complex $echofilter -map '[out]' "'${1%%.*}_echo.mov'"
printf "********END FFMPEG COMMANDS********\n\n " >&2
echo $echofeedback

ffmpeg -i "$1" -c:v prores -profile:v 3 -filter_complex $echofilter -map '[out]' "${1%%.*}_echo.mov"
