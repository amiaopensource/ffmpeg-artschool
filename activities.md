---
title: Activities and Exercises
layout: default
nav_order: 5
---

# Activities

This document will describe how to run certain scripts for artistic effects!

## Playtime 1: Running Bash and FFmpeg

Before we get start with this section, make sure that your terminal window is in the root level of the `ffmpeg-artschool` directory. you do do this by typing `cd` then dragging in the ffmpeg-artschool folder.

Also, for these activities we're going to use ffplay to stream the videos we're creating, rather than save them. In order to do this we're using the following format:

```
ffmpeg -i [InputFile.mov] -c:v prores -filter_complex [Filter String] -f matroska - | ffplay -
```

The last portion that says `-f matroska - | ffplay - ` is telling ffmpeg to output what it's processing as a matroska file, and then telling ffplay to playback whatever it coming out of ffmpeg as it comes out. This means that if your computer can't handle the processing it might be a bit slow to play back the file. This is why most of our sample files are at 640x480, which is easier for a CPU to handle than a large HD or 2K file.

### Normalizing your sourve sample_video_files
All of the video files we provide have been normalized to ProRes. However, if you have your own sample files that you want to use, it's best to make sure it's transcoded to ProRes and resized to SD before working with it. We've created a simple bash script that can help you with this. Here's how ton run the script:
```
./bash_scripts/proreser.sh -s [/path/to/input/file.mov] 640x480
```
By default the `proreser.sh` script will convert your file to ProRes. By adding the `-s` flag we're telling the script to save the output file. By adding `640x480` to the end of the command we're telling the script to resize the file to 640 pixels by 480 pixels.

## Playtime 2: Chromakey and Echo

### Chromakey
The Chromakey effect is used to remove any pixel that is a specific color from a video and turn it transparent. Once the color has been turned transparent the video can be overlayed over another video file and the second file will appear "behind" the removed pixels. The bash script chromakey.sh takes care of the chromakey AND the overlay at once. Let's take it step by step.

1. Find any file in the `sample_video_files` directory that has `greenscreen_` in the name. We'll use `greenscreen_skulls` for the main file. You can use any other video file for the second. We'll use `Cat01.mov` for this example
2. We'll see what it looks like to overlay two files without Chromakey
```
ffmpeg -i ./sample_video_files/Cat01.mov -i ./sample_video_files/Skull01.mov -c:v prores -filter_complex '[0:v][1:v]overlay,format=yuv422p10le[v]' -map '[v]' -f matroska - | ffplay -
```
3. Well that wasn't very fun! All you'll see is the original greenscreen video. This is just to prove that you can't overlay files with out the chromakey filter.
4. Now we'll see what it looks like to remove the green in the main file with with the following command
```
ffmpeg -i ./sample_video_files/Skull01.mov -c:v prores -filter_complex 'chromakey=0x00FF00:0.2:0.1' -f matroska - | ffplay -
```
5. You should see that the green has all been removed. The black that's leftover is a special black. It's not actually a black pixel, but an absence of any video data at all! Now see what it looks like when we perform the overlay after chromakeying with the following command:
```
ffmpeg -i ./sample_video_files/Cat01.mov -i ./sample_video_files/Skull01.mov -c:v prores -filter_complex '[1:v]chromakey=0x00FF00:0.2:0.1[1v];[0:v][1v]overlay,format=yuv422p10le[v]' -map '[v]' -f matroska - | ffplay -
```
6. Congrats! You've now chromakeyed a file and overlayed over another file! The script `chromakey.sh` will do this for you automatically, with many extra options. It will also automatically resize the files so that their dimensions match.

### Echo
This echo effect is based off [a classic tape echo effect](https://www.youtube.com/watch?v=y3Whi-g-0A0) for audio. It adds decaying repetitions to an input file. When using this effect make sure to use an effects with big sweeping motions (like dancers!) for the best results. For this example we'll use `retrodancers.mov`

1. Run the default echo effects on RetroDancer.mov with the following command
```
./bash_scripts/echo.sh -p ./sample_video_files/retrodancers.mov
```
2. For the sake of clarity, this is the same as running this command, which shows all the default arguments used (0.2 second echo, Level 2 trails, Blend mode 1)
```
./bash_scripts/echo.sh -p ./sample_video_files/retrodancers.mov 0.2 2 1
```
3. Now let's adjust the time of the echo. We can set it to a much shorter time with more trails for a more washy effect:
```
./bash_scripts/echo.sh -p ./sample_video_files/retrodancers.mov 0.05 5 1
```
4. The fun really starts when we try different blend modes. Let's do the same short delay time with heavy trails, but using the Pheonix blend mode, which is mode 3
```
./bash_scripts/echo.sh -p ./sample_video_files/retrodancers.mov 0.05 5 3
```
5. We can make it even crazier with the XOR blend mode: 5
```
./bash_scripts/echo.sh -p ./sample_video_files/retrodancers.mov 0.05 5 7
```
6. XOR mode is wild! But we can actually make it a bit more interesting by really slowing down the delay time and reducing the trails. Let's try that
```
./bash_scripts/echo.sh -p ./sample_video_files/retrodancers.mov 0.5 3 7
```
7. Now you've seen some of what echo can do, try experimenting!

## Playtime 3: Bitplane, Blend, Zoom/Scroll

## Playtime 4: Pseudocolor, Showcqt
