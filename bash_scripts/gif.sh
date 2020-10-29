#!/usr/bin/env bash

# Turn an input video file into a gif

# Parameters:
# $1: Input File
# $2: Quality: 0 = more compressed smaller file, 1 = less compressed bigger file

_usage(){
cat <<EOF
$(basename "${0}")
  Usage
   $(basename "${0}") [OPTIONS] INPUT_FILE QUALITY
  Options
   -h  display this help
   -s  saves to file with FFmpeg

  Notes
  PLAY MODE IS DISABLED FOR THIS SCRIPT
  Parameters:
   INPUT_FILE The file that will be turned into a GIF
   QUALITY 0 = more compressed smaller file, 1 = less compressed bigger file

  Outcome
   turns a video file into a GIF
   dependencies: ffmpeg 4.3 or later
EOF
}


qualityMode="${3:-0}"         # selects the plane mode. We've created templates that make cool patterns

if [[ $qualityMode = 0 ]]
then
   palletteFilter="fps=10,scale=500:-1:flags=lanczos,palettegen=stats_mode=diff"
   gifFilter="[0:v]fps=10,scale=500:-1:flags=lanczos[v],[v][1:v]paletteuse=dither=bayer:bayer_scale=5:diff_mode=rectangle"
elif [[ $qualityMode = 1 ]]
then
   palletteFilter="fps=10,scale=500:-1:flags=lanczos,palettegen"
   gifFilter="[0:v]fps=10,scale=500:-1:flags=lanczos[v],[v][1:v]paletteuse"
else
   printf "ERROR: Quality must be either 0 (more compresstion) or 1 (less compression)\n" >&2
   exit
fi

palette=$(dirname "$2")/palette.png

while getopts "hs" OPT ; do
    case "${OPT}" in
      h) _usage ; exit 0
        ;;
      s)
         printf "\n\n*******START FFMPEG COMMANDS*******\n" >&2
         printf "ffmpeg -hide_banner -i '${2}' -filter_complex $palletteFilter '${palette}' \n" >&2
         printf "ffmpeg -hide_banner -i '${2}' -i "${palette}" -filter_complex $gifFilter '${2%%.*}.gif' \n" >&2
         printf "\n********END FFMPEG COMMANDS********\n\n " >&2
         ffmpeg -hide_banner -i "${2}" -filter_complex $palletteFilter "${palette}"
         ffmpeg -hide_banner -i "${2}" -i "${palette}" -filter_complex $gifFilter "${2%%.*}.gif"
         rm "${palette}"
         ;;
      *) echo "bad option -${OPTARG}" ; _usage ; exit 1 ;
    esac
  done
