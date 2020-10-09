#!/usr/bin/env bash

# Combine two files using a chromakey effects

# Parameters:
# $1: Input File 1
# $2: Input File 2

ffmpeg -i "$1" -i "$2" -c:v prores -profile:v 3 -filter_complex "blend=all_mode=difference" "${1}_difference.mov"
