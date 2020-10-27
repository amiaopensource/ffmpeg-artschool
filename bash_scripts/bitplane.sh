#!/usr/bin/env bash

# Manipulate Y, U, and V bitplanes to make colorful creations

# Parameters:
# $1: Input File
# $2: Y bitplane
# $3: U bitplane
# $4: V bitplane

low=1
high=8
rand1=$((low + RANDOM%(1+high-low)))
rand2=$((low + RANDOM%(1+high-low)))
rand3=$((low + RANDOM%(1+high-low)))

Y="${3:-$rand1}"    # user selected or, if not, random default value bet 1-8
U="${4:-$rand2}"    # user selected or, if not, random default value bet 1-8
V="${5:-$rand3}"    # user selected or, if not, random default value bet 1-8

vf=$vf"format=yuv420p10le|yuv422p10le|yuv444p10le|yuv440p10le,lutyuv=y=if(eq($Y\,-1)\,512\,if(eq($Y\,0)\,val\,bitand(val\,pow(2\,10-$Y))*pow(2\,$Y))):u=if(eq($U\,-1)\,512\,if(eq($U\,0)\,val\,bitand(val\,pow(2\,10-$U))*pow(2\,$U))):v=if(eq($V\,-1)\,512\,if(eq($V\,0)\,val\,bitand(val\,pow(2\,10-$V))*pow(2\,$V))),format=yuv422p10le"

while getopts "ps" OPT ; do
    case "${OPT}" in
      p)
        printf "\n\n*******START FFPLAY COMMANDS*******\n" >&2
        echo ffplay "$2" -vf $vf
        printf "********END FFPLAY COMMANDS********\n\n " >&2
        ffplay "$2" -vf $vf
        ;;
      s)
        printf "\n\n*******START FFMPEG COMMANDS*******\n" >&2
        echo ffmpeg -i "'$2'"  -c:v prores -profile:v 3 -filter_complex $vf "'${2%%.*}_bitplane.mov'"
        printf "********END FFMPEG COMMANDS********\n\n " >&2
        ffmpeg -hide_banner -i "$2"  -c:v prores -profile:v 3 -vf $vf "${2%%.*}_bitplane.mov"
        ;;
    esac
  done
