#!/usr/bin/env bash

# Creates ghost trails using hte lagfun effect

# Parameters:
# $1: Input File
# $2: Trail Mode
# $3: Trail Amount

_usage(){
cat <<EOF
$(basename "${0}")
  Usage
   $(basename "${0}") [OPTIONS] INPUT_FILE TRAIL_MODE TRAIL_AMOUNT
  Options
   -h  display this help
   -p  previews in FFplay
   -s  saves to file with FFmpeg

  Notes
  Parameters:
   INPUT_FILE The file that will have lagfun added to it
   TRAIL_MODE Picks a mode (1 thru 3). try different modes for fun!
   TRAIL_AMOUNT The intensity of the effect. Default is 1

  Outcome
   Adds the lagfun effect to a video file
   dependencies: ffmpeg 4.3 or later
EOF
}

trailMode="${3:-1}"         # selects the plane mode. We've created templates that make cool patterns
amount="${4:-1}"            # selects the intensity of the effect

if [[ $trailMode = 1 ]]
then
filterComplex="lagfun=decay=.95[out]"
elif [[ $trailMode = 2 ]]
then
  filterComplex="format=gbrp10[formatted];[formatted]lagfun=decay=.95:planes=5,format=yuv422p10le[out]"
elif [[ $trailMode = 3 ]]
then
  filterComplex="format=gbrp10[formatted];[formatted]split[a][b];[a]lagfun=decay=.99:planes=1[a];[b]lagfun=decay=.98:planes=2[b];[a][b]blend=all_mode=screen:c0_opacity=.5:c1_opacity=.5,format=yuv422p10le[out]"
fi

while getopts "hps" OPT ; do
    case "${OPT}" in
      h) _usage ; exit 0
        ;;
      p)

         printf "\n\n*******START FFPLAY COMMANDS*******\n" >&2
         printf "ffmpeg -hide_banner -i '$2' -c:v prores -profile:v 3 -filter_complex $filterComplex -map '[out]' -f matroska - | ffplay - \n" >&2
         printf "********END FFPLAY COMMANDS********\n\n " >&2
         ffmpeg -hide_banner -i "${2}" -c:v prores -profile:v 3 -filter_complex $filterComplex -map '[out]' -f matroska - | ffplay -
         ;;
      s)
         printf "\n\n*******START FFMPEG COMMANDS*******\n" >&2
         printf "ffmpeg -hide_banner -i '$2' -c:v prores -profile:v 3 -filter_complex $filterComplex -map '[out]' '${2%%.*}_lagfun.mov' \n" >&2
         printf "********END FFMPEG COMMANDS********\n\n " >&2
         ffmpeg -hide_banner -i "${2}" -c:v prores -profile:v 3 -filter_complex $filterComplex -map '[out]' "${2%%.*}_lagfun.mov"
         ;;
      *) echo "bad option -${OPTARG}" ; _usage ; exit 1 ;
    esac
  done
