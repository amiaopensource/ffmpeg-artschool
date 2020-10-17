#!/usr/bin/env bash

# Repeats/Loops the input file as many times as requested

# Parameters:
# $1: Input File
# $2: Number of repeats (default is 2)

filename=$(basename -- "$1")
extension="${filename##*.}"

repeats="${2:-2}"    # Number of repeats - default vaue 2

for i in $( seq 1 $repeats )
do
  if [[ $i = 1 ]]
  then
    echo file \'$1\' > /tmp/catlist.txt
  else
    echo file \'$1\' >> /tmp/catlist.txt
  fi
done

ffmpeg -f concat -safe 0 -i /tmp/catlist.txt -c copy "${1%%.*}_looped_x${2}.${extension}"
