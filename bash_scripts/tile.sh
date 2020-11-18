#!/usr/bin/env bash

# tiles the input file, similar to QCTools Film Strip effect

# Parameters:
# $1: Input File
# $2: Tile Columns
# $3: Tile Rows
# $4: Output resolution


_usage(){
cat <<EOF
$(basename "${0}")
  Usage
   $(basename "${0}") [OPTIONS] INPUT_FILE_1 COLUMNS ROWS OUTPUT_RESOLUTION
  Options
   -h  display this help
   -p  previews in FFplay
   -s  saves to file with FFmpeg

  Notes
  Parameters:
  INPUT_FILE_1 Input File
  COLUMNS how many columns will be in the output tile (MUST BE A MULTIPLE OF 2)
  ROWS how many Rows will be in the output tile (MUST BE A MULTIPLE OF 2)
  OUTPUT_RESOLUTION conforms the output to the defined resolution, must use format WxH

  Outcome
   Tiles the input file, similar to QCTools Film Strip effect
   dependencies: ffmpeg 4.3 or later
EOF
}

  width="${3:-4}"    # width - default vaue is 4
  height="${4:-4}"    # height - default value is 4
  outResolution="${5:-none}"  #output resolution. It's "none" if not defined

  # Build filter string
  if [ "$outResolution" == none ]; then
    filter_complex="scale=iw/${width}:ih/${height}:force_original_aspect_ratio=decrease,tile=${width}x${height}:overlap=${width}*${height}-1:init_padding=${width}*${height}-1"
  else
   if [[ "$outResolution" =~ [0-9]{3}[x][0-9]{3} ]]; then
      filter_complex="scale=iw/${width}:ih/${height}:force_original_aspect_ratio=decrease,tile=${width}x${height}:overlap=${width}*${height}-1:init_padding=${width}*${height}-1,scale=${outResolution/x/:}"
   elif [[ "$outResolution" =~ [0-9]{4}[x][0-9]{4} ]]; then
      filter_complex="scale=iw/${width}:ih/${height}:force_original_aspect_ratio=decrease,tile=${width}x${height}:overlap=${width}*${height}-1:init_padding=${width}*${height}-1,scale=${outResolution/x/:}"
   elif [[ "$outResolution" =~ [0-9]{2}[x][0-9]{2} ]]; then
      filter_complex="scale=iw/${width}:ih/${height}:force_original_aspect_ratio=decrease,tile=${width}x${height}:overlap=${width}*${height}-1:init_padding=${width}*${height}-1,scale=${outResolution/x/:}"
   elif [[ "$outResolution" =~ [0-9]{4}[x][0-9]{3} ]]; then
      filter_complex="scale=iw/${width}:ih/${height}:force_original_aspect_ratio=decrease,tile=${width}x${height}:overlap=${width}*${height}-1:init_padding=${width}*${height}-1,scale=${outResolution/x/:}"
   elif [[ "$outResolution" =~ [0-9]{3}[x][0-9]{4} ]]; then
      filter_complex="scale=iw/${width}:ih/${height}:force_original_aspect_ratio=decrease,tile=${width}x${height}:overlap=${width}*${height}-1:init_padding=${width}*${height}-1,scale=${outResolution/x/:}"
   elif [[ "$outResolution" =~ [0-9]{3}[x][0-9]{2} ]]; then
      filter_complex="scale=iw/${width}:ih/${height}:force_original_aspect_ratio=decrease,tile=${width}x${height}:overlap=${width}*${height}-1:init_padding=${width}*${height}-1,scale=${outResolution/x/:}"
   elif [[ "$outResolution" =~ [0-9]{2}[x][0-9]{3} ]]; then
      filter_complex="scale=iw/${width}:ih/${height}:force_original_aspect_ratio=decrease,tile=${width}x${height}:overlap=${width}*${height}-1:init_padding=${width}*${height}-1,scale=${outResolution/x/:}"
   else
      printf "ERROR: Frame Size must be formated as WIDTHxHEIGHT\n" >&2
      exit
   fi
  fi

# Alter/replace FFmpeg command to desired specification

while getopts ":hps" OPT ; do
    case "${OPT}" in
      h) _usage ; exit 0 ;;
      p) ffmpeg -hide_banner -i "${2}" -c:v prores -profile:v 3 -vf $filter_complex -f matroska - | ffplay -
         printf "\n\n*******START FFPLAY COMMANDS*******\n" >&2
         printf "ffmpeg -hide_banner -i '$2' -c:v prores -profile:v 3 -vf $filter_complex -f matroska - | ffplay - \n" >&2
         printf "********END FFPLAY COMMANDS********\n\n" >&2
         ;;
      s) ffmpeg -hide_banner -i "${2}" -c:v prores -profile:v 3 -vf $filter_complex "${2%.*}_tile${3}.mov"
         printf "\n\n*******START FFMPEG COMMANDS*******\n" >&2
         printf "ffmpeg -hide_banner -i '$2' -c:v prores -profile:v 3 -vf $filter_complex '${2%.*}_tile${3}.mov' \n" >&2
         printf "********END FFMPEG COMMANDS********\n\n" >&2
         ;;
      *) echo "Error: bad option -${OPTARG}" ; _usage ; exit 1 ;;
    esac
done
