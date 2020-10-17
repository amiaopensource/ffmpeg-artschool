#!/usr/bin/env bash

# Combine two files using a chromakey effects

# Parameters:
# $1: Input File
# $2: Output resolution (Optional)

  outResolution="${2:-none}"  #output resolution. It's "none" if not defined

  # Build filter string
  if [ "$outResolution" == none ]; then
    conversionString=" -c:v prores -profile:v 3 -an "
  else
   if [[ "$outResolution" =~ [0-9]{3}[x][0-9]{3} ]]; then
      conversionString=" -c:v prores -profile:v 3 -filter_complex scale=${outResolution/x/:} -an "
   elif [[ "$outResolution" =~ [0-9]{4}[x][0-9]{4} ]]; then
      conversionString=" -c:v prores -profile:v 3 -filter_complex scale=${outResolution/x/:} -an "
   elif [[ "$outResolution" =~ [0-9]{2}[x][0-9]{2} ]]; then
      conversionString=" -c:v prores -profile:v 3 -filter_complex scale=${outResolution/x/:} -an "
   elif [[ "$outResolution" =~ [0-9]{4}[x][0-9]{3} ]]; then
      conversionString=" -c:v prores -profile:v 3 -filter_complex scale=${outResolution/x/:} -an "
   elif [[ "$outResolution" =~ [0-9]{3}[x][0-9]{4} ]]; then
      conversionString=" -c:v prores -profile:v 3 -filter_complex scale=${outResolution/x/:} -an "
   elif [[ "$outResolution" =~ [0-9]{3}[x][0-9]{2} ]]; then
      conversionString=" -c:v prores -profile:v 3 -filter_complex scale=${outResolution/x/:} -an "
   elif [[ "$outResolution" =~ [0-9]{2}[x][0-9]{3} ]]; then
      conversionString=" -c:v prores -profile:v 3 -filter_complex scale=${outResolution/x/:} -an "
   else
      printf "ERROR: Frame Size must be formated as WIDTHxHEIGHT\n" >&2
      exit
   fi
  fi

# Alter/replace FFmpeg command to desired specification

printf "\n\n*******START FFMPEG COMMANDS*******\n" >&2
echo ffmpeg -i "'$1'" $conversionString "'${1%%.*}_tile.mov'"
printf "********END FFMPEG COMMANDS********\n\n " >&2

ffmpeg -hide_banner -i "$1" $conversionString "${1%%.*}_prores.mov"
