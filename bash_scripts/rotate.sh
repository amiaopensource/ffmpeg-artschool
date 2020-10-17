#!/usr/bin/env bash

# Rotates the input file with options to resize the output

# Parameters:
# $1: Input File
# $2: Rotation amount
# $3: Stretch to conform output to input aspect ratio
# $4: Output resolution


  rotation="${2:-180}"    # rotation degrees, must be 90, 180, or 270
  stretch="${3:-1}"    # Whether to stretch the output to conform to the input. Default is 1 or true, 0 is false

  # Build filter string
  if [[ "$rotation" == 90 ]]; then
    vf="transpose=2"
  elif [[ "$rotation" == 180 ]]; then
    vf="transpose=2,transpose=2"
  elif [[ "$rotation" == 270 ]]; then
    vf="transpose=2,transpose=2,transpose=2"
  else
    printf "ERROR: Frame rotation must be either 90, 180, or 270\n" >&2
    exit
  fi

  if [ "$stretch" == 0 ]; then
    vf=$vf
  else
    inputFrameSize=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "${1}") #gets input file dimensions
    vf=$vf",scale=${inputFrameSize/x/:}"  #adds a portion to the filter to scale the output to the same dimensions as input
  fi

# Alter/replace FFmpeg command to desired specification

printf "\n\n*******START FFMPEG COMMANDS*******\n" >&2
echo ffmpeg -i "'$1'" -c:v prores -profile:v 3 -filter_complex $vf "'${1%%.*}_rotate.mov'"
printf "********END FFMPEG COMMANDS********\n\n " >&2

ffmpeg -hide_banner -i "$1" -c:v prores -profile:v 3 -vf $vf "${1%%.*}_rotate.mov"
