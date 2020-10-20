#!/usr/bin/env bash

# Combine two files using a lumakey effect

# Parameters:
# $1: File 1 (the overaly file, or the file that will be keyed)
# $2: Echo rate
# $3: Length of tails. 1 is just one tail, number increases exponentially as it goes. 

echoRate="${2:-0.2}"          # Echo rate
trails="${3:-3}"    # Number of trails
echofeedback=""
ptsDelay="0"

for (( i=1;i<${trails};i++ ))
{
   # 'bc' command used for floating point addition
   ptsDelay="$(bc <<<"${ptsDelay}+${echoRate}")"
   echofeedback="[wet]split[wet2Blend][wet2Feedback],[wet2Feedback]setpts=PTS+($ptsDelay/TB)[wetFromFeedback];[wetFromFeedback][wet2Blend]blend=all_mode=normal:c0_opacity=.5:c1_opacity=.5[wet];"$echofeedback
}

echofilter="split[dry][toEcho];[toEcho]setpts=PTS+($echoRate/TB)[wet];$echofeedback[wet][dry]blend=all_mode=normal:c0_opacity=.5:c1_opacity=.5[outRGB];[outRGB]format=yuv422p10le[out]"

# Alter/replace FFmpeg command to desired specification
printf "\n\n*******START FFMPEG COMMANDS*******\n" >&2
echo ffmpeg -i "'$1'" -c:v prores -profile:v 3 -filter_complex $echofilter -map '[out]' "'${1%%.*}_echo.mov'"
printf "********END FFMPEG COMMANDS********\n\n " >&2

ffmpeg -i "$1" -c:v prores -profile:v 3 -filter_complex $echofilter -map '[out]' "${1%%.*}_echo.mov"
