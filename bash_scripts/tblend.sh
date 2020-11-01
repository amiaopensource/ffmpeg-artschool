#!/usr/bin/env bash

# applies the tblend filter with arbitrary blend mode

# Parameters:
# $1: Input File 1
# $2: Blend Mode

# acceptabel blend mode options:
# addition, addition128, grainmerge, and, average, burn, darken, difference, difference128, grainextract,
# divide, dodge, freeze, exclusion, extremity, glow, hardlight, hardmix, heat,
# lighten, linearlight, multiply, multiply128, negation, normal, or, overlay,
# phoenix, pinlight, reflect, screen, softlight, subtract, vividlight, xor

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
  BLEND_MODE Choose a blend mode from the following options:
  addition, addition128, grainmerge, and, average, burn, darken, difference, difference128, grainextract,
  divide, dodge, freeze, exclusion, extremity, glow, hardlight, hardmix, heat,
  lighten, linearlight, multiply, multiply128, negation, normal, or, overlay,
  phoenix, pinlight, reflect, screen, softlight, subtract, vividlight, xor

  Outcome
   Applies the tblend filter with arbitrary blend mode
   dependencies: ffmpeg 4.3 or later
EOF
}


filter_complex="format=gbrp10le,tblend=all_mode='$3',format=yuv422p10le"

while getopts "hps" OPT ; do
    case "${OPT}" in
      h) _usage ; exit 0
        ;;
      p)

         printf "\n\n*******START FFPLAY COMMANDS*******\n" >&2
         printf "ffmpeg -hide_banner -i '$2' -c:v prores -profile:v 3 -vf $filter_complex -f matroska - | ffplay - \n" >&2
         printf "********END FFPLAY COMMANDS********\n\n " >&2
         ffmpeg -hide_banner -i "${2}" -c:v prores -profile:v 3 -vf $filter_complex -f matroska - | ffplay -
         ;;
      s)
         printf "\n\n*******START FFMPEG COMMANDS*******\n" >&2
         printf "ffmpeg -hide_banner -i '$2' -c:v prores -profile:v 3 -vf $filter_complex '${2%.*}_tblend_${3}.mov' \n" >&2
         printf "********END FFMPEG COMMANDS********\n\n " >&2
         ffmpeg -hide_banner -i "${2}" -c:v prores -profile:v 3 -vf $filter_complex "${2%.*}_tblend_${3}.mov"
         ;;
      *) echo "bad option -${OPTARG}" ; _usage ; exit 1 ;
    esac
  done
