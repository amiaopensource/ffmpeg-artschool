#!/usr/bin/env bash

# Allows the user to adjust the luma, black, chroma, and hue like a proc amp
# This script is set up to work like a DPS-290 Proc amp, where each value can be between -128 and 128, with 0 being the unchanged amount.

# Parameters:
# $1: Input File
# $2: Luma / Contrast
# $3: Black / Brightness
# $4: Chroma / Saturation
# $5: Hue

_usage(){
cat <<EOF
$(basename "${0}")
  Usage
   $(basename "${0}") [OPTIONS] INPUT_FILE_1 LUMA BLACK CHROMA HUE
  Options
   -h  display this help
   -p  previews in FFplay
   -s  saves to file with FFmpeg

  Notes
  Parameters:
   INPUT_FILE_1 The file that will have levels adjusted
   LUMA Adjusts the Luma/Contrast
   BLACK Adjusts the Black/Brightness
   CHROMA Adjusts the Chroma/Saturation
   HUE Adjusts the Hue/Color

  Outcome
   Adjust video levels similar to the way an analog procamp (processing amplifier) would.
   All levels are on a scale from -128 to 128
   dependencies: ffmpeg 4.3 or later
EOF
}

  user_luma="${3:-0}"    # luma - default vaue is 0
  user_black="${4:-0}"    # black - default vaue is 0
  user_chroma="${5:-0}"    # chroma - default vaue is 0
  user_hue="${6:-0}"    # hue - default vaue is 0


# This part scales the luma input into what lutyuv expects.

if ! [[ $user_luma =~ ^-?[0-9]+$ ]]; then
   printf "ERROR: Chroma must be a number -128 and 128\n" >&2
   exit
elif [[ "$user_luma" == 0 ]]; then
   luma="1"
elif [[ "$user_luma" -lt "-128" ]]; then
   printf "ERROR: Chroma must be between -128 and 128\n" >&2
   exit
elif [[ "$user_luma" -gt "128" ]]; then
   printf "ERROR: Chroma must be between -128 and 128\n" >&2
   exit
elif [[ "$user_luma" -lt "1" ]]; then
   scaler=0.0078125
   luma_temp=$(echo "scale=4; $user_luma*$scaler" | bc)
   luma=$(echo "$luma_temp + 1" | bc)
elif [[ "$user_luma" -ge "1" ]]; then
   scaler=0.015625
   luma_temp=$(echo "scale=4; $user_luma*$scaler" | bc)
   luma=$(echo "$luma_temp + 1" | bc)
fi


# This part scales the black input into what lutyuv expects.

if ! [[ $user_black =~ ^-?[0-9]+$ ]]; then
   printf "ERROR: Black must be a number -128 and 128\n" >&2
   exit
elif [[ "$user_black" == 0 ]]; then
   black="0"
elif [[ "$user_black" -lt "-128" ]]; then
   printf "ERROR: Black must be between -128 and 128\n" >&2
   exit
elif [[ "$user_black" -gt "128" ]]; then
   printf "ERROR: Black must be between -128 and 128\n" >&2
   exit
else
   scaler=1.40625
   black=$(echo "scale=4; $user_black*$scaler" | bc)
fi

# This part scales the chroma input into what lutyuv expects.

if ! [[ $user_chroma =~ ^-?[0-9]+$ ]]; then
   printf "ERROR: Chroma must be a number -128 and 128\n" >&2
   exit
elif [[ "$user_chroma" == 0 ]]; then
   chroma="1"
elif [[ "$user_chroma" -lt "-128" ]]; then
   printf "ERROR: Chroma must be between -128 and 128\n" >&2
   exit
elif [[ "$user_chroma" -gt "128" ]]; then
   printf "ERROR: Chroma must be between -128 and 128\n" >&2
   exit
elif [[ "$user_chroma" -lt "1" ]]; then
   scaler=0.0078125
   chroma_temp=$(echo "scale=4; $user_chroma*$scaler" | bc)
   chroma=$(echo "$chroma_temp + 1" | bc)
elif [[ "$user_chroma" -ge "1" ]]; then
   scaler=0.0703125
   chroma_temp=$(echo "scale=4; $user_chroma*$scaler" | bc)
   chroma=$(echo "$chroma_temp + 1" | bc)
fi

# This part scales the hue input into what lutyuv expects.

if ! [[ $user_hue =~ ^-?[0-9]+$ ]]; then
   printf "ERROR: Hue must be a number -128 and 128\n" >&2
   exit
elif [[ "$user_hue" == 0 ]]; then
   hue="0"
elif [[ "$user_hue" -lt "-128" ]]; then
   printf "ERROR: Hue must be between -128 and 128\n" >&2
   exit
elif [[ "$user_hue" -gt "128" ]]; then
   printf "ERROR: Hue must be between -128 and 128\n" >&2
   exit
else
   scaler=1.40625
   hue=$(echo "scale=4; $user_hue*$scaler" | bc)
fi

filter_complex="lutyuv=y=(val+${black})*${luma}:u=val:v=val,hue=h=${hue}:s=${chroma}"
filter_complex_display="'lutyuv=y=(val+${black})*${luma}:u=val:v=val,hue=h=${hue}:s=${chroma}'"

while getopts "hps" OPT ; do
    case "${OPT}" in
      h) _usage ; exit 0
        ;;
      p)
         ffmpeg -hide_banner -i "${2}" -c:v prores -profile:v 3 -filter_complex $filter_complex -f matroska - | ffplay -
         printf "\n\n*******START FFPLAY COMMANDS*******\n" >&2
         printf "ffmpeg -hide_banner -i '$2' -c:v prores -profile:v 3 -filter_complex $filter_complex_display -f matroska - | ffplay - \n" >&2
         printf "********END FFPLAY COMMANDS********\n\n " >&2
         ;;
      s)
         ffmpeg -hide_banner -i "${2}" -c:v prores -profile:v 3 -filter_complex $filter_complex "${2%.*}_procamp.mov"
         printf "\n\n*******START FFMPEG COMMANDS*******\n" >&2
         printf "ffmpeg -hide_banner -i '$2' -c:v prores -profile:v 3 -filter_complex $filter_complex_display '${2%.*}_procamp.mov' \n" >&2
         printf "********END FFMPEG COMMANDS********\n\n " >&2
         ;;
      *) echo "bad option -${OPTARG}" ; _usage ; exit 1 ;
    esac
  done
