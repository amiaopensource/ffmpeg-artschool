#!/usr/bin/env bash

# This script was originally written by oioiiooixiii and can be found at
# https://oioiiooixiii.blogspot.com/2020/07/ffmpeg-improved-rainbow-trail-effect.html

# Generate rainbow-trail video effect with FFmpeg.

# Parameters:
# $1: Filename
# $2: Colorkey value [default: 0000FF]
# $3: Colorkey similarity value [default: 0.3]
# $4: Colorkey blend value [default: 0.1]
# $5: Number of colour iterations [default: 7]
# $6: Delay between colours [default: 0.1]
# $7: Alpha plane extraction [default: true]

# version: 2020.07.20_13.54.28
#    - This version uses alpha plane extraction to significantly improve quality
#      and allows for correct keying with colours other than black. Alpha plane
#      extraction can be disabled for an alternative effect.
#    - Created & tested with FFmpeg 4.3.1, GNU Bash 4.4.2, and Ubuntu MATE 18.04

# source: http://oioiiooixiii.blogspot.com

_usage(){
cat <<EOF
$(basename "${0}")
  Usage
   $(basename "${0}") [OPTIONS] INPUT_FILE_1 KEY_COLOR KEY_SIM KEY_BLEND COLOR_ITER COLOR_DELAY ALPHA_EXTRACT
  Options
   -h  display this help
   -p  previews in FFplay
   -s  saves to file with FFmpeg

  Notes
  Parameters:
  INPUT_FILE_1 Filename
  KEY_COLOR Colorkey value [default: 0000FF] Either a hex value, or one of the following: green, blue, red, purple, orange, yellow
  KEY_SIM Colorkey similarity value [default: 0.3]
  KEY_BLEND Colorkey blend value [default: 0.1]
  COLOR_ITER Number of colour iterations [default: 7]
  COLOR_DELAY Delay between colours [default: 0.1]
  ALPHA_EXTRACT Alpha plane extraction [default: true]

  Outcome
   Generate rainbow-trail video effect with FFmpeg.
   dependencies: ffmpeg 4.3 or later
EOF
}

function rainbowFilter()
{
   local iterations="${4:-7}"    # Number of colour layers
   local delay="${5:-0.1}"       # Delay between appearance of each colour layer
   local ptsDelay=0              # Tally for delay between colour layers
   local key="0x${1:-0000FF}"    # Colorkey colour
   local colorSim="${2:-0.3}"    # Colorkey similarity level
   local colorBlend="${3:-0.1}"  # Colorkey blending level
   local filtergraph=""          # Used to store for-loop generated filterchains
                                 # Sets the state of the extractplanes filter
   if [[ $1 =~ ^[0-9A-F]{6}$ ]]
   then
     key=$1
 elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$1")  = "blue" ]]
   then
     key="0000FF"
 elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$1")  = "green" ]]
   then
     key="00FF00"
 elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$1")  = "red" ]]
   then
     key="FF0000"
 elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$1")  = "purple" ]]
   then
     key="0000FF"
 elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$1")  = "orange" ]]
   then
     key="ff9900"
 elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$1")  = "yellow" ]]
   then
     key="FFFF00"
   fi


   [[ "$6" == "false" ]] \
   && local extractFilter="null" || local extractFilter="extractplanes=a"

   declare -a colours                    # Array of colours
   colours+=("2:0:0:0:0:0:0:0:2:0:0:0")  # Violet
   colours+=(".5:0:0:0:0:0:0:0:2:0:0:0") # Indigo
   colours+=("0:0:0:0:0:0:0:0:2:0:0:0")  # Blue
   colours+=("0:0:0:0:2:0:0:0:0:0:0:0")  # Green
   colours+=("2:0:0:0:2:0:0:0:0:0:0:0")  # Yellow
   colours+=("2:0:0:0:.5:0:0:0:0:0:0:0") # Orange
   colours+=("2:0:0:0:0:0:0:0:0:0:0:0")  # Red

   # Build colour layers part of filtergraph
   for (( i=0;i<${iterations};i++ ))
   {
      # 'bc' command used for floating point addition
      ptsDelay="$(bc <<<"${ptsDelay}+${delay}")"
      filtergraph="[original]split[original][top];\
      [top]colorkey=${key}:${colorSim}:${colorBlend},${extractFilter},colorchannelmixer=${colours[$((i%7))]},setpts=PTS+$ptsDelay/TB,chromakey=black:0.01:0.1[top];\
      [bottom][top]overlay[bottom];${filtergraph}"

   }

   # Return full filtergraph, with necessary prefix and suffix filterchains
   printf '%s%s%s' "colorkey=${key}:${colorSim}:${colorBlend},split[original][bottom];\
   [bottom]colorchannelmixer=0:0:0:0:0:0:0:0:0:0:0:0[bottom];\
   ${filtergraph}[bottom][original]overlay,format=yuv422p10le"
}

while getopts "hps" OPT ; do
    case "${OPT}" in
      h) _usage ; exit 0
        ;;
      p)
         ffmpeg -hide_banner -i "${2}" -c:v prores -profile:v 3 -vf "$(rainbowFilter "${@:3}")" -f nut - | ffplay -
         printf "\n\n*******START FFPLAY COMMANDS*******\n" >&2
         printf "ffmpeg -hide_banner -i '$2' -c:v prores -profile:v 3 -vf \"$(rainbowFilter "${@:3}")\" -f nut - | ffplay - \n" >&2
         printf "********END FFPLAY COMMANDS********\n\n " >&2
         ;;
      s)
         ffmpeg -hide_banner -i "${2}" -c:v prores -profile:v 3 -vf "$(rainbowFilter "${@:3}")" "${2%.*}_rainbowTrails.mov"
         printf "\n\n*******START FFMPEG COMMANDS*******\n" >&2
         printf "ffmpeg -hide_banner -i '$2' -c:v prores -profile:v 3 -vf \"$(rainbowFilter "${@:3}")\" '${2%.*}_rainbowTrails.mov' \n" >&2
         printf "********END FFMPEG COMMANDS********\n\n " >&2
         ;;
      *) echo "bad option -${OPTARG}" ; _usage ; exit 1 ;
    esac
  done
