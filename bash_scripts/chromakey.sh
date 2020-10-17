#!/usr/bin/env bash

# Combine two files using a chromakey effects

# Parameters:
# $1: File 1 (the overaly file, or the file that will be keyed)
# $2: File 2 (the background file)
# $3: Colorkey value [default: 0000FF]
# $4: Colorkey similarity value [default: 0.6]. Between 0.01 and 1. The closer to 1 more tolerance
# $5: Colorkey blend value [default: 0.1]



function chromakeyFilter()
{
  local key="${1:-00FF00}"    # Colorkey colour - default vaue is 0000FF or green
  local colorSim="${2:-0.6}"    # Colorkey similarity level - default value is 0.6
  local colorBlend="${3:-0.1}"  # Colorkey blending level - default value is 0.1

   # Update color variable according to user input
   # This makes the matching case insensitive
  if [[ $1 =~ ^[0-9A-F]{6}$ ]]
  then
    key=$1
  elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$1")  = "blue" ]]
  then
    key="0000FF"
  elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$1")  = "green" ]]
  then
    key="00FF00"
  elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$1")  = "red" ]]
  then
    key="FF0000"
  elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$1")  = "purple" ]]
  then
    key="0000FF"
  elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$1")  = "orange" ]]
  then
    key="ff9900"
  elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$1")  = "yellow" ]]
  then
    key="FFFF00"
  fi

  # Build filter string
  filter_complex="[1:v]colorkey=0x$key:$colorSim:$colorBlend[1v];[0:v][1v]overlay[v]"

  # Return full filter string, with necessary prefix and suffix filterchains
  printf '%s%s%s' $filter_complex
}

# Alter/replace FFmpeg command to desired specification

echo ffmpeg -i "'$2'" -i "'$1'" -c:v prores -profile:v 3 -filter_complex "$(chromakeyFilter "${@:3}")" -map '[v]' "'${1%%.*}_chromakey.mov'"

ffmpeg -i "$2" -i "$1" -c:v prores -profile:v 3 -filter_complex "$(chromakeyFilter "${@:3}")" -map '[v]' "${1%%.*}_chromakey.mov"
