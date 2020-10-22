#!/usr/bin/env bash

# applies the tblend filter with arbitrary blend mode

# Parameters:
# $1: Input File 1
# $2: Blend Mode

# acceptabel blend mode options:
# addition, addition128, grainmerge, and, average, burn, darken, difference, difference128, grainextract,
# divide, dodge, freeze, exclusion, extremity, glow, hardlight, hardmix, heat,
# lighten, linearlight, multiply, multiply128, negation, normal, or, overlay,
# phoenix, pinlight, reflect, screen, softlight, subtract, vividlight, xor


ffmpeg -i "$1" -c:v prores -profile:v 3 -filter_complex "format=rgba,tblend=all_mode='$2',format=yuv422p10le" "${1%%.*}_tblend_${2}.mov"
