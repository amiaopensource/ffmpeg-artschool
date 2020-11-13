#!/usr/bin/env bash

# Simulates the game of life


_usage(){
cat <<EOF
$(basename "${0}")
  Usage
   $(basename "${0}") [OPTIONS] GAME_SIZE LIFE_COLOR DEATH_COLOR RATE RATIO
  Options
   -h  display this help
   -p  previews in FFplay
   -s  saves to file with FFmpeg

  Notes
  GAME_SIZE: small, medium, or large. Default is medium
  LIFE_COLOR: blue, green red, purple or orange. default is yellow
  DEATH_COLOR: blue, green red, purple or orange. default is red
  RATE slow medium fast, default is random
  RATIO low medium high, default is random

  Outcome
   Simulates the game of life
   dependencies: ffmpeg 4.3 or later
EOF
}


#set size of game

if [[ $(tr "[:upper:]" "[:lower:]" <<<"$2")  = "small" ]]; then
   size="320x240"
elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$2")  = "medium" ]]; then
   size="640x480"
elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$2")  = "large" ]]; then
   size="1280x960"
else
   size="640x480"
fi

#set life colors
if [[ $(tr "[:upper:]" "[:lower:]" <<<"$3")  = "blue" ]]; then
   lifeColor="#0000FF"
elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$3")  = "green" ]]; then
   lifeColor="#00FF00"
elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$3")  = "red" ]]; then
   lifeColor="#C83232"
elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$3")  = "purple" ]]; then
    ifeColor="#0000FF"
elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$3")  = "orange" ]]; then
   lifeColor="#ff9900"
elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$3")  = "yellow" ]]; then
   lifeColor="#FFFF00"
else
   lifeColor="#FFFF00"
fi

#set death colors
if [[ $(tr "[:upper:]" "[:lower:]" <<<"$4")  = "blue" ]]; then
   deathColor="#0000FF"
elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$4")  = "green" ]]; then
   deathColor="#00FF00"
elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$4")  = "red" ]]; then
   deathColor="#C83232"
elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$4")  = "purple" ]]; then
   deathColor="#0000FF"
elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$4")  = "orange" ]]; then
   deathColor="#ff9900"
elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$4")  = "yellow" ]]; then
   deathColor="#FFFF00"
else
   deathColor="#C83232"
fi

#set rate

if [[ $(tr "[:upper:]" "[:lower:]" <<<"$5")  = "fast" ]]; then
   rate="100"
elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$5")  = "medium" ]]; then
   rate="60"
elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$5")  = "slow" ]]; then
   rate="20"
else
   low=20
   high=100
   rand1=$((low + RANDOM%(1+high-low)))
   rate="${5:-$rand1}"    # user selected or, if not, random default value bet 1-8
fi

#set ratio

if [[ $(tr "[:upper:]" "[:lower:]" <<<"$6")  = "low" ]]; then
   ratio="1"
elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$6")  = "medium" ]]; then
   ratio="5"
elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$6")  = "high" ]]; then
   ratio="8"
else
   low=1
   high=8
   rand2=$((low + RANDOM%(1+high-low)))
   ratio="${6:-$rand2}"    # user selected or, if not, random default value bet 1-8
fi

lifeString="life=s=$size:mold=10:r=$rate:ratio=0.$ratio:death_color=$deathColor:life_color=$lifeColor,scale=640:480:flags=16"


while getopts ":hps" OPT ; do
    case "${OPT}" in
      h) _usage ; exit 0 ;;
      p) ffplay -f lavfi ${lifeString}
         printf "\n\n*******START FFPLAY COMMANDS*******\n" >&2
         echo "Rate: "$rate
         echo "Ratio: 0."$ratio
         printf "ffplay -f lavfi ${lifeString}" >&2
         printf "\n********END FFPLAY COMMANDS********\n\n" >&2
         ;;
      s) ffmpeg -f lavfi -i ${lifeString},format=yuv422p10le -c:v prores -profile:v 3 -t 10 life.mov
         printf "\n\n*******START FFMPEG COMMANDS*******\n" >&2
         echo "Rate: "$rate
         echo "Ratio: 0."$ratio
         printf "ffmpeg -f lavfi -i ${lifeString},format=yuv422p10le -c:v prores -profile:v 3 -t 10 life.mov \n" >&2
         printf "\n********END FFMPEG COMMANDS********\n\n" >&2
         ;;
      *) echo "Error: bad option -${OPTARG}" ; _usage ; exit 1 ;;
    esac
done
