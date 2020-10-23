#!/usr/bin/env bash

# creates audio visualization overlay by blending video and audio using dispalce and showcqt

# Parameters:
# $1: Input File 1, audio
# $2: Input File 2, video
# $3: Blend Mode

# need to rework this to match and convert mp4 sample to mov...
pref="`basename $0 .sh`"
bgmov="liquidloop.mp4"
sound="ocean.mp3"

ffmpeg -y \
-i "${sound}" \
-i "${bgmov}" \
-filter_complex "
color=0x808080:s=720x480,format=rgb24,loop=-1:size=2[base];
[0:a]
showcqt=s=720x480:basefreq=73.41:endfreq=1567.98
,format=rgb24
,geq='p(X,363)'
,setsar=1,colorkey=black:similarity=0.1[vcqt];
[base][vcqt]overlay,split[vcqt1][vcqt2];

[1:v]scale=720x480,format=rgb24,setsar=1[bgv];

[bgv][vcqt1][vcqt2]displace=edge=blank,format=yuv420p[v]
" -map '[v]' -map '0:a' -shortest "${pref}.mp4"
