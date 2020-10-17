#!/usr/bin/env bash

# tiles the input file, similar to QCTools Film Strip effect

# Parameters:
# $1: Input File
# $2: Tile Columns
# $3: Tile Rows
# $4: Output resolution


  width="${2:-4}"    # width - default vaue is 4
  height="${3:-4}"    # height - default value is 4
  outResolution="${4:-none}"  #output resolution. It's "none" if not defined

  # Build filter string
  if [ "$outResolution" == none ]; then
    filter_complex="scale=iw/${width}:ih/${height}:force_original_aspect_ratio=decrease,tile=${width}x${height}:overlap=${width}*${height}-1:init_padding=${width}*${height}-1"
  else
   if [[ "$outResolution" =~ [0-9]{3}[x][0-9]{3} ]]; then
      filter_complex="scale=iw/${width}:ih/${height}:force_original_aspect_ratio=decrease,tile=${width}x${height}:overlap=${width}*${height}-1:init_padding=${width}*${height}-1,scale=${outResolution/x/:}"
   elif [[ "$outResolution" =~ [0-9]{4}[x][0-9]{4} ]]; then
      filter_complex="scale=iw/${width}:ih/${height}:force_original_aspect_ratio=decrease,tile=${width}x${height}:overlap=${width}*${height}-1:init_padding=${width}*${height}-1,scale=${outResolution/x/:}"
   elif [[ "$outResolution" =~ [0-9]{2}[x][0-9]{2} ]]; then
      filter_complex="scale=iw/${width}:ih/${height}:force_original_aspect_ratio=decrease,tile=${width}x${height}:overlap=${width}*${height}-1:init_padding=${width}*${height}-1,scale=${outResolution/x/:}"
   elif [[ "$outResolution" =~ [0-9]{4}[x][0-9]{3} ]]; then
      filter_complex="scale=iw/${width}:ih/${height}:force_original_aspect_ratio=decrease,tile=${width}x${height}:overlap=${width}*${height}-1:init_padding=${width}*${height}-1,scale=${outResolution/x/:}"
   elif [[ "$outResolution" =~ [0-9]{3}[x][0-9]{4} ]]; then
      filter_complex="scale=iw/${width}:ih/${height}:force_original_aspect_ratio=decrease,tile=${width}x${height}:overlap=${width}*${height}-1:init_padding=${width}*${height}-1,scale=${outResolution/x/:}"
   elif [[ "$outResolution" =~ [0-9]{3}[x][0-9]{2} ]]; then
      filter_complex="scale=iw/${width}:ih/${height}:force_original_aspect_ratio=decrease,tile=${width}x${height}:overlap=${width}*${height}-1:init_padding=${width}*${height}-1,scale=${outResolution/x/:}"
   elif [[ "$outResolution" =~ [0-9]{2}[x][0-9]{3} ]]; then
      filter_complex="scale=iw/${width}:ih/${height}:force_original_aspect_ratio=decrease,tile=${width}x${height}:overlap=${width}*${height}-1:init_padding=${width}*${height}-1,scale=${outResolution/x/:}"
   else
      printf "ERROR: Frame Size must be formated as WIDTHxHEIGHT\n" >&2
      exit
   fi
  fi

# Alter/replace FFmpeg command to desired specification

printf "\n\n*******START FFMPEG COMMANDS*******\n" >&2
echo ffmpeg -i "'$1'" -c:v prores -profile:v 3 -filter_complex $filter_complex "'${1%%.*}_tile.mov'"
printf "********END FFMPEG COMMANDS********\n\n " >&2

ffmpeg -hide_banner -i "$1" -c:v prores -profile:v 3 -filter_complex $filter_complex "${1%%.*}_tile.mov"
