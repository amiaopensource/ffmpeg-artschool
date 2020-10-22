#!/usr/bin/env bash

# Combine two files using a lumakey effect

# Parameters:
# $1: File 1 (the overaly file, or the file that will be keyed)
# $2: Echo rate
# $3: Length of tails. 1 is just one tail, number increases exponentially as it goes.
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


echoRate="${2:-0.2}"          # Echo rate
trails="${3:-2}"              # Number of trails
blendMode="${4:-1}"           # Echo Mode
echofeedback=""
ptsDelay="0"

if [[ $blendMode = 1 ]]
then
  blendString="blend=all_mode=normal:c0_opacity=.5:c1_opacity=.5"
  formatMode="yuv422p10le"
elif [[ $blendMode = 2 ]]
then
  blendString="blend=all_mode=screen"
  formatMode="gbrp10le"
elif [[ $blendMode = 3 ]]
then
  blendString="blend=all_mode=phoenix"
  formatMode="gbrp10le"
elif [[ $blendMode = 4 ]]
then
  blendString="blend=all_mode=softlight"
  formatMode="gbrp10le"
elif [[ $blendMode = 5 ]]
then
  blendString="blend=all_mode=average:c0_opacity=.5:c1_opacity=.5"
  formatMode="yuv422p10le"
elif [[ $blendMode = 6 ]]
then
  blendString="blend=all_mode=heat:c0_opacity=.75:c1_opacity=.25"
  formatMode="yuv422p10le"
elif [[ $blendMode = 7 ]]
then
  blendString="blend=all_mode=xor"
  formatMode="yuv422p10le"
elif [[ $blendMode = 8 ]]
then
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

# Alter/replace FFmpeg command to desired specification
printf "\n\n*******START FFMPEG COMMANDS*******\n" >&2
echo ffmpeg -i "'$1'" -c:v prores -profile:v 3 -filter_complex $echofilter -map '[out]' "'${1%%.*}_echo.mov'"
printf "********END FFMPEG COMMANDS********\n\n " >&2

ffmpeg -i "$1" -c:v prores -profile:v 3 -filter_complex $echofilter -map '[out]' "${1%%.*}_echo.mov"
