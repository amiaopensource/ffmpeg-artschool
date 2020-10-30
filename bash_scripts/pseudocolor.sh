#!/usr/bin/env bash

# boosts levels and then adds gradient for out of range pixels using pseudocolor

# Parameters:
# $1: File 1 (input file)

_usage(){
cat <<EOF
$(basename "${0}")
  Usage
   $(basename "${0}") [OPTIONS] INPUT_FILE_1
  Options
   -h  display this help
   -p  previews in FFplay
   -s  saves to file with FFmpeg

  Notes
  Parameters:
   INPUT_FILE_1 The file that will be processed

  Outcome
   Boosts Levels and then adds gradient for out of ranger pixels using psuedocolor.
   dependencies: ffmpeg 4.3 or later
EOF
}


while getopts "hps" OPT ; do
    case "${OPT}" in
      h) _usage ; exit 0
        ;;
      p)

         printf "\n\n*******START FFPLAY COMMANDS*******\n" >&2
         printf "ffmpeg -hide_banner -i '$2' -c:v prores -profile:v 3 -filter_complex $filter_string -f matroska - | ffplay - \n" >&2
         printf "********END FFPLAY COMMANDS********\n\n " >&2
         ffmpeg -hide_banner -i "${2}" -c:v prores -profile:v 3 -filter_complex $filter_string -f matroska - | ffplay -
         ;;
      s)
         printf "\n\n*******START FFMPEG COMMANDS*******\n" >&2
         printf "ffmpeg -hide_banner -i '$2' -c:v prores -profile:v 3 -filter_complex $filter_string '${2%%.*}_psuedocolor.mov' \n" >&2
         printf "********END FFMPEG COMMANDS********\n\n " >&2
         ffmpeg -hide_banner -i "${2}" -c:v prores -profile:v 3 -filter_complex $filter_string "${2%%.*}_psuedocolor.mov"
         ;;
      *) echo "bad option -${OPTARG}" ; _usage ; exit 1 ;
    esac
  done


# gen's original code below the line here

# boost levels
#ffmpeg -i /Users/pamiqc/Desktop/LiquidLoopsClip.mp4 -vf eq=brightness=0.40:saturation=8 -c:a copy brightLiquidTest.mp4

# pseudocolor gradient for high levels
#ffmpeg -i /Users/pamiqc/brightLiquidTest.mp4 -vf pseudocolor="'if(between(val,ymax,amax),lerp(ymin,ymax,(val-ymax)/(amax-ymax)),-1):if(between(val,ymax,amax),lerp(umax,umin,(val-ymax)/(amax-ymax)),-1):if(between(val,ymax,amax),lerp(vmin,vmax,(val-ymax)/(amax-ymax)),-1):-1'" test2.mp4
