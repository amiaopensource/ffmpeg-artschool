#!/usr/bin/env bash

# Creates a mosiac of video files using the xstack filter

_usage(){
cat <<EOF
$(basename "${0}")
  Usage
   $(basename "${0}") [OPTIONS] INPUT_FILE_1 INPUT_FILE_2 INPUT_FILE_3 INPUT_FILE_N
  Options
   -h  display this help
   -p  previews in FFplay
   -s  saves to file with FFmpeg

  Notes
  INPUT_FILE_1
  INPUT_FILE_2

  Outcome
   Creates a mosiac of video files using the xstack filter
   The number of files MUST make a square. 4, 9, 16, or 25
   dependencies: ffmpeg 4.3 or later
EOF
}

numArgs=$#    # The number of arguments passed

if [[ $numArgs  == 5 ]]
  then
     outDim="2x2"
     inputStringPlay="-i '${2}' -i '${3}' -i '${4}' -i '${5}'"
     inputStringSave="-i "${2}" -i "${3}" -i "${4}" -i "${5}""
     filterString="[0:v]setpts=PTS-STARTPTS,scale=qvga[a0];\
      [1:v]setpts=PTS-STARTPTS,scale=qvga[a1];\
      [2:v]setpts=PTS-STARTPTS,scale=qvga[a2];\
      [3:v]setpts=PTS-STARTPTS,scale=qvga[a3];\
      [a0][a1][a2][a3]xstack=inputs=4:layout=0_0|0_h0|w0_0|w0_h0[out]"
elif [[ $numArgs  == 10 ]]
   then
      outDim="3x3"
      inputStringPlay="-i '${2}' -i '${3}' -i '${4}' -i '${5}' -i '${6}' -i '${7}' -i '${8}' -i '${9}' -i '${10}'"
      inputStringSave="-i "${2}" -i "${3}" -i "${4}" -i "${5}" -i "${6}" -i "${7}" -i "${8}" -i "${9}" -i "${10}""
      filterString="[0:v]setpts=PTS-STARTPTS,scale=qvga[a0];\
            [1:v]setpts=PTS-STARTPTS,scale=qvga[a1];\
            [2:v]setpts=PTS-STARTPTS,scale=qvga[a2];\
            [3:v]setpts=PTS-STARTPTS,scale=qvga[a3];\
            [4:v]setpts=PTS-STARTPTS,scale=qvga[a4];\
            [5:v]setpts=PTS-STARTPTS,scale=qvga[a5];\
            [6:v]setpts=PTS-STARTPTS,scale=qvga[a6];\
            [7:v]setpts=PTS-STARTPTS,scale=qvga[a7];\
            [8:v]setpts=PTS-STARTPTS,scale=qvga[a8];\
            [a0][a1][a2][a3][a4][a5][a6][a7][a8]xstack=inputs=9:layout=0_0|w0_0|w0+w1_0|0_h0|w0_h0|w0+w1_h0|0_h0+h1|w0_h0+h1|w0+w1_h0+h1[out]"
elif [[ $numArgs  == 17 ]]
   then
      outDim="4x4"
      inputStringPlay="-i '${2}' -i '${3}' -i '${4}' -i '${5}' -i '${6}' -i '${7}' -i '${8}' -i '${9}' -i '${10}' -i '${11}' -i '${12}' -i '${13}' -i '${14}' -i '${15}' -i '${16}' -i '${17}'"
      inputStringSave="-i "${2}" -i "${3}" -i "${4}" -i "${5}" -i "${6}" -i "${7}" -i "${8}" -i "${9}" -i "${10}" -i "${11}" -i "${12}" -i "${13}" -i "${14}" -i "${15}" -i "${16}" -i "${17}""
      filterString="[0:v]setpts=PTS-STARTPTS,scale=qqvga[a0];\
      [1:v]setpts=PTS-STARTPTS,scale=qqvga[a1];\
      [2:v]setpts=PTS-STARTPTS,scale=qqvga[a2];\
      [3:v]setpts=PTS-STARTPTS,scale=qqvga[a3];\
      [4:v]setpts=PTS-STARTPTS,scale=qqvga[a4];\
      [5:v]setpts=PTS-STARTPTS,scale=qqvga[a5];\
      [6:v]setpts=PTS-STARTPTS,scale=qqvga[a6];\
      [7:v]setpts=PTS-STARTPTS,scale=qqvga[a7];\
      [8:v]setpts=PTS-STARTPTS,scale=qqvga[a8];\
      [9:v]setpts=PTS-STARTPTS,scale=qqvga[a9];\
      [10:v]setpts=PTS-STARTPTS,scale=qqvga[a10];\
      [11:v]setpts=PTS-STARTPTS,scale=qqvga[a11];\
      [12:v]setpts=PTS-STARTPTS,scale=qqvga[a12];\
      [13:v]setpts=PTS-STARTPTS,scale=qqvga[a13];\
      [14:v]setpts=PTS-STARTPTS,scale=qqvga[a14];\
      [15:v]setpts=PTS-STARTPTS,scale=qqvga[a15];\
      [a0][a1][a2][a3][a4][a5][a6][a7][a8][a9][a10][a11][a12][a13][a14][a15]xstack=inputs=16:layout=0_0|w0_0|w0+w1_0|w0+w1+w2_0|0_h0|w0_h0|w0+w1_h0|w0+w1+w2_h0|0_h0+h1|w0_h0+h1|w0+w1_h0+h1|w0+w1+w2_h0+h1|0_h0+h1+h2|w0_h0+h1+h2|w0+w1_h0+h1+h2|w0+w1+w2_h0+h1+h2[out]"
elif [[ $numArgs  == 26 ]]
   then
      outDim="5x5"
      inputStringPlay="-i '${2}' -i '${3}' -i '${4}' -i '${5}' -i '${6}' -i '${7}' -i '${8}' -i '${9}' -i '${10}' -i '${11}' -i '${12}' -i '${13}' -i '${14}' -i '${15}' -i '${16}' -i '${17}' -i '${18}' -i '${19}' -i '${20}' -i '${21}' -i '${22}' -i '${23}' -i '${24}' -i '${25}' -i '${26}'"
      inputStringSave="-i "${2}" -i "${3}" -i "${4}" -i "${5}" -i "${6}" -i "${7}" -i "${8}" -i "${9}" -i "${10}" -i "${11}" -i "${12}" -i "${13}" -i "${14}" -i "${15}" -i "${16}" -i "${17}" -i "${18}" -i "${19}" -i "${20}" -i "${21}" -i "${22}" -i "${23}" -i "${24}" -i "${25}" -i "${26}""
      filterString="[0:v]setpts=PTS-STARTPTS,scale=qqvga[a0];\
      [1:v]setpts=PTS-STARTPTS,scale=qqvga[a1];\
      [2:v]setpts=PTS-STARTPTS,scale=qqvga[a2];\
      [3:v]setpts=PTS-STARTPTS,scale=qqvga[a3];\
      [4:v]setpts=PTS-STARTPTS,scale=qqvga[a4];\
      [5:v]setpts=PTS-STARTPTS,scale=qqvga[a5];\
      [6:v]setpts=PTS-STARTPTS,scale=qqvga[a6];\
      [7:v]setpts=PTS-STARTPTS,scale=qqvga[a7];\
      [8:v]setpts=PTS-STARTPTS,scale=qqvga[a8];\
      [9:v]setpts=PTS-STARTPTS,scale=qqvga[a9];\
      [10:v]setpts=PTS-STARTPTS,scale=qqvga[a10];\
      [11:v]setpts=PTS-STARTPTS,scale=qqvga[a11];\
      [12:v]setpts=PTS-STARTPTS,scale=qqvga[a12];\
      [13:v]setpts=PTS-STARTPTS,scale=qqvga[a13];\
      [14:v]setpts=PTS-STARTPTS,scale=qqvga[a14];\
      [15:v]setpts=PTS-STARTPTS,scale=qqvga[a15];\
      [16:v]setpts=PTS-STARTPTS,scale=qqvga[a16];\
      [17:v]setpts=PTS-STARTPTS,scale=qqvga[a17];\
      [18:v]setpts=PTS-STARTPTS,scale=qqvga[a18];\
      [19:v]setpts=PTS-STARTPTS,scale=qqvga[a19];\
      [20:v]setpts=PTS-STARTPTS,scale=qqvga[a20];\
      [21:v]setpts=PTS-STARTPTS,scale=qqvga[a21];\
      [22:v]setpts=PTS-STARTPTS,scale=qqvga[a22];\
      [23:v]setpts=PTS-STARTPTS,scale=qqvga[a23];\
      [24:v]setpts=PTS-STARTPTS,scale=qqvga[a24];\
      [a0][a1][a2][a3][a4][a5][a6][a7][a8][a9][a10][a11][a12][a13][a14][a15][a16][a17][a18][a19][a20][a21][a22][a23][a24]xstack=inputs=25:layout=0_0|w0_0|w0+w1_0|w0+w1+w2_0|w0+w1+w2+w3_0|0_h0|w0_h0|w0+w1_h0|w0+w1+w2_h0|w0+w1+w2+w3_h0|0_h0+h1|w0_h0+h1|w0+w1_h0+h1|w0+w1+w2_h0+h1|w0+w1+w2+w3_h0+h1|0_h0+h1+h2|w0_h0+h1+h2|w0+w1_h0+h1+h2|w0+w1+w2_h0+h1+h2|w0+w1+w2+w3_h0+h1+h2|0_h0+h1+h2+h3|w0_h0+h1+h2+h3|w0+w1_h0+h1+h2+h3|w0+w1+w2_h0+h1+h2+h3|w0+w1+w2+w3_h0+h1+h2+h3[out]"
elif [[ $numArgs  == 37 ]]
   then
      outDim="6x6"
      inputStringPlay="-i '${2}' -i '${3}' -i '${4}' -i '${5}' -i '${6}' -i '${7}' -i '${8}' -i '${9}' -i '${10}' -i '${11}' -i '${12}' -i '${13}' -i '${14}' -i '${15}' -i '${16}' -i '${17}' -i '${18}' -i '${19}' -i '${20}' -i '${21}' -i '${22}' -i '${23}' -i '${24}' -i '${25}' -i '${26}' -i '${27}' -i '${28}' -i '${29}' -i '${30}' -i '${31}' -i '${32}' -i '${33}' -i '${34}' -i '${35}' -i '${36}' -i '${37}'"
      inputStringSave="-i "${2}" -i "${3}" -i "${4}" -i "${5}" -i "${6}" -i "${7}" -i "${8}" -i "${9}" -i "${10}" -i "${11}" -i "${12}" -i "${13}" -i "${14}" -i "${15}" -i "${16}" -i "${17}" -i "${18}" -i "${19}" -i "${20}" -i "${21}" -i "${22}" -i "${23}" -i "${24}" -i "${25}" -i "${26}" -i "${27}" -i "${28}" -i "${29}" -i "${30}" -i "${31}" -i "${32}" -i "${33}" -i "${34}" -i "${35}" -i "${36}" -i "${37}""
      filterString="[0:v]setpts=PTS-STARTPTS,scale=qqvga[a0];\
      [1:v]setpts=PTS-STARTPTS,scale=qqvga[a1];\
      [2:v]setpts=PTS-STARTPTS,scale=qqvga[a2];\
      [3:v]setpts=PTS-STARTPTS,scale=qqvga[a3];\
      [4:v]setpts=PTS-STARTPTS,scale=qqvga[a4];\
      [5:v]setpts=PTS-STARTPTS,scale=qqvga[a5];\
      [6:v]setpts=PTS-STARTPTS,scale=qqvga[a6];\
      [7:v]setpts=PTS-STARTPTS,scale=qqvga[a7];\
      [8:v]setpts=PTS-STARTPTS,scale=qqvga[a8];\
      [9:v]setpts=PTS-STARTPTS,scale=qqvga[a9];\
      [10:v]setpts=PTS-STARTPTS,scale=qqvga[a10];\
      [11:v]setpts=PTS-STARTPTS,scale=qqvga[a11];\
      [12:v]setpts=PTS-STARTPTS,scale=qqvga[a12];\
      [13:v]setpts=PTS-STARTPTS,scale=qqvga[a13];\
      [14:v]setpts=PTS-STARTPTS,scale=qqvga[a14];\
      [15:v]setpts=PTS-STARTPTS,scale=qqvga[a15];\
      [16:v]setpts=PTS-STARTPTS,scale=qqvga[a16];\
      [17:v]setpts=PTS-STARTPTS,scale=qqvga[a17];\
      [18:v]setpts=PTS-STARTPTS,scale=qqvga[a18];\
      [19:v]setpts=PTS-STARTPTS,scale=qqvga[a19];\
      [20:v]setpts=PTS-STARTPTS,scale=qqvga[a20];\
      [21:v]setpts=PTS-STARTPTS,scale=qqvga[a21];\
      [22:v]setpts=PTS-STARTPTS,scale=qqvga[a22];\
      [23:v]setpts=PTS-STARTPTS,scale=qqvga[a23];\
      [24:v]setpts=PTS-STARTPTS,scale=qqvga[a24];\
      [25:v]setpts=PTS-STARTPTS,scale=qqvga[a25];\
      [26:v]setpts=PTS-STARTPTS,scale=qqvga[a26];\
      [27:v]setpts=PTS-STARTPTS,scale=qqvga[a27];\
      [28:v]setpts=PTS-STARTPTS,scale=qqvga[a28];\
      [29:v]setpts=PTS-STARTPTS,scale=qqvga[a29];\
      [30:v]setpts=PTS-STARTPTS,scale=qqvga[a30];\
      [31:v]setpts=PTS-STARTPTS,scale=qqvga[a31];\
      [32:v]setpts=PTS-STARTPTS,scale=qqvga[a32];\
      [33:v]setpts=PTS-STARTPTS,scale=qqvga[a33];\
      [34:v]setpts=PTS-STARTPTS,scale=qqvga[a34];\
      [35:v]setpts=PTS-STARTPTS,scale=qqvga[a35];\
      [a0][a1][a2][a3][a4][a5][a6][a7][a8][a9][a10][a11][a12][a13][a14][a15][a16][a17][a18][a19][a20][a21][a22][a23][a24][a25][a26][a27][a28][a29][a30][a31][a32][a33][a34][a35]xstack=inputs=36:layout=0_0|w0_0|w0+w1_0|w0+w1+w2_0|w0+w1+w2+w3_0|w0+w1+w2+w3+w4_0|0_h0|w0_h0|w0+w1_h0|w0+w1+w2_h0|w0+w1+w2+w3_h0|w0+w1+w2+w3+w4_h0|0_h0+h1|w0_h0+h1|w0+w1_h0+h1|w0+w1+w2_h0+h1|w0+w1+w2+w3_h0+h1|w0+w1+w2+w3+w4_h0+h1|0_h0+h1+h2|w0_h0+h1+h2|w0+w1_h0+h1+h2|w0+w1+w2_h0+h1+h2|w0+w1+w2+w3_h0+h1+h2|w0+w1+w2+w3+w4_h0+h1+h2|0_h0+h1+h2+h3|w0_h0+h1+h2+h3|w0+w1_h0+h1+h2+h3|w0+w1+w2_h0+h1+h2+h3|w0+w1+w2+w3_h0+h1+h2+h3|w0+w1+w2+w3+w4_h0+h1+h2+h3|0_h0+h1+h2+h3+h4|w0_h0+h1+h2+h3+h4|w0+w1_h0+h1+h2+h3+h4|w0+w1+w2_h0+h1+h2+h3+h4|w0+w1+w2+w3_h0+h1+h2+h3+h4|w0+w1+w2+w3+w4_h0+h1+h2+h3+h4[out]"
else
   printf "ERROR: The number of input files MUST make a square. 4, 9, 16, 25, or 36\n" >&2
   exit
fi

  # Build filter string


while getopts "hps" OPT ; do
    case "${OPT}" in
      h) _usage ; exit 0
        ;;
      p)
      ffmpeg -hide_banner ${inputStringSave} -c:v prores -profile:v 3 -filter_complex "${filterString}" -map [out] -f matroska - | ffplay -
      printf "\n\n*******START FFPLAY COMMANDS*******\n" >&2
      printf "ffmpeg -hide_banner ${inputStringPlay}  -c:v prores -profile:v 3 -filter_complex '${filterString}' -map [out] -f matroska - | ffplay - \n" >&2
      printf "********END FFPLAY COMMANDS********\n\n " >&2
        ;;
      s)
      ffmpeg -hide_banner ${inputStringSave} -c:v prores -profile:v 3 -filter_complex "${filterString}" -map [out] "${2%.*}_xstack_$outDim.mov"
      printf "\n\n*******START FFMPEG COMMANDS*******\n" >&2
      printf "ffmpeg -hide_banner ${inputStringPlay}  -c:v prores -profile:v 3 -filter_complex '${filterString}' -map [out] '${2%.*}_xstack_$outDim.mov' \n" >&2
      printf "********END FFMPEG COMMANDS********\n\n " >&2
        ;;
      *) echo "bad option -${OPTARG}" ; _usage ; exit 1 ;
    esac
  done
