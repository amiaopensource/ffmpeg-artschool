---
title: Scripts
layout: default
nav_order: 4
---

# Instructions for FFmpeg Scripts
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

MOST IMPORTANT: the `-p` or `-s` flags are required, so if you run the scripts without them, nothing will happen!

## Optional Parameters
Many—but not all—of the scripts allow for customization through the use of optional parameters (or positional arguments) passed by the user when executing a script. In almost all cases, we've written code that either defaults to pre-set options or makes random selections, but these variables can always be adjusted by the user as needed. And, most importantly, whether options are available for a script or not, they will be described in depth in the help documentation (run the script with a `-h` flag).

To take one example, the bitplane script, which manipulates the Y, U, and V planes of a video to make colorful creations, defaults to randomly chosen numbers between -1 and 10 for all three variables. But, if after running the script a number of times in preview mode, you're happy with the look of a particular combination, you can re-run the script in the following way to hard set those numbers:

```
./bitplane.sh -p ./sample_video_files/retrodancers.mov 3 4 1
```

<img src="{{ site.baseurl }}/images/retrodancers_bitplane.jpg" width="60%">


## audioviz
Creates an audio visualization overlay by blending two input files (one video, one audio) and using FFmpeg's [displace](https://ffmpeg.org/ffmpeg-filters.html#displace){:target="\_blank"} and [showcqt](https://ffmpeg.org/ffmpeg-filters.html#showcqt){:target="\_blank"} filters. Essentially, the audio file gets passed through a frequency spectrum generating filter (showcqt), and the video file is forced to conform to the undulating waves of the audio. Sounds crazy, looks like this (Color Bars + Jumpin' Jack Flash):

<img src="{{ site.baseurl }}/images/colorbars_audioviz.jpg" width="60%">

Usage:

```
./audioviz.sh -p ./sample_audio_files/jumpin.wav ./sample_video_files/colorbars.mov
```
Input 1: the audio file

Input 2: the video file

## bitplane
Based on the QCTools bitplane visualization, which "binds" the bit position of the Y, U, and V planes of a video file by using FFmpeg's [lutyuv](https://ffmpeg.org/ffmpeg-filters.html#lut_002c-lutrgb_002c-lutyuv){:target="\_blank"} filter. The script has randomness built into it, and the numerical values—a range between -1 and 10—for the Y, U, and V planes will vary upon successive runs, yielding cool and different results each time you give it a spin. NOTE: -1 will be the equivalent of removing a plane entirely, while 0 is essentially a stand-in for not manipulating a channel at all (so three zeroes will look exactly like the video would without any change at all).

In YUV video, there are two general things to keep in mind:

* The most significant bits are the lower value numbers—aka most of the image data lives in these lower bits—and as you go up the ranks to 10, your results will become noisier (harder to discern the source).
* In color difference video, Y equates to luma, or brightness, or black and white; U to R-Y; and V to B-Y, so adjusting Y numbers will make the most dramatic difference, while adjusting U and V will make the most colorful difference.

Some additional helpful info from the QCTools documentation:

```
For the Y plane a pixel will display as black if that bit is ‘0’ or white if that bit is ‘1’.
For U a pixel will be yellow-green if ‘0’ purple if ‘1’.
For V a pixel will be green for ‘0’ and red for ‘1’.
Generally lossy video codecs will show blocky structured patterns at higher numbered bit positions.
```
Usage:

```
./bitplane.sh -p ./sample_video_files/fonda.mov 1 6 -1
```
Input 1: the video file

Input 2 (optional, random if unspecified): the Y channel (-1-10)

Input 3 (optional, random if unspecified): the U channel (-1-10)

Input 4 (optional, random if unspecified): the V channel (-1-10)

<img src="{{ site.baseurl }}/images/fonda_bitplane.jpg" width="60%">

## bitplaneslices
Again, totally lifted from QCTools, this script manipulates ONLY the Y plane of a video file (with FFmpeg's [lutyuv](https://ffmpeg.org/ffmpeg-filters.html#lut_002c-lutrgb_002c-lutyuv){:target="\_blank"} filter) to creates a "sliced" effect in which cropped sections of the source video are presented in numerical order from most significant bit (1) to least (10). Hard to describe, looks like this:

Original video

<img src="{{ site.baseurl }}/images/jumpinjackflash.jpg" width="60%">

Passed through bitplaneslices

<img src="{{ site.baseurl }}/images/jumpinjackflash_bitslices.jpg" width="60%">

Usage:

```
./bitplaneslices.sh -p ./sample_video_files/jumpinjackflash.mov
```
Input 1: the video file

## blend
Blends two files together in a variety of ways, using FFmpeg's [blend](https://ffmpeg.org/ffmpeg-filters.html#blend-1){:target="\_blank"} filter. The first input will serve as the "top" layer, the second the "bottom." Defaults to `addition128`, but a number of other options are available (don't miss out on xor):

```
addition, addition128, grainmerge, and, average, burn, darken, difference, difference128,
grainextract, divide, dodge, freeze, exclusion, extremity, glow, hardlight, hardmix, heat,
lighten, linearlight, multiply, multiply128, negation, normal, or, overlay,
phoenix, pinlight, reflect, screen, softlight, subtract, vividlight, xor
```

Usage:

```
./blend.sh -p ./sample_video_files/brain.mov ./sample_video_files/fonda.mov pinlight
```
Input 1: the first video file (top layer)

Input 2: the second video file (bottom layer)

Input 3 (optional): the blend mode

MRI brain scan + Jane Fonda's Workout (pinlight)

<img src="{{ site.baseurl }}/images/brain_blend_pinlight.jpg" width="60%">

MRI brain scan + Jane Fonda's Workout (xor)

<img src="{{ site.baseurl }}/images/brain_blend_xor.jpg" width="60%">

## chromakey
Combines two files using chromakey effects, using FFmpeg's [chromakey](https://ffmpeg.org/ffmpeg-filters.html#chromakey){:target="\_blank"} filter. Fairly straightforward, but you do have to have at least one file that contains the "green" screen that will be replaced with transparency.

Usage:

```
./chromakey.sh -p ./sample_video_files/green_octopus.mov ./sample_video_files/neonsquigglelines.mov
```

Input 1: the video file that contains the "green screen" or color to be keyed out

Input 2: the video file that will appear behind the keyed video

Input 3 (optional): the color to be keyed. Any hex color code can be entered, as well as the following colors: green, blue, red, purple, orange, and yellow. The default value is green or 00FF00.

Input 4 (optional): the similarity level. Default value is 0.6 The closer to 1 the more will be keyed out.

Input 5 (optional): the blending level. Default value is 0.1

Green Screen Octopus

<img src="{{ site.baseurl }}/images/green_octopus.jpg" width="60%">

Background video (neon squiggle lines)

<img src="{{ site.baseurl }}/images/neonsquigglelines.jpg" width="60%">

Chromakeyed video

<img src="{{ site.baseurl }}/images/green_octopus_chromakey.jpg" width="60%">

## colorizer

Re-mixes a video's color channels using FFmpeg's [colorchannelmixer](https://ffmpeg.org/ffmpeg-filters.html#colorchannelmixer){:target="\_blank"} filter.

Usage:

```
./colorizer.sh -p ./sample_video_files/shania.mov red
```

Input 1: the video to be colorized

Input 2: the color (red, orange, yellow, green, blue, purple, white or black)

Shania Twain "That Don't Impress Me Much" music video

<img src="{{ site.baseurl }}/images/shania_original.jpg" width="60%">

Mixed red

<img src="{{ site.baseurl }}/images/shania_red.jpg" width="60%">

Mixed blue

<img src="{{ site.baseurl }}/images/shania_blue.jpg" width="60%">

## corruptor

## echo

## gif

## lagfun

## life

## lumakey

## procamp

## proreser

## pseudocolor

## rainbow-trail.

## repeat
Repeats the input file an arbitrary number of times

Input 1: The video file to be repeated

Input 2 (optional): The number of times to repeat the file. If nothing is entered this will default to 2

## reverse
Reverses the input file

Input 1: The video file to be reversed

## rotate

## tblend_glitch

## tblend

## text

## tile
Based off the QCTools filter "Filmstrip". Tiles the input file, rows and columns can be defined

Input 1: The video file to be tiled

Input 2 (optional): Number of columns (width). Default is 2

Input 3 (optional): Number of columns (height). Default is 2

Input 4 (optional): Output frame size. This will squeeze the output into a specific size. Must be in format "WIDTHxHEIGHT" to work

## trim

## zoomflipscroller
