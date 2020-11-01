#!/usr/bin/env bash

# Performs a glitchy tblend on the input video files
# source: https://oioiiooixiii.blogspot.com

# Parameters:
# $1: Input File 1
# $2: Blend Mode (choose a number between 1 and 4)

_usage(){
cat <<EOF
$(basename "${0}")
  Usage
   $(basename "${0}") [OPTIONS] INPUT_FILE_1 BLEND_MODE
  Options
   -h  display this help
   -p  previews in FFplay
   -s  saves to file with FFmpeg

  Notes
  Parameters:
  INPUT_FILE_1 Input File
  BLEND_MODE Choose a number between 1 and 4


  Outcome
   Performs a glitchy tblend on the input video files
   dependencies: ffmpeg 4.3 or later
EOF
}


mode="${3:-1}"    # blend mode (default is 1)

# Build filter string
if [[ "$mode" == 1 ]]; then
  vf="scale=-2:720,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
spp=4:10,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
spp=4:10,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
spp=4:10,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128"
elif [[ "$mode" == 2 ]]; then
  vf="scale=-2:720,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
spp=4:10,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
spp=4:10,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
spp=4:10,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
spp=4:10,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
spp=4:10,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
spp=4:10,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
spp=4:10,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
spp=4:10,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
spp=4:10,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
spp=4:10,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
spp=4:10,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
spp=4:10,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
spp=4:10,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
spp=4:10,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128,\
tblend=all_mode=difference128"
elif [[ "$mode" == 3 ]]; then
  vf="scale=-2:720,\
tblend=all_mode=difference,\
tblend=all_mode=difference,\
tblend=all_mode=difference,\
spp=4:10,\
tblend=all_mode=average,\
tblend=all_mode=difference,\
tblend=all_mode=difference,\
tblend=all_mode=difference,\
spp=4:10,\
tblend=all_mode=average,\
tblend=all_mode=difference,\
tblend=all_mode=difference,\
tblend=all_mode=difference,\
spp=4:10,\
tblend=all_mode=average,\
tblend=all_mode=difference,\
tblend=all_mode=difference,\
tblend=all_mode=difference"
elif [[ "$mode" == 4 ]]; then
  vf="scale=-2:720,\
tblend=all_mode=difference128,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
spp=4:10,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
spp=4:10,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
spp=4:10,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=average,\
tblend=all_mode=difference128,\
tblend=all_mode=average,\
tblend=all_mode=difference128"
fi

while getopts "hps" OPT ; do
    case "${OPT}" in
      h) _usage ; exit 0
        ;;
      p)

         printf "\n\n*******START FFPLAY COMMANDS*******\n" >&2
         printf "ffmpeg -hide_banner -i '$2' -c:v prores -profile:v 3 -vf $vf -f matroska - | ffplay - \n" >&2
         printf "********END FFPLAY COMMANDS********\n\n " >&2
         ffmpeg -hide_banner -i "${2}" -c:v prores -profile:v 3 -vf $vf -f matroska - | ffplay -
         ;;
      s)
         printf "\n\n*******START FFMPEG COMMANDS*******\n" >&2
         printf "ffmpeg -hide_banner -i '$2' -c:v prores -profile:v 3 -vf $vf '${2%.*}_tblend_glitch.mov' \n" >&2
         printf "********END FFMPEG COMMANDS********\n\n " >&2
         ffmpeg -hide_banner -i "${2}" -c:v prores -profile:v 3 -vf $vf "${2%.*}_tblend_glitch.mov"
         ;;
      *) echo "bad option -${OPTARG}" ; _usage ; exit 1 ;
    esac
  done
