#!/usr/bin/env bash

# Corrupts a file using Bitstream Filter Noise

# Parameters:
# $1: File 1 (the overaly file, or the file that will be keyed)
# $2: Corruption Amount [default: 0.1]. 0 is no error and 1 is all error. Anything abot 0.5 will likely not play
# $3: Keep temp file. The temp file is really finnicky, you only wanna keep it if you're ready for how wonky it can be!

_usage(){
cat <<EOF
$(basename "${0}")
  Usage
   $(basename "${0}") [OPTIONS] INPUT_FILE CORRUPTION_AMOUNT KEEP_TEMP_FILE
  Options
   -h  display this help
   -p  previews in FFplay
   -s  saves to file with FFmpeg

  Notes
  Corruption Amount [default: 0.1] 0 is no error and 1 is all error. Anything about 0.5 will likely not play
  Keep temp file: Boolean. Default is 0 (false), use 1 to keep the file but it will probably by wonky

  Outcome
   Corrupts a file using Bitstream Filter Noise
   dependencies: ffmpeg 4.3 or later
EOF
}


corruption="${3:-0.1}"    # Corruption Ammount [default: 0.1].
keepTemp="${4:-0}"    # Whether to keep the temp file, boolean [default: 0]


while getopts ":hps" OPT ; do
    case "${OPT}" in
      h) _usage ; exit 0 ;;
      p) ffmpeg -hide_banner -i "${2}" -c copy -bsf noise=$corruption -f matroska - | ffplay -
         printf "\n\n*******START FFPLAY COMMANDS*******\n" >&2
         printf "ffmpeg -hide_banner -i '$2' -c copy -bsf noise=$corruption -f matroska - | ffplay - \n" >&2
         printf "********END FFPLAY COMMANDS********\n\n" >&2
         ;;
      s) ffmpeg -hide_banner -i "${2}" -c copy -bsf noise=$corruption -y "${2%.*}_corruptor_temp.mov" && ffmpeg -i "${2%.*}_corruptor_temp.mov" -c:v prores -profile:v 3 -y "${2%.*}_corruptor.mov"
         printf "\n\n*******START FFMPEG COMMANDS*******\n" >&2
         printf "ffmpeg -hide_banner -i '$2' -c copy -bsf noise=$corruption -y '${2%.*}_corruptor_temp.mov' && ffmpeg -i '${2%.*}_corruptor_temp.mov' -c:v prores -profile:v 3 -y '${2%.*}_corruptor.mov' \n" >&2
         printf "********END FFMPEG COMMANDS********\n\n" >&2
         ;;
      *) echo "Error: bad option -${OPTARG}" ; _usage ; exit 1 ;;
    esac
done

if [[ "$keepTemp" != 1 ]]; then
   rm "${2%.*}_corruptor_temp.mov"
fi
