#!/usr/bin/env bash

# Repeats/Loops the input file as many times as requested

# Parameters:
# $1: Input File
# $2: Number of repeats (default is 2)

_usage(){
cat <<EOF
$(basename "${0}")
  Usage
   $(basename "${0}") [OPTIONS] INPUT_FILE_1 REPEATS
  Options
   -h  display this help
   -p  previews in FFplay
   -s  saves to file with FFmpeg

  Notes
  PLAY MODE IS DISABLED FOR THIS SCRIPT

  Parameters:
  INPUT_FILE_1 Input File
  REPEATS The number of times to repeat the file

  Outcome
   Repeats/Loops the input file as many times as requested
   dependencies: ffmpeg 4.3 or later
EOF
}

filename=$(basename -- "$2")
extension="${filename##*.}"
repeats="${3:-2}"    # Number of repeats - default vaue 2
firstchar=${2:0:1}
pwd=$(pwd)


if [[ $firstchar == "." ]]; then
   filepath="$pwd${2:1}"
else
   filepath=$2
fi


for i in $( seq 1 $repeats )
do
  if [[ $i = 1 ]]
  then
    echo file \'$filepath\' > /tmp/catlist.txt
  else
    echo file \'$filepath\' >> /tmp/catlist.txt
  fi
done

while getopts "hs" OPT ; do
    case "${OPT}" in
      h) _usage ; exit 0
        ;;
      s)
         ffmpeg -hide_banner -f concat -safe 0 -i /tmp/catlist.txt -c copy  "${2%.*}_looped_x${repeats}.${extension}"
         printf "\n\n*******START FFMPEG COMMANDS*******\n" >&2
         printf "ffmpeg -hide_banner -f concat -safe 0 -i /tmp/catlist.txt -c copy '${2%.*}_looped_x${repeats}.${extension}' \n" >&2
         printf "********END FFMPEG COMMANDS********\n\n " >&2
         ;;
      *) echo "bad option -${OPTARG}" ; _usage ; exit 1 ;
    esac
  done
