#!/usr/bin/env bash

# Combine two files using a chromakey effects

# Parameters:
# $1: Input File

ffmpeg -i "$1" -c:v prores -profile:v 3 -vf reverse "${1%%.*}_reverse.mov"
