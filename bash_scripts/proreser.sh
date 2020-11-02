#!/usr/bin/env bash

# Conforms any input file into a prores file with option to resize

# Parameters:
# $1: Input File
# $2: Output resolution (Optional)

_usage(){
cat <<EOF
$(basename "${0}")
  Usage
   $(basename "${0}") [OPTIONS] INPUT_FILE_1 OUTPUT_RESOLUTION
  Options
   -h  display this help
   -p  previews in FFplay
   -s  saves to file with FFmpeg

  Notes
  Parameters:
   INPUT_FILE_1 The file that will be converted
   OUTPUT_RESOLUTION The resolution of the output file, formated as WxH (ex: 640x480)

  Outcome
   Transcode the input file to ProRes422HQ and resize if requested.
   dependencies: ffmpeg 4.3 or later
EOF
}

  outResolution="${3:-none}"  #output resolution. It's "none" if not defined

  # Build filter string
  if [ "$outResolution" == none ]; then
    conversionString=" -c:v prores -profile:v 3 -an "
  else
   if [[ "$outResolution" =~ [0-9]{3}[x][0-9]{3} ]]; then
      conversionString=" -c:v prores -profile:v 3 -filter_complex scale=${outResolution/x/:} -an "
   elif [[ "$outResolution" =~ [0-9]{4}[x][0-9]{4} ]]; then
      conversionString=" -c:v prores -profile:v 3 -filter_complex scale=${outResolution/x/:} -an "
   elif [[ "$outResolution" =~ [0-9]{2}[x][0-9]{2} ]]; then
      conversionString=" -c:v prores -profile:v 3 -filter_complex scale=${outResolution/x/:} -an "
   elif [[ "$outResolution" =~ [0-9]{4}[x][0-9]{3} ]]; then
      conversionString=" -c:v prores -profile:v 3 -filter_complex scale=${outResolution/x/:} -an "
   elif [[ "$outResolution" =~ [0-9]{3}[x][0-9]{4} ]]; then
      conversionString=" -c:v prores -profile:v 3 -filter_complex scale=${outResolution/x/:} -an "
   elif [[ "$outResolution" =~ [0-9]{3}[x][0-9]{2} ]]; then
      conversionString=" -c:v prores -profile:v 3 -filter_complex scale=${outResolution/x/:} -an "
   elif [[ "$outResolution" =~ [0-9]{2}[x][0-9]{3} ]]; then
      conversionString=" -c:v prores -profile:v 3 -filter_complex scale=${outResolution/x/:} -an "
   else
      printf "ERROR: Frame Size must be formated as WIDTHxHEIGHT\n" >&2
      exit
   fi
  fi

# Alter/replace FFmpeg command to desired specification

while getopts "hps" OPT ; do
    case "${OPT}" in
      h) _usage ; exit 0
        ;;
      p)
         ffmpeg -hide_banner -i "${2}" $conversionString -f matroska - | ffplay -
         printf "\n\n*******START FFPLAY COMMANDS*******\n" >&2
         printf "ffmpeg -hide_banner -i '$2' $conversionString -f matroska - | ffplay - \n" >&2
         printf "********END FFPLAY COMMANDS********\n\n " >&2
         ;;
      s)
         ffmpeg -hide_banner -i "${2}" $conversionString "${2%.*}_prores.mov"
         printf "\n\n*******START FFMPEG COMMANDS*******\n" >&2
         printf "ffmpeg -hide_banner -i '$2' $conversionString '${2%.*}_prores.mov' \n" >&2
         printf "********END FFMPEG COMMANDS********\n\n " >&2
         ;;
      *) echo "bad option -${OPTARG}" ; _usage ; exit 1 ;
    esac
  done
