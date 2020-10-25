#!/usr/bin/env bash

# Manipulate Y, U, and V bitplanes to make colorful creations

_usage(){
cat <<EOF
$(basename "${0}")
  Usage
   $(basename "${0}") [OPTIONS] MOVIE_FILE_1.mov Y value, U value, V, value
  Options
   -h  display this help
   -p  previews in FFplay
   -s  saves to file with FFmpeg
  Outcome
   will play or save file with user-selected or random bitplane values
   dependencies: ffmpeg 4.3 or later
EOF
}

low=1
high=8
rand1=$((low + RANDOM%(1+high-low)))
rand2=$((low + RANDOM%(1+high-low)))
rand3=$((low + RANDOM%(1+high-low)))

Y="${3:-$rand1}"    # user selected or, if not, random default value bet 1-8
U="${4:-$rand2}"    # user selected or, if not, random default value bet 1-8
V="${5:-$rand3}"    # user selected or, if not, random default value bet 1-8

vf=$vf"format=yuv420p10le|yuv422p10le|yuv444p10le|yuv440p10le,lutyuv=y=if(eq($Y\,-1)\,512\,if(eq($Y\,0)\,val\,bitand(val\,pow(2\,10-$Y))*pow(2\,$Y))):u=if(eq($U\,-1)\,512\,if(eq($U\,0)\,val\,bitand(val\,pow(2\,10-$U))*pow(2\,$U))):v=if(eq($V\,-1)\,512\,if(eq($V\,0)\,val\,bitand(val\,pow(2\,10-$V))*pow(2\,$V))),format=yuv422p10le"

while getopts "hps" OPT ; do
    case "${OPT}" in
      h) _usage ; exit 0
        ;;
      p)
        printf "\n\n*******START FFPLAY COMMANDS*******\n" >&2
        echo "Y=$Y"
        echo "U=$U"
        echo "V=$V"
        echo ffplay "$2" -vf $vf
        printf "********END FFPLAY COMMANDS********\n\n " >&2
        ffplay "$2" -vf $vf
        ;;
      s)
        printf "\n\n*******START FFMPEG COMMANDS*******\n" >&2
        echo "Y=$Y"
        echo "U=$U"
        echo "V=$V"
        echo ffmpeg -i "'$2'" -c:v prores -profile:v 3 -filter_complex $vf "'${2}_bitplane.mov'"
        printf "********END FFMPEG COMMANDS********\n\n " >&2
        ffmpeg -hide_banner -i "$2" -c:v prores -profile:v 3 -vf $vf "${2}_bitplane.mov"
        ;;
      *) echo "bad option -${OPTARG}" ; _usage ; exit 1 ;
    esac
  done
