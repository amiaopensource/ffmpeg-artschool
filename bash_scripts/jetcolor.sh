#!/usr/bin/env bash

# Uses pseudocolor to create a "jet color" effect

# Parameters:
# $1: File 1 (input file)
# $2: Mode, 1, 2 or 3. Default is 1

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
   MODE: a number 1, 2, or 3 that selects the channels being manipulated. [Default is 1]

  Outcome
   Uses pseudocolor to create a "jet color" effect.
   dependencies: ffmpeg 4.3 or later
EOF
}

if [[ $3 = 1 ]]; then
   modeSelect="0"
elif [[ $3 = 2 ]]; then
   modeSelect="1"
elif [[ $3 = 3 ]]; then
   modeSelect="2"
else
   modeSelect="0"
fi

filter_string="format=gbrp10le,eq=brightness=0.40:saturation=8,pseudocolor='if(between(val,0,85),lerp(45,159,(val-0)/(85-0)),if(between(val,85,170),lerp(159,177,(val-85)/(170-85)),if(between(val,170,255),lerp(177,70,(val-170)/(255-170))))):if(between(val,0,85),lerp(205,132,(val-0)/(85-0)),if(between(val,85,170),lerp(132,59,(val-85)/(170-85)),if(between(val,170,255),lerp(59,100,(val-170)/(255-170))))):if(between(val,0,85),lerp(110,59,(val-0)/(85-0)),if(between(val,85,170),lerp(59,127,(val-85)/(170-85)),if(between(val,170,255),lerp(127,202,(val-170)/(255-170))))):i=$modeSelect',format=yuv422p10le"


while getopts "hps" OPT ; do
    case "${OPT}" in
      h) _usage ; exit 0
        ;;
      p)
         ffmpeg -hide_banner -i "${2}" -c:v prores -profile:v 3 -filter_complex $filter_string -f matroska - | ffplay -
         printf "\n\n*******START FFPLAY COMMANDS*******\n" >&2
         printf "ffmpeg -hide_banner -i '$2' -c:v prores -profile:v 3 -filter_complex $filter_string -f matroska - | ffplay - \n" >&2
         printf "********END FFPLAY COMMANDS********\n\n " >&2
         ;;
      s)
         ffmpeg -hide_banner -i "${2}" -c:v prores -profile:v 3 -filter_complex $filter_string "${2%.*}_jetcolor.mov"
         printf "\n\n*******START FFMPEG COMMANDS*******\n" >&2
         printf "ffmpeg -hide_banner -i '$2' -c:v prores -profile:v 3 -filter_complex $filter_string '${2%.*}_jetcolor.mov' \n" >&2
         printf "********END FFMPEG COMMANDS********\n\n " >&2
         ;;
      *) echo "bad option -${OPTARG}" ; _usage ; exit 1 ;
    esac
  done


# gen's original code below the line here

# boost levels
#ffmpeg -i /Users/pamiqc/Desktop/LiquidLoopsClip.mp4 -vf eq=brightness=0.40:saturation=8 -c:a copy brightLiquidTest.mp4

# pseudocolor gradient for high levels
#ffmpeg -i /Users/pamiqc/brightLiquidTest.mp4 -vf pseudocolor="'if(between(val,ymax,amax),lerp(ymin,ymax,(val-ymax)/(amax-ymax)),-1):if(between(val,ymax,amax),lerp(umax,umin,(val-ymax)/(amax-ymax)),-1):if(between(val,ymax,amax),lerp(vmin,vmax,(val-ymax)/(amax-ymax)),-1):-1'" test2.mp4
