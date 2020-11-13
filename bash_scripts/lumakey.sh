#!/usr/bin/env bash

# Combine two files using a lumakey effect

# Parameters:
# $1: File 1 (the overaly file, or the file that will be keyed)
# $2: File 2 (the background file)
# $3: Threshold value [default: 0]. 0 will key out black, 1 will key out white
# $4: Tolerance value [default 0.1]. If threshold is 0, then use a low number like 0.1 to key out darks. If threshold is 1, use a high number like 0.7 to key out whites
# $5: Softness value [default: 0.2]. this softens the key. 0 has sharp edges, 1 is totally soft, however it's not advisable to go above 0.4

_usage(){
cat <<EOF
$(basename "${0}")
  Usage
   $(basename "${0}") [OPTIONS] INPUT_FILE_1 INPUT_FILE_2 THRESHOLD TOLERANCE SOFTNESS
  Options
   -h  display this help
   -p  previews in FFplay
   -s  saves to file with FFmpeg

  Notes
  Parameters:
   INPUT_FILE_1 The file that will be keyed
   INPUT_FILE_2 The background file
   THRESHOLD [default: 0]. 0 will key out black, 1 will key out white
   TOLERANCE [default 0.1]. If threshold is 0, then use a low number like 0.1 to key out darks. If threshold is 1, use a high number like 0.7 to key out whites
   SOFTNESS [default: 0.2]. this softens the key. 0 has sharp edges, 1 is totally soft, however it's not advisable to go above 0.4

  Outcome
   Performs a lumakey, which removes any pixels under a certain luma value.
   dependencies: ffmpeg 4.3 or later
EOF
}

thresh="${4:-0}"  # Threshold value [default: 0]
tol="${5:-0.1}"   # Tolerance value [default 0.1]
soft="${6:-0.2}"  # Softness value [default: 0.2]

# Build filter string
filter_complex="[0:v][1:v]scale2ref[v0][v1];[v1]lumakey=threshold=$thresh:tolerance=$tol:softness=$soft[v1];[v0][v1]overlay,format=yuv422p10le[v]"
filter_complex_display="'[0:v][1:v]scale2ref[v0][v1];[v1]lumakey=threshold=$thresh:tolerance=$tol:softness=$soft[v1];[v0][v1]overlay,format=yuv422p10le[v]'"

while getopts ":hps" OPT ; do
    case "${OPT}" in
      h) _usage ; exit 0 ;;
      p) ffmpeg -hide_banner -i "${3}" -i "${2}" -c:v prores -profile:v 3 -filter_complex $filter_complex -map '[v]' -f matroska - | ffplay -
         printf "\n\n*******START FFPLAY COMMANDS*******\n" >&2
         printf "ffmpeg -hide_banner -i '$3' -i '$2' -c:v prores -profile:v 3 -filter_complex $filter_complex_display -map '[v]' -f matroska - | ffplay - \n" >&2
         printf "********END FFPLAY COMMANDS********\n\n" >&2
         ;;
      s) ffmpeg -hide_banner -i "${3}" -i "${2}" -c:v prores -profile:v 3 -filter_complex $filter_complex -map '[v]' "${2%.*}_lumakey.mov"
         printf "\n\n*******START FFMPEG COMMANDS*******\n" >&2
         printf "ffmpeg -hide_banner -i '$3' -i '$2' -c:v prores -profile:v 3 -filter_complex $filter_complex_display -map '[v]' '${2%.*}_lumakey.mov' \n" >&2
         printf "********END FFMPEG COMMANDS********\n\n" >&2
         ;;
      *) echo "Error: bad option -${OPTARG}" ; _usage ; exit 1 ;;
    esac
done
