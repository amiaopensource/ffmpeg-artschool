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

Y="${2:-$rand1}"    # random default value bet 1-8
U="${3:-$rand2}"    # random default value bet 1-8
V="${4:-$rand3}"    # random default value bet 1-8

vf=$vf"format=yuv420p10le|yuv422p10le|yuv444p10le|yuv440p10le,lutyuv=y=if(eq($Y\,-1)\,512\,if(eq($Y\,0)\,val\,bitand(val\,pow(2\,10-$Y))*pow(2\,$Y))):u=if(eq($U\,-1)\,512\,if(eq($U\,0)\,val\,bitand(val\,pow(2\,10-$U))*pow(2\,$U))):v=if(eq($V\,-1)\,512\,if(eq($V\,0)\,val\,bitand(val\,pow(2\,10-$V))*pow(2\,$V))),format=yuv444p"

#printf "\n\n*******START FFMPEG COMMANDS*******\n" >&2
#echo ffmpeg -i "'$1'" -c:v libx264 -filter_complex $vf "'${1}_bitplane.mp4'"
#printf "********END FFMPEG COMMANDS********\n\n " >&2

#ffmpeg -hide_banner -i "$1" -c:v libx264 -vf $vf "${1}_bitplane.mp4"

printf "\n\n*******START FFPLAY COMMANDS*******\n" >&2
echo ffplay "$1" -vf $vf
printf "********END FFPLAY COMMANDS********\n\n " >&2

ffplay "$1" -vf $vf
