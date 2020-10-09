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
      filtergraph="[original]split[original][top];
                   [top]colorkey=${key}:${colorSim}:${colorBlend},
                        ${extractFilter},
                        colorchannelmixer=${colours[$((i%7))]},
                        setpts=PTS+$ptsDelay/TB,
                        chromakey=black:0.01:0.1[top];
                   [bottom][top]overlay[bottom];
                   ${filtergraph}"
   }

   # Return full filtergraph, with necessary prefix and suffix filterchains
   printf '%s%s%s' "colorkey=${key}:${colorSim}:${colorBlend},
                    split[original][bottom];
                    [bottom]colorchannelmixer=0:0:0:0:0:0:0:0:0:0:0:0[bottom];"\
                   "${filtergraph}"\
                   "[bottom][original]overlay"
}

# Alter/replace FFmpeg command to desired specification
ffmpeg -i "$1" -vf "$(rainbowFilter "${@:2}")" -crf 10 "${1}_rainbow.mkv"
