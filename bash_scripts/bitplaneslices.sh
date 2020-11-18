#!/usr/bin/env bash

# Divide your video into 10 Y channel bitplane slices, taken from QCTools

_usage(){
cat <<EOF
$(basename "${0}")
  Usage
   $(basename "${0}") [OPTIONS] MOVIE_FILE.mov
  Options
   -h  display this help
   -p  previews in FFplay
   -s  saves to file with FFmpeg
  Outcome
   will play or save file with 10 bitplane stacked slices
   dependencies: ffmpeg
EOF
}
vf=$vf"format=yuv420p10le|yuv422p10le|yuv444p10le|yuv440p10le,split=10[b0][b1][b2][b3][b4][b5][b6][b7][b8][b9];[b0]crop=iw/10:ih:(iw/10)*0:0,lutyuv=y=512:u=512:v=512:y=bitand(val\,pow(2\,10-1))*pow(2\,1)[b0c];[b1]crop=iw/10:ih:(iw/10)*1:0,lutyuv=y=512:u=512:v=512:y=bitand(val\,pow(2\,10-2))*pow(2\,2)[b1c];[b2]crop=iw/10:ih:(iw/10)*2:0,lutyuv=y=512:u=512:v=512:y=bitand(val\,pow(2\,10-3))*pow(2\,3)[b2c];[b3]crop=iw/10:ih:(iw/10)*3:0,lutyuv=y=512:u=512:v=512:y=bitand(val\,pow(2\,10-4))*pow(2\,4)[b3c];[b4]crop=iw/10:ih:(iw/10)*4:0,lutyuv=y=512:u=512:v=512:y=bitand(val\,pow(2\,10-5))*pow(2\,5)[b4c];[b5]crop=iw/10:ih:(iw/10)*5:0,lutyuv=y=512:u=512:v=512:y=bitand(val\,pow(2\,10-6))*pow(2\,6)[b5c];[b6]crop=iw/10:ih:(iw/10)*6:0,lutyuv=y=512:u=512:v=512:y=bitand(val\,pow(2\,10-7))*pow(2\,7)[b6c];[b7]crop=iw/10:ih:(iw/10)*7:0,lutyuv=y=512:u=512:v=512:y=bitand(val\,pow(2\,10-8))*pow(2\,8)[b7c]; [b8]crop=iw/10:ih:(iw/10)*8:0,lutyuv=y=512:u=512:v=512:y=bitand(val\,pow(2\,10-9))*pow(2\,9)[b8c];[b9]crop=iw/10:ih:(iw/10)*9:0,lutyuv=y=512:u=512:v=512:y=bitand(val\,pow(2\,10-10))*pow(2\,10)[b9c]; [b0c][b1c][b2c][b3c][b4c][b5c][b6c][b7c][b8c][b9c]hstack=10,format=yuv422p10le,drawgrid=w=iw/10:h=ih:t=2:c=cyan@1"

while getopts ":hps" OPT ; do
    case "${OPT}" in
      h) _usage ; exit 0 ;;
      p) ffplay "$2" -vf "$vf"
         printf "\n\n*******START FFPLAY COMMANDS*******\n" >&2
         printf "ffplay -i '$2' -vf '$vf' \n" >&2
         printf "********END FFPLAY COMMANDS********\n\n" >&2
         ;;
      s) ffmpeg -hide_banner -i "$2" -c:v prores -profile:v 3 -vf "$vf" "${2}_bitslices.mov"
         printf "\n\n*******START FFPLAY COMMANDS*******\n" >&2
         printf "ffmpeg -hide_banner -stats -i '$2' -c:v prores -profile:v 3 -vf '$vf' '${2}_bitslices.mov' \n" >&2
         printf "********END FFPLAY COMMANDS********\n\n" >&2
         ;;
      *) echo "Error: bad option -${OPTARG}" ; _usage ; exit 1 ;;
    esac
done
