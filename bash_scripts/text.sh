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
   TEXT The text to be written. Can be either text or a path to a text file.
      If text, No apostrophes. You MUST put quotation marks around the text
      If text file make sure it's plain text
   TEXT_COLOR The color of the text (white, black, silver, grey, green, blue, yellow, red, purple, orange) [default: white]
   BACKGROUND_COLOR The color of the (white, black, silver, grey, green, blue, yellow, red, purple, orange) [default: black]
   TEXT_SIZE The size of the text. The higher the bigger
   SCROLL_DIRECTION The direction of the scroll. Accepts left, right, up, down, center. Center is no motion
   SCROLL_SPEED The direction of the scroll. The higher the faster

  Outcome
   Transcode the input file to ProRes422HQ and resize if requested.
   dependencies: ffmpeg 4.3 or later
EOF
}

text="${2:-Hello World}"            # Text to be written [default: Hello World]. Can accept file path to text file
textColor="${3:-FFFFFF}"            # The color of the text [default: FFFFFF]
bgrColor="${4:-000000}"             # The color of the background [default: 000000]
textSize="${5:-30}"                 # Size of the text. The higher the bigger [default: 30]
scrollDir="${6:-center}"            # Diection of scroll. accepts left, right, up, down, center. Center is no motion [default: Center]
scrollSpeed="${7:-80}"              # Speed of text scroll. The higher the faster [default: 80]

# Selects the TEXT Color
if [[ $3 =~ ^[0-9A-F]{6}$ ]]
 then
   textColor=$3
elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$3")  = "white" ]]
 then
   textColor="FFFFFF"
elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$3")  = "black" ]]
 then
   textColor="000000"
elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$3")  = "silver" ]]
 then
   textColor="C0C0C0"
elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$3")  = "grey" ]]
 then
   textColor="808080"
elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$3")  = "blue" ]]
 then
   textColor="0000FF"
elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$3")  = "green" ]]
 then
   textColor="00FF00"
elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$3")  = "red" ]]
 then
   textColor="FF0000"
elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$3")  = "purple" ]]
 then
   textColor="0000FF"
elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$3")  = "orange" ]]
 then
   textColor="ff9900"
elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$3")  = "yellow" ]]
 then
   textColor="FFFF00"
 fi

 # Selects the BACKGROUND Color
 if [[ $4 =~ ^[0-9A-F]{6}$ ]]
  then
    bgrColor=$4
elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$4")  = "white" ]]
  then
    bgrColor="FFFFFF"
elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$4")  = "black" ]]
  then
    bgrColor="000000"
elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$4")  = "silver" ]]
  then
    bgrColor="C0C0C0"
elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$4")  = "grey" ]]
  then
    bgrColor="808080"
elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$4")  = "blue" ]]
  then
    bgrColor="0000FF"
elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$3")  = "green" ]]
  then
    bgrColor="00FF00"
elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$4")  = "red" ]]
  then
    bgrColor="FF0000"
elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$4")  = "purple" ]]
  then
    bgrColor="0000FF"
elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$4")  = "orange" ]]
  then
    bgrColor="ff9900"
elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$4")  = "yellow" ]]
  then
    bgrColor="FFFF00"
  fi

if [[ $(tr "[:upper:]" "[:lower:]" <<<"$scrollDir")  == "left" ]]
   then
      posString="x=w-$scrollSpeed*t:y=(h-text_h)/2 "       #scrolls left
elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$scrollDir")  == "right" ]]
   then
      posString="x=$scrollSpeed*t-w:y=(h-text_h)/2 "       #scrolls right
elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$scrollDir")  == "up" ]]
  then
      posString="x=(w-text_w)/2:y=h-$scrollSpeed*t"        #scrolls up
elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$scrollDir")  == "down" ]]
   then
      posString="x=(w-text_w)/2:y=$scrollSpeed*t-h"        #scrolls down
elif [[ $(tr "[:upper:]" "[:lower:]" <<<"$scrollDir")  == "center" ]]
   then
      posString="x=(w-text_w)/2:y=(h-text_h)/2"    #no scroll, text is centered
else
      posString="x=(w-text_w)/2:y=(h-text_h)/2"    #no scroll, text is centered
fi

if [  -f  $text ]; then
    textFilter="textfile='${text}'"
else
    textFilter="text='${text}'"
fi



lavfiInput="color=size=640x480:duration=10:rate=25:color=$bgrColor"
vf="drawtext=fontfile=/path/to/helvitca.ttf:fontsize=$textSize:fontcolor=$textColor:$posString:$textFilter"

while getopts "hps" OPT ; do
    case "${OPT}" in
      h) _usage ; exit 0
        ;;
      p)
         ffplay -hide_banner -f lavfi -i "${lavfiInput}" -vf "${vf}"
         printf "\n\n*******START FFPLAY COMMANDS*******\n" >&2
         printf "ffplay -hide_banner -f lavfi -i "${lavfiInput}" -vf \"${vf}\" \n" >&2
         printf "********END FFPLAY COMMANDS********\n\n " >&2
         ;;
      s)
         ffmpeg -hide_banner -f lavfi -i "${lavfiInput}" -vf "${vf}" -c:v prores -profile:v 3 'text.mov'
         printf "\n\n*******START FFMPEG COMMANDS*******\n" >&2
         printf "ffmpeg -hide_banner -f lavfi -i "${lavfiInput}" -vf \"${vf}\" -c:v prores -profile:v 3 'text.mov' \n" >&2
         printf "********END FFMPEG COMMANDS********\n\n " >&2
         ;;
      *) echo "bad option -${OPTARG}" ; _usage ; exit 1 ;
    esac
  done
