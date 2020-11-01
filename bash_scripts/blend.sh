#!/usr/bin/env bash

# blends two files together with an arbitrary blend mode

# Parameters:
# $1: Input File 1
# $2: Input File 2
# $3: Blend Mode

# acceptabel blend mode options:
# addition, addition128, grainmerge, and, average, burn, darken, difference, difference128, grainextract,
# divide, dodge, freeze, exclusion, extremity, glow, hardlight, hardmix, heat,
# lighten, linearlight, multiply, multiply128, negation, normal, or, overlay,
# phoenix, pinlight, reflect, screen, softlight, subtract, vividlight, xor

_usage(){
cat <<EOF
$(basename "${0}")
  Usage
   $(basename "${0}") [OPTIONS] INPUT_FILE_1 INPUT_FILE_2 BLEND_MODE
  Options
   -h  display this help
   -p  previews in FFplay
   -s  saves to file with FFmpeg

  Notes
  Here is the list of acceptable blend mode options:
  addition, addition128, grainmerge, and, average, burn, darken, difference, difference128, grainextract,
  divide, dodge, freeze, exclusion, extremity, glow, hardlight, hardmix, heat,
  lighten, linearlight, multiply, multiply128, negation, normal, or, overlay,
  phoenix, pinlight, reflect, screen, softlight, subtract, vividlight, xor

  Outcome
   Blends two files together with an arbitrary blend mode
   dependencies: ffmpeg 4.3 or later
EOF
}

function filter_complex()
{

local blendMode="${1:-addition128}"    # Default blend mode is addition128

filter_string="[1:v]format=gbrp10le[v1];[0:v]format=gbrp10le[v0];[v1][v0]scale2ref[v1][v0];[v0][v1]blend=all_mode='$blendMode',format=yuv422p10le [v]"

   # Return full filter string, with necessary prefix and suffix filterchains
   printf '%s%s%s' $filter_string

}

while getopts "hps" OPT ; do
    case "${OPT}" in
      h) _usage ; exit 0
        ;;
      p)
      ffmpeg -hide_banner -i "$3" -i "$2" -c:v prores -filter_complex "$(filter_complex "${@:4}")" -map '[v]' -f matroska - | ffplay -
      printf "\n\n*******START FFPLAY COMMANDS*******\n" >&2
      printf "ffmpeg -hide_banner -stats -i '$3' -i '$2' -c:v prores -filter_complex '$(filter_complex ${@:4})' -map '[v]' -f matroska - | ffplay - \n" >&2
      printf "********END FFPLAY COMMANDS********\n\n " >&2
        ;;
      s)
        ffmpeg -hide_banner -i "$3" -i "$2" -c:v prores -profile:v 3 -filter_complex "$(filter_complex "${@:4}")" -map '[v]' "${2%%.*}_blend.mov"
        printf "\n\n*******START FFMPEG COMMANDS*******\n" >&2
        printf "ffmpeg -hide_banner -i '$3' -i '$2' -c:v prores -filter_complex '$(filter_complex ${@:4})' -map '[v]' ${2%%.*}_blend.mov \n" >&2
        printf "********END FFMPEG COMMANDS********\n\n " >&2
        ;;
      *) echo "bad option -${OPTARG}" ; _usage ; exit 1 ;
    esac
  done
