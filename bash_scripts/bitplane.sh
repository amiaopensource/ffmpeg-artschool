#!/usr/bin/env bash

# Manipulate Y, U, and V bitplanes to make colorful creations

# Parameters:
# $1: Input File
# $2: Y bitplane
# $3: U bitplane
# $4: V bitplane

_usage(){
cat <<EOF
$(basename "${0}")
  Usage
   $(basename "${0}") [OPTIONS] INPUT_FILE Y_BITPLANE U_BITPLANE V_BITPLANE
  Options
   -h  display this help
   -p  previews in FFplay
   -s  saves to file with FFmpeg

  Notes


  Outcome
   Manipulate Y, U, and V bitplanes to make colorful creations
   dependencies: ffmpeg 4.3 or later
EOF
}


function filter_complex()
{

   low=1
   high=8
   rand1=$((low + RANDOM%(1+high-low)))
   rand2=$((low + RANDOM%(1+high-low)))
   rand3=$((low + RANDOM%(1+high-low)))

   Y="${3:-$rand1}"    # user selected or, if not, random default value bet 1-8
   U="${4:-$rand2}"    # user selected or, if not, random default value bet 1-8
   V="${5:-$rand3}"    # user selected or, if not, random default value bet 1-8

   vf=$vf"format=yuv420p10le|yuv422p10le|yuv444p10le|yuv440p10le,lutyuv=y=if(eq($Y\,-1)\,512\,if(eq($Y\,0)\,val\,bitand(val\,pow(2\,10-$Y))*pow(2\,$Y))):u=if(eq($U\,-1)\,512\,if(eq($U\,0)\,val\,bitand(val\,pow(2\,10-$U))*pow(2\,$U))):v=if(eq($V\,-1)\,512\,if(eq($V\,0)\,val\,bitand(val\,pow(2\,10-$V))*pow(2\,$V))),format=yuv422p10le"

   # Return full filter string, with necessary prefix and suffix filterchains
   printf '%s%s%s' $vf

}

while getopts "ps" OPT ; do
    case "${OPT}" in
      p)
        printf "\n\n*******START FFPLAY COMMANDS*******\n" >&2
        printf "echo ffplay '$2' -vf $(filter_complex)" >&2
        printf "********END FFPLAY COMMANDS********\n\n " >&2
        ffplay "${2}" -vf $(filter_complex)
        ;;
      s)
        printf "\n\n*******START FFMPEG COMMANDS*******\n" >&2
        printf "ffmpeg -hide_banner -i '$2'  -c:v prores -profile:v 3 -filter_complex $(filter_complex) '${2%%.*}_bitplane.mov'" >&2
        printf "********END FFMPEG COMMANDS********\n\n " >&2
        ffmpeg -hide_banner -i "${2}"  -c:v prores -profile:v 3 -vf $(filter_complex) "${2%%.*}_bitplane.mov"
        ;;
    esac
  done
