#!/usr/bin/env bash

# Trims file based upon user-defined timestamps (HH:MM:SS)

# Parameters:
# $1: Input File
# $2: Beginning timestamp
# $3: Ending timestamp

_usage(){
cat <<EOF
$(basename "${0}")
  Usage
   $(basename "${0}") [OPTIONS] INPUT_FILE_1 BEGINNING_TS ENDING_TS
  Options
   -h  display this help
   -p  previews in FFplay
   -s  saves to file with FFmpeg

  Notes
  Parameters:
  INPUT_FILE_1 Input File
  BEGINNING_TS Timestamp of the input video to start the output video (HH:MM:SS)
  ENDING_TS Timestamp of the input video to end the output video (HH:MM:SS)

  Outcome
   Trims file based upon user-defined timestamps (HH:MM:SS)
   dependencies: ffmpeg 4.3 or later
EOF
}

while getopts "ps" OPT ; do
    case "${OPT}" in
      p)
         ffplay -hide_banner -i "${2} "-ss $3 -t $4
         printf "\n\n*******START FFPLAY COMMANDS*******\n" >&2
         printf "ffplay -hide_banner -i "$2" -ss $3 -t $4 \n" >&2
         printf "********END FFPLAY COMMANDS********\n\n " >&2
        ;;
      s)
         ffmpeg -hide_banner -i "${2}" -ss $3 -to $4 -c copy -map 0 "${2%.*}_trim.mov"
         printf "\n\n*******START FFMPEG COMMANDS*******\n" >&2
         printf "ffmpeg -i '$2' -ss $3 -to $4 -c copy -map 0 '${2%.*}_trim.mov' \n" >&2
         printf "********END FFMPEG COMMANDS********\n\n " >&2
        ;;
    esac
  done
