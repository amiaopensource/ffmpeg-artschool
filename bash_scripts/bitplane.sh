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

low=-1
high=10
rand1=$((low + RANDOM%(1+high-low)))
rand2=$((low + RANDOM%(1+high-low)))
rand3=$((low + RANDOM%(1+high-low)))

Y="${3:-$rand1}"    # user selected or, if not, random default value bet 1-8
U="${4:-$rand2}"    # user selected or, if not, random default value bet 1-8
V="${5:-$rand3}"    # user selected or, if not, random default value bet 1-8


filter_string="format=yuv420p10le|yuv422p10le|yuv444p10le|yuv440p10le,lutyuv=y=if(eq($Y\,-1)\,512\,if(eq($Y\,0)\,val\,bitand(val\,pow(2\,10-$Y))*pow(2\,$Y))):u=if(eq($U\,-1)\,512\,if(eq($U\,0)\,val\,bitand(val\,pow(2\,10-$U))*pow(2\,$U))):v=if(eq($V\,-1)\,512\,if(eq($V\,0)\,val\,bitand(val\,pow(2\,10-$V))*pow(2\,$V))),format=yuv422p10le"



while getopts ":hps" OPT ; do
    case "${OPT}" in
      h) _usage ; exit 0 ;;
      p) ffplay "${2}" -vf $filter_string
         printf "\n\n*******START FFPLAY COMMANDS*******\n" >&2
         echo "Y:" $Y
         echo "U:" $U
         echo "V:" $V
         printf "ffplay '$2' -vf '$filter_string'" >&2
         printf "\n********END FFPLAY COMMANDS********\n\n" >&2
         ;;
      s) ffmpeg -hide_banner -i "${2}"  -c:v prores -profile:v 3 -an -vf $filter_string "${2%.*}_bitplane.mov"
         printf "\n\n*******START FFMPEG COMMANDS*******\n" >&2
         echo "Y:" $Y
         echo "U:" $U
         echo "V:" $V
         printf "ffmpeg -hide_banner -i '$2'  -c:v prores -profile:v 3 -filter_complex '$filter_string' '${2%.*}_bitplane.mov'" >&2
         printf "\n********END FFMPEG COMMANDS********\n\n" >&2
         ;;
      *) echo "Error: bad option -${OPTARG}" ; _usage ; exit 1 ;;
    esac
done
