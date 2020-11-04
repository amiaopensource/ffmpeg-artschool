---
title: Scripts
layout: default
nav_order: 4
---

# Instructions for Bash/FFmpeg Scripts
{: .no_toc }

<details open markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }

1. TOC
{:toc}
</details>

## General Usage (and -h for help)
Nearly all of the scripts offer users two main paths: previewing the manipulated video with FFplay, or saving directly to a file with FFmpeg proper. Note: due to the taxing nature of some of these visualizations, your computer may not be able to preview with FFplay in a completely seamless fashion (prepare for the possibility of laggy playback).

But fear not: you should be able to at least get a sense of how your art will look, and these delays will not carry over into your resulting files.

All scripts also come equipped with built-in help instructions, which can be pulled up with a `-h` flag.

For example, running the following:

```
./bitplane.sh -h
```
Will spit out these helpful hints:

```
Usage
 bitplane.sh [OPTIONS] INPUT_FILE Y_BITPLANE U_BITPLANE V_BITPLANE
Options
 -h  display this help
 -p  previews in FFplay
 -s  saves to file with FFmpeg

Notes

Outcome
 Manipulate Y, U, and V bitplanes to make colorful creations
 dependencies: ffmpeg 4.3 or later
```

## Preview (-p) or Save (-s)

One of the operating assumptions of FFmpeg Art School is that you'll want to try out a whole host of possibilities before settling on the look of your final artwork. To help you in this process of playing around, you can preview by using the `-p` flag. For example:

```
./lagfun.sh -p ./sample_video_files/retrodancers.mov
```
If you're satisfied with the echoey look of these Retro Dancers, you can re-run the previous command and simply swap the `-p` for `-s` to call FFmpeg and tell it to create and save the file.

Note: when "saving" files, the resulting file will be placed in the same directory as the file you're manipulating, with a helpful filename suffix that should call your attention. In the above case, the resulting file would be called `retrodancers_lagfun.mov` and it would live in the same `sample_video_files` directory as the original.

For consistency and ease-of-use, all of the FFmpeg Art School scripts currently transcode your input file to Prores HQ 422, wrapped in Quicktime (.mov). But feel free to adapt these to your wants or needs!

## audioviz.sh

## bitplane.sh

## bitplaneslices.sh

## blend.sh

## chromakey.sh
Based off the QCTools filter "Filmstrip". Tiles the input file, rows and columns can be defined

Input 1: The video file that contains the "green screen" or color to be keyed out

Input 2: The video file that will appear behind the keyed video

Input 3 (optional): The color to be keyed. Any hex color code can be entered, as well as the following colors: green, blue, red, purple, orange, and yellow. The default value is green or 00FF00

Input 4 (optional): The similarity level. Default value is 0.6 The closer to 1 the more will be keyed out.

Input 5 (optional): The blending level. Default value is 0.1

## colorizer.sh

## corruptor.sh

## echo.sh

## gif.sh

## lagfun.sh

## life.sh

## lumakey.sh

## procamp.sh

## proreser.sh

## pseudocolor.sh

## rainbow-trail.sh

## repeat.sh
Repeats the input file an arbitrary number of times

Input 1: The video file to be repeated

Input 2 (optional): The number of times to repeat the file. If nothing is entered this will default to 2

## reverse.sh
Reverses the input file

Input 1: The video file to be reversed

## rotate.sh

## tblend_glitch.sh

## tblend.sh

## text.sh

## tile.sh
Based off the QCTools filter "Filmstrip". Tiles the input file, rows and columns can be defined

Input 1: The video file to be tiled

Input 2 (optional): Number of columns (width). Default is 2

Input 3 (optional): Number of columns (height). Default is 2

Input 4 (optional): Output frame size. This will squeeze the output into a specific size. Must be in format "WIDTHxHEIGHT" to work

## trim.sh

## zoomflipscroller.sh
