#!/usr/bin/env bash

# Rotates the input file with options to resize the output

# Parameters:
# $1: Input File
# $2: Rotation amount
# $3: Stretch to conform output to input aspect ratio

_usage(){
cat <<EOF
$(basename "${0}")
  Usage
   $(basename "${0}") [OPTIONS] INPUT_FILE_1 ROTATION STRETCH
  Options
   -h  display this help
   -p  previews in FFplay
   -s  saves to file with FFmpeg

  Notes
  Parameters:
  INPUT_FILE_1 Input File
  ROTATION Rotation amount in degrees. Must be 90, 180, or 270
  STRETCH Stretch to conform output to input aspect ratio. 1 for true 0 for false

  Outcome
   Rotates the input file with options to resize the output
   dependencies: ffmpeg 4.3 or later
EOF
}


  rotation="${3:-180}"    # rotation degrees, must be 90, 180, or 270
  stretch="${4:-1}"    # Whether to stretch the output to conform to the input. Default is 1 or true, 0 is false

  # Build filter string
  if [[ "$rotation" == 90 ]]; then
    vf="transpose=2"
  elif [[ "$rotation" == 180 ]]; then
    vf="transpose=2,transpose=2"
  elif [[ "$rotation" == 270 ]]; then
    vf="transpose=2,transpose=2,transpose=2"
  else
    printf "ERROR: Frame rotation must be either 90, 180, or 270\n" >&2
    exit
  fi

  if [ "$stretch" == 0 ]; then
    vf=$vf",format=yuv422p10le"
  else
    inputFrameSize=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "${2}") #gets input file dimensions
    inputDAR=$(ffprobe -v error -select_streams v:0 -show_entries stream=display_aspect_ratio -of csv=s=x:p=0 "${2}") #gets input file display aspect ratio
    vf=$vf",scale=${inputFrameSize/x/:},format=yuv422p10le -aspect "$inputDAR  #adds a portion to the filter to scale the output to the same dimensions as input
  fi

# Alter/replace FFmpeg command to desired specification

while getopts ":hps" OPT ; do
    case "${OPT}" in
      h) _usage ; exit 0 ;;
      p) ffmpeg -hide_banner -i "${2}" -c:v prores -profile:v 3 -filter_complex $vf -f matroska - | ffplay -
         printf "\n\n*******START FFPLAY COMMANDS*******\n" >&2
         printf "ffmpeg -hide_banner -i '$2' -c:v prores -profile:v 3 -filter_complex $vf -f matroska - | ffplay - \n" >&2
         printf "********END FFPLAY COMMANDS********\n\n" >&2
         ;;
      s) ffmpeg -hide_banner -i "${2}" -c:v prores -profile:v 3 -filter_complex $vf "${2%.*}_rotate.mov"
         printf "\n\n*******START FFMPEG COMMANDS*******\n" >&2
         printf "ffmpeg -hide_banner -i '$2' -c:v prores -profile:v 3 -filter_complex $vf '${2%.*}_rotate.mov' \n" >&2
         printf "********END FFMPEG COMMANDS********\n\n" >&2
         ;;
      *) echo "Error: bad option -${OPTARG}" ; _usage ; exit 1 ;;
    esac
done
