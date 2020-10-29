#!/usr/bin/env bash

# Reverses the input file

# Parameters:
# $1: Input File

_usage(){
cat <<EOF
$(basename "${0}")
  Usage
   $(basename "${0}") [OPTIONS] INPUT_FILE_1 REPEATS
  Options
   -h  display this help
   -p  previews in FFplay
   -s  saves to file with FFmpeg

  Notes
  PLAY MODE IS DISABLED FOR THIS SCRIPT

  Parameters:
  INPUT_FILE_1 Input File

  Outcome
   Reverses the input file
   dependencies: ffmpeg 4.3 or later
EOF
}

while getopts "hps" OPT ; do
    case "${OPT}" in
      h) _usage ; exit 0
        ;;
      p)

         printf "\n\n*******START FFPLAY COMMANDS*******\n" >&2
         printf "ffmpeg -hide_banner -i '$2' -c:v prores -profile:v 3 -vf reverse -f matroska - | ffplay - \n" >&2
         printf "********END FFPLAY COMMANDS********\n\n " >&2
         ffmpeg -hide_banner -i "${2}" -c:v prores -profile:v 3 -vf reverse -f matroska - | ffplay -
         ;;
      s)
         printf "\n\n*******START FFMPEG COMMANDS*******\n" >&2
         printf "ffmpeg -hide_banner -i '$2' -c:v prores -profile:v 3 -vf reverse '${2%%.*}_reverse.mov' \n" >&2
         printf "********END FFMPEG COMMANDS********\n\n " >&2
         ffmpeg -hide_banner -i "${2}" -c:v prores -profile:v 3 -vf reverse "${2%%.*}_reverse.mov"
         ;;
      *) echo "bad option -${OPTARG}" ; _usage ; exit 1 ;
    esac
  done
