#!/usr/bin/env bash

# Colorize a video using colorchanelmixer

_usage(){
cat <<EOF
$(basename "${0}")
  Usage
   $(basename "${0}") [OPTIONS] INPUT_FILE COLOR
  Options
   -h  display this help
   -p  previews in FFplay
   -s  saves to file with FFmpeg

  Notes
  INPUT_FILE: File to be effected
  COLOR: red, orange, yellow, green, blue, purple, white or black

  Outcome
   Colorize a video using colorchanelmixer
   dependencies: ffmpeg 4.3 or later
EOF
}

color="${3:-blue}"    # Color channel mixer color

# Update color variable according to user input
# This makes the matching case insensitive

if [[ $(tr "[:upper:]" "[:lower:]" <<<"$color")  = "blue" ]]; then
  colorNums="0:0:0:0:0:0:0:0:2:0:0:0"
elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$color")  = "green" ]]; then
 colorNums="0:0:0:0:2:0:0:0:0:0:0:0"
elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$color")  = "red" ]]; then
  colorNums="2:0:0:0:0:0:0:0:0:0:0:0"
elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$color")  = "purple" ]]; then
  colorNums="2:0:0:0:0:0:0:0:2:0:0:0"
elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$color")  = "orange" ]]; then
  colorNums="2:0:0:0:.5:0:0:0:0:0:0:0"
elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$color")  = "yellow" ]]; then
  colorNums="2:0:0:0:2:0:0:0:0:0:0:0"
elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$color")  = "white" ]]; then
  colorNums="2:2:2:2:2:2:2:2:2:2:2:2"
elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$color")  = "black" ]]; then
  colorNums="2:2:2:2:2:2:2:2:2:2:2:2,lutyuv=y=negval"
else
  printf "ERROR: Selected Color must be red, orange, yellow, green, blue, purple, white or black \n" >&2
  exit 1
fi

# Build filter string
filterString="colorchannelmixer=${colorNums},format=yuv422p10le"

while getopts ":hps" OPT ; do
    case "${OPT}" in
      h) _usage ; exit 0 ;;
      p) ffmpeg -hide_banner -i "${2}" -c:v prores -profile:v 3 -vf $filterString -f matroska - | ffplay -
         printf "\n\n*******START FFPLAY COMMANDS*******\n" >&2
         printf "ffmpeg -hide_banner -i '$2' -c:v prores -vf '${filterString}' -f matroska - | ffplay - \n" >&2
         printf "********END FFPLAY COMMANDS********\n\n" >&2
         ;;
      s) ffmpeg -hide_banner -i "${2}" -c:v prores -profile:v 3 -vf $filterString "${2%.*}_colorize_$color.mov"
         printf "\n\n*******START FFMPEG COMMANDS*******\n" >&2
         printf "ffmpeg -hide_banner -i '$2' -c:v prores -profile:v 3 -vf $filterString '${2%.*}_colorize_$color.mov' \n" >&2
         printf "********END FFMPEG COMMANDS********\n\n" >&2
         ;;
      *) echo "Error: bad option -${OPTARG}" ; _usage ; exit 1 ;;
    esac
done
