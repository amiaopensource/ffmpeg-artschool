#!/usr/bin/env bash

# Combine two files using a lumakey effect

# Parameters:
# $1: File 1 the file that will have echo added to it
# $2: Echo rate
# $3: Length of trails. 1 is just one trails, number increases exponentially as it goes.
# $4: Echo Modes (chooese 1 thru 5)

# Explanation of blend modes
# 1: Normal mode, nice and balanced with evenly blending trails, but gets out of hand with a higher tail length.
# 2: Screen mode, Works well with high contrast stuff but gets out of hand very quickly
# 3: Phoenix mode, cool psychedelic effect
# 4: Softlight mode, trails dissapapte very quickly, a subtle effect.
# 5: Average mode, Similar to normal with slightly different colors.
# 6: Heat mode, image is harshly affects.
# 7: Xor mode, very cool strobing effect
# 8: Difference mode, slightly less intense than xor but similar

_usage(){
cat <<EOF
$(basename "${0}")
  Usage
   $(basename "${0}") [OPTIONS] INPUT_FILE ECHO_RATE TRAIL_LENGTH ECHO_MODE
  Options
   -h  display this help
   -p  previews in FFplay
   -s  saves to file with FFmpeg

  Notes
  Parameters:
   INPUT_FILE The file that will have echo added to it
   ECHO_RATE Echo rate in seconds. default is 0.2
   TRAIL_LENGTH Length of trails. 1 is just one trails, number increases exponentially as it goes.
   ECHO_MODE Echo Modes (choose 1 thru 8)

  Echo modes:
   1: Normal mode, nice and balanced with evenly blending trails, but gets out of hand with a higher tail length.
   2: Screen mode, Works well with high contrast stuff but gets out of hand very quickly.
   3: Phoenix mode, cool psychedelic effect.
   4: Softlight mode, trails dissipate very quickly, a subtle effect.
   5: Average mode, Similar to normal with slightly different colors.
   6: Heat mode, image is harshly affected.
   7: Xor mode, very cool strobing effect.
   8: Difference mode, slightly less intense than xor but similar.

  Outcome
   Adds echo trails to a video file
   dependencies: ffmpeg 4.3 or later
EOF
}


echoRate="${3:-0.2}"          # Echo rate
trails="${4:-2}"              # Number of trails
blendMode="${5:-1}"           # Echo Mode
echofeedback=""
ptsDelay="0"

if [[ $blendMode = 1 ]]; then
  blendString="blend=all_mode=normal:c0_opacity=.5:c1_opacity=.5"
  formatMode="yuv422p10le"
elif [[ $blendMode = 2 ]]; then
  blendString="blend=all_mode=screen"
  formatMode="gbrp10le"
elif [[ $blendMode = 3 ]]; then
  blendString="blend=all_mode=phoenix"
  formatMode="gbrp10le"
elif [[ $blendMode = 4 ]]; then
  blendString="blend=all_mode=softlight"
  formatMode="gbrp10le"
elif [[ $blendMode = 5 ]]; then
  blendString="blend=all_mode=average:c0_opacity=.5:c1_opacity=.5"
  formatMode="yuv422p10le"
elif [[ $blendMode = 6 ]]; then
  blendString="blend=all_mode=heat:c0_opacity=.75:c1_opacity=.25"
  formatMode="yuv422p10le"
elif [[ $blendMode = 7 ]]; then
  blendString="blend=all_mode=xor"
  formatMode="yuv422p10le"
elif [[ $blendMode = 8 ]]; then
  blendString="blend=all_mode=difference"
  formatMode="gbrp10le"
else
  blendString="blend=all_mode=normal:c0_opacity=.5:c1_opacity=.5"
  formatMode="yuv422p10le"
fi


for (( i=1;i<${trails};i++ ))
{
   # 'bc' command used for floating point addition
   ptsDelay="$(bc <<<"${ptsDelay}+${echoRate}")"
   echofeedback="[wet]split[wet2Blend][wet2Feedback],[wet2Feedback]setpts=PTS+($ptsDelay/TB)[wetFromFeedback];[wetFromFeedback]format=${formatMode}[wetFromFeedback];[wetFromFeedback]format=${formatMode}[wetFromFeedback];[wetFromFeedback][wet2Blend]$blendString[wet];"$echofeedback
}

echofilter="split[dry][toEcho];[toEcho]setpts=PTS+($echoRate/TB)[wet];${echofeedback}[wet]format=${formatMode}[wet];[dry]format=${formatMode}[dry];[wet][dry]$blendString[outRGB];[outRGB]format=yuv422p10le[out]"


while getopts ":hps" OPT ; do
    case "${OPT}" in
      h) _usage ; exit 0 ;;
      p) ffmpeg -hide_banner -i "${2}" -c:v prores -profile:v 3 -filter_complex $echofilter -map '[out]' -f matroska - | ffplay -
         printf "\n\n*******START FFPLAY COMMANDS*******\n" >&2
         printf "ffmpeg -hide_banner -i '$2' -c:v prores -profile:v 3 -filter_complex \"$echofilter\" -map '[out]' -f matroska - | ffplay - \n" >&2
         printf "********END FFPLAY COMMANDS********\n\n" >&2
         ;;
      s) ffmpeg -hide_banner -i "${2}" -c:v prores -profile:v 3 -filter_complex $echofilter -map '[out]' "${2%.*}_echo.mov"
         printf "\n\n*******START FFMPEG COMMANDS*******\n" >&2
         printf "ffmpeg -hide_banner -i '$2' -c:v prores -profile:v 3 -filter_complex \"$echofilter\" -map '[out]' '${2%.*}_echo.mov' \n" >&2
         printf "********END FFMPEG COMMANDS********\n\n" >&2
         ;;
      *) echo "Error: bad option -${OPTARG}" ; _usage ; exit 1 ;;
    esac
done
