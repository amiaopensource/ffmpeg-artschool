#!/usr/bin/env bash

# Combine two files using a chromakey effects

# Parameters:
# $1: Input File
# $2: Tile Columns
# $3: Tile Rows

function tileFilter()
{
  local width="${1:-4}"    # width - default vaue is 4
  local height="${2:-4}"    # height - default value is 4

  # Build filter string
  filter_complex="scale=iw/${width}:ih/${height}:force_original_aspect_ratio=decrease,tile=${width}x${height}:overlap=${width}*${height}-1:init_padding=${width}*${height}-1"

  # Return full filter string, with necessary prefix and suffix filterchains
  printf '%s%s%s' $filter_complex
}

# Alter/replace FFmpeg command to desired specification

echo ffmpeg -i "'$1'" -c:v prores -profile:v 3 -filter_complex "$(tileFilter "${@:2}")" "${1}_tile.mov'"


ffmpeg -i "$1" -c:v prores -profile:v 3 -filter_complex "$(tileFilter "${@:2}")" "${1}_tile.mov"
