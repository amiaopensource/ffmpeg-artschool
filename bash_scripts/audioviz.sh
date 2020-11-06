#!/usr/bin/env bash

# creates audio visualization overlay by blending video and audio using displace and showcqt

# Parameters:
# $1: Input File 1, audio
# $2: Input File 2, video

_usage(){
cat <<EOF
$(basename "${0}")
  Usage
   $(basename "${0}") [OPTIONS] AUDIO_FILE VIDEO_FILE
  Options
   -h  display this help
   -p  previews in FFplay
   -s  saves to file with FFmpeg

  Notes
  Audio file must be first argument, video file must be second arguement. Audio file and video file must have equal durations.

  Outcome
   Creates audio visualization overlay by blending video and audio using displace and showcqt
   dependencies: ffmpeg 4.3 or later
EOF
}

function filter_complex()
{

   filterString="\
   color=0x808080:s=720x480,format=rgb24,loop=-1:size=2[base];\
   [0:a]showcqt=s=720x480:basefreq=73.41:endfreq=1567.98,format=rgb24,geq='p(X,363)',setsar=1,colorkey=black:similarity=0.1[vcqt];\
   [base][vcqt]overlay,split[vcqt1][vcqt2];\
   [1:v]scale=720x480,format=rgb24,setsar=1[bgv];\
   [bgv][vcqt1][vcqt2]displace=edge=blank,format=yuv420p10le[v]"

   # Return full filter string, with necessary prefix and suffix filterchains
   printf '%s%s%s' $filterString

}


while getopts "hps" OPT ; do
    case "${OPT}" in
      h) _usage ; exit 0
        ;;
      p)
         printf "\n\n*******START FFPLAY COMMANDS*******\n" >&2
         printf "ffmpeg -hide_banner -i '$2' -i '$3' -c:v prores -profile:v 3 -filter_complex $(filter_complex) -map '[v]' -map '0:a' -shortest -f matroska - | ffplay - \n" >&2
         printf "********END FFPLAY COMMANDS********\n\n " >&2
         ffmpeg -hide_banner -i "${2}" -i "${3}" -c:v prores -profile:v 3 -filter_complex $(filter_complex) -map '[v]' -map '0:a' -shortest -f matroska - | ffplay -
         ;;
      s)
         printf "\n\n*******START FFMPEG COMMANDS*******\n" >&2
         printf "ffmpeg -hide_banner -i '$2' -i '$3' -c:v prores -profile:v 3 -filter_complex $(filter_complex) -map '[v]' -map '0:a' -shortest '${2%.*}_audioviz.mov'" >&2
         printf "********END FFMPEG COMMANDS********\n\n " >&2
         ffmpeg -hide_banner -y -i "${2}" -i "${3}" -c:v prores -profile:v 3 -filter_complex $(filter_complex) -map '[v]' -map '0:a' -shortest "${2%.*}_audioviz.mov"
         ;;
      *) echo "bad option -${OPTARG}" ; _usage ; exit 1 ;
    esac
  done
