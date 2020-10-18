#!/usr/bin/env bash

# convolves two files together

# Parameters:
# $1: Input File 1
# $2: Input File 2


ffmpeg -i "$1" -i "$2" -c:v prores -profile:v 3 -filter_complex '[0:v][1:v]scale2ref[v0][v1];[v0]format=yuv422p10le[v0];[v1]format=yuv422p10le[v1];[v0][v1]convolve [out]' -map '[out]' "${1%%.*}_convolve.mov"
