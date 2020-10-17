#!/usr/bin/env bash

# Performs a glitchy tblend on the input video files
# source: https://oioiiooixiii.blogspot.com

# Parameters:
# $1: Input File 1
# $2: Blend Mode (choose a number between 1 and 4)

mode="${2:-1}"    # blend mode (default is 1)

# Build filter string
if [[ "$mode" == 1 ]]; then
  vf="scale=-2:720,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
spp=4:10,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
spp=4:10,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
spp=4:10,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128"
elif [[ "$mode" == 2 ]]; then
  vf="scale=-2:720,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
spp=4:10,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
spp=4:10,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
spp=4:10,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
spp=4:10,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
spp=4:10,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
spp=4:10,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
spp=4:10,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
spp=4:10,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
spp=4:10,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
spp=4:10,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
spp=4:10,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
spp=4:10,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
spp=4:10,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
spp=4:10,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128"
elif [[ "$mode" == 3 ]]; then
  vf="scale=-2:720,\
tblend=all_mode=difference,\
tblend=all_mode=difference,\
tblend=all_mode=difference,\
spp=4:10,\
tblend=all_mode=average,\
tblend=all_mode=difference,\
tblend=all_mode=difference,\
tblend=all_mode=difference,\
spp=4:10,\
tblend=all_mode=average,\
tblend=all_mode=difference,\
tblend=all_mode=difference,\
tblend=all_mode=difference,\
spp=4:10,\
tblend=all_mode=average,\
tblend=all_mode=difference,\
tblend=all_mode=difference,\
tblend=all_mode=difference"
elif [[ "$mode" == 4 ]]; then
  vf="scale=-2:720,\
tblend=all_mode=difference128,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
spp=4:10,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
spp=4:10,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
spp=4:10,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=average,\
tblend=all_mode=difference128"
fi


ffmpeg -i "$1" -c:v prores -profile:v 3 -vf $vf "${1%%.*}_tblend_glitch.mov"
