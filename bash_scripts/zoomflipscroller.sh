#!/usr/bin/env bash

# Zoom in on a single line of video, flip and scroll vertically
# Inspired by sccyou

# Parameters:
# $1: Getopts selection, -p for FFplay, -s for FFmpeg
# $2: Input File
# $3: Line to zoom

_usage(){
cat <<EOF
$(basename "${0}")
  Usage
   $(basename "${0}") [OPTIONS] INPUT_FILE_1 LINE
  Options
   -h  display this help
   -p  previews in FFplay
   -s  saves to file with FFmpeg

  Notes
  Parameters:
  INPUT_FILE_1 Input File
  LINE Selects which line to zoom and scroll

  Outcome
   Zoom in on a single line of video, flip and scroll vertically
   dependencies: ffmpeg 4.3 or later
EOF
}

low=1
high=350
rand=$((low + RANDOM%(1+high-low)))

line="${3:-$rand}"    # user selected or, if not, random default value bet 1-200


vf=$vf"format=rgb24,crop=iw:1:0:$line,scale=iw:4:flags=neighbor,tile=layout=1x120:overlap=119:init_padding=119,setdar=4/3,format=yuv422p10le"

while getopts "ps" OPT ; do
    case "${OPT}" in
      p)
         ffplay "${2}" -vf $vf
         printf "\n\n*******START FFPLAY COMMANDS*******\n" >&2
         printf "ffplay '$2' -vf $vf \n" >&2
         printf "Line Selected: $line \n" >&2
         printf "********END FFPLAY COMMANDS********\n\n " >&2
        ;;
      s)
         ffmpeg -hide_banner -i "${2}" -c:v prores -profile:v 3 -vf $vf "${2}_zoomscroll.mov"
         printf "\n\n*******START FFMPEG COMMANDS*******\n" >&2
         printf "ffmpeg -i '$2' -c:v prores -profile:v 3 -filter_complex $vf '${2}_zoomscroll.mov' \n" >&2
         printf "Line Selected: $line \n" >&2
         printf "********END FFMPEG COMMANDS********\n\n " >&2
        ;;
    esac
  done
