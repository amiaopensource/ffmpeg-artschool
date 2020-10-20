#!/usr/bin/env bash

# Creates ghost trails using hte lagfun effect

# Parameters:


trailMode="${2:-1}"         # selects the plane mode. We've created templates that make cool patterns
amount="${3:-1}"            # selects the intensity of the effect

if [[ $trailMode = 1 ]]
then
filterComplex="lagfun=decay=.95[out]"
elif [[ $trailMode = 2 ]]
then
  filterComplex="format=gbrp10[formatted];[formatted]lagfun=decay=.95:planes=5,format=yuv422p10le[out]"
elif [[ $trailMode = 3 ]]
then
  filterComplex="format=gbrp10[formatted];[formatted]split[a][b];[a]lagfun=decay=.99:planes=1[a];[b]lagfun=decay=.98:planes=2[b];[a][b]blend=all_mode=screen:c0_opacity=.5:c1_opacity=.5,format=yuv422p10le[out]"
elif [[ $trailMode = 4 ]]
then
  filterComplex="blend=all_mode=normal:c0_opacity=.5:c1_opacity=.5"
elif [[ $trailMode = 5 ]]
then
  filterComplex="blend=all_mode=normal:c0_opacity=.5:c1_opacity=.5"
elif [[ $trailMode = 6 ]]
then
  filterComplex="blend=all_mode=normal:c0_opacity=.5:c1_opacity=.5"
elif [[ $trailMode = 7 ]]
then
  filterComplex="blend=all_mode=normal:c0_opacity=.5:c1_opacity=.5"
fi

# Alter/replace FFmpeg command to desired specification
printf "\n\n*******START FFMPEG COMMANDS*******\n" >&2
echo ffmpeg -i "'$1'" -c:v prores -profile:v 3 -filter_complex $filterComplex -map '[out]' "'${1%%.*}_lagfun.mov'"
printf "********END FFMPEG COMMANDS********\n\n " >&2

ffmpeg -i "$1" -c:v prores -profile:v 3 -filter_complex $filterComplex -map '[out]' "${1%%.*}_lagfun.mov"
