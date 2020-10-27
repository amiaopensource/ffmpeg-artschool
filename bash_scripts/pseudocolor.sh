#!/usr/bin/env bash

# boosts levels and then adds gradient for out of range pixels using pseudocolor

# Parameters:
# $1: File 1 (input file)

#var1="${2:-0}"      # unused var [default 0]
#var2="${3:-0.1}"    # unused var [default 0.1]
#var3="${4:-0.2}"    # unused var [default: 0.2]

# Build filter string
filter_string="format=rgba,eq=brightness=0.40:saturation=8,pseudocolor='if(between(val,ymax,amax),lerp(ymin,ymax,(val-ymax)/(amax-ymax)),-1):if(between(val,ymax,amax),lerp(umax,umin,(val-ymax)/(amax-ymax)),-1):if(between(val,ymax,amax),lerp(vmin,vmax,(val-ymax)/(amax-ymax)),-1):-1',format=yuv422p10le"

# Alter/replace FFmpeg command to desired specification
printf "\n\n*******START FFMPEG COMMANDS*******\n" >&2
echo ffmpeg -i "'$1'" -c:v prores -profile:v 3 -filter_complex $filter_string "'${1%%.*}_psuedocolor.mov'"
printf "********END FFMPEG COMMANDS********\n\n " >&2

ffmpeg -i "$1" -c:v prores -profile:v 3 -filter_complex $filter_string "${1%%.*}_psuedocolor.mov"

# gen's original code below the line here

# boost levels
#ffmpeg -i /Users/pamiqc/Desktop/LiquidLoopsClip.mp4 -vf eq=brightness=0.40:saturation=8 -c:a copy brightLiquidTest.mp4

# pseudocolor gradient for high levels
#ffmpeg -i /Users/pamiqc/brightLiquidTest.mp4 -vf pseudocolor="'if(between(val,ymax,amax),lerp(ymin,ymax,(val-ymax)/(amax-ymax)),-1):if(between(val,ymax,amax),lerp(umax,umin,(val-ymax)/(amax-ymax)),-1):if(between(val,ymax,amax),lerp(vmin,vmax,(val-ymax)/(amax-ymax)),-1):-1'" test2.mp4
