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

<img src="{{ site.baseurl }}/images/retrodancers_bitplane.jpg" width="80%">


## audioviz
Creates an audio visualization overlay by blending two input files (one video, one audio) and using FFmpeg's [displace](https://ffmpeg.org/ffmpeg-filters.html#displace){:target="\_blank"} and [showcqt](https://ffmpeg.org/ffmpeg-filters.html#showcqt){:target="\_blank"} filters. Essentially, the audio file gets passed through a frequency spectrum generating filter (showcqt), and the video file is forced to conform to the undulating waves of the audio. Sounds crazy, looks like this (Color Bars + Jumpin' Jack Flash):

<img src="{{ site.baseurl }}/images/colorbars_audioviz.jpg" width="80%">

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

<img src="{{ site.baseurl }}/images/fonda_bitplane.jpg" width="80%">

## bitplaneslices
Again, totally lifted from QCTools, this script manipulates ONLY the Y plane of a video file (with FFmpeg's [lutyuv](https://ffmpeg.org/ffmpeg-filters.html#lut_002c-lutrgb_002c-lutyuv){:target="\_blank"} filter) to creates a "sliced" effect in which cropped sections of the source video are presented in numerical order from most significant bit (1) to least (10). Hard to describe, looks like this:

Original video

<img src="{{ site.baseurl }}/images/jumpinjackflash.jpg" width="80%">

Passed through bitplaneslices

<img src="{{ site.baseurl }}/images/jumpinjackflash_bitslices.jpg" width="80%">

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

<img src="{{ site.baseurl }}/images/brain_blend_pinlight.jpg" width="80%">

MRI brain scan + Jane Fonda's Workout (xor)

<img src="{{ site.baseurl }}/images/brain_blend_xor.jpg" width="80%">

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

<img src="{{ site.baseurl }}/images/green_octopus.jpg" width="80%">

Background video (neon squiggle lines)

<img src="{{ site.baseurl }}/images/neonsquigglelines.jpg" width="80%">

Chromakeyed video

<img src="{{ site.baseurl }}/images/green_octopus_chromakey.jpg" width="80%">

## colorizer

Re-mixes a video's color channels using FFmpeg's [colorchannelmixer](https://ffmpeg.org/ffmpeg-filters.html#colorchannelmixer){:target="\_blank"} filter.

Usage:

```
./colorizer.sh -p ./sample_video_files/shania.mov red
```

Input 1: the video to be colorized

Input 2: the color (red, orange, yellow, green, blue, purple, white or black)

Shania Twain "That Don't Impress Me Much" music video

<img src="{{ site.baseurl }}/images/shania_original.jpg" width="80%">

Mixed red

<img src="{{ site.baseurl }}/images/shania_red.jpg" width="80%">

Mixed blue

<img src="{{ site.baseurl }}/images/shania_blue.jpg" width="80%">

## corruptor
Uses FFmpeg's [bitstream noise](https://ffmpeg.org/ffmpeg-bitstream-filters.html#noise){:target="\_blank"} filter to CORRUPT your video in potentially cool looking ways. Mostly used for fuzzing or error concealment/resilience testing, but adapted to suit our artistic needs.

Usage:

```
./corruptor.sh -p ./sample_video_files/charli.mov
```

Input 1: the video to be corrupted

Input 2 (optional): the corruption Amount [default: 0.1]. 0 is no error and 1 is all error. Anything above 0.5 will likely not play

Input 3 (optional): keep temporary file (boolean). Default is 0 (false), use 1 to keep the file but it will probably be wonky

Charli XCX & Christine and the Queens "Gone" music video

<img src="{{ site.baseurl }}/images/charli_original.jpg" c>

Corrupted (with default settings)

<img src="{{ site.baseurl }}/images/charli_corrupted.jpg" width="80%">

## echo
Uses FFmpeg's [blend](https://ffmpeg.org/ffmpeg-filters.html#blend-1){:target="\_blank"} filter to create a video echo/ghost/trailing effect. Offers eight different blend modes, with varying effects:

```
# 1: Normal mode, nice and balanced with evenly blending trails, but gets out of hand with a higher tail length.
# 2: Screen mode, Works well with high contrast stuff but gets out of hand very quickly
# 3: Phoenix mode, cool psychedelic effect
# 4: Softlight mode, trails dissipate very quickly, a subtle effect.
# 5: Average mode, Similar to normal with slightly different colors.
# 6: Heat mode, image is harshly affects.
# 7: Xor mode, very cool strobing effect
# 8: Difference mode, slightly less intense than xor but similar
```

Usage:

```
./echo.sh -p ./sample_video_files/jellyfish.mov .2 5 3
```

Input 1: the video file to be echoed

Input 2 (optional): the echo rate, in seconds (default is 0.2)

Input 3 (optional): the length of trails. 1 is just one trails, number increases exponentially as it goes.

Input 4 (optional): the echo mode (choose 1 thru 8)

Jellyfish

<img src="{{ site.baseurl }}/images/jellyfish.jpg" width="80%">

Echo Jellies

<img src="{{ site.baseurl }}/images/jellyfish_echo.jpg" width="80%">

## gif
Turns a video file into a gif, using FFmpeg's [palettegen](https://ffmpeg.org/ffmpeg-filters.html#palettegen-1){:target="\_blank"} filter (good for sharing your art!). Note: this script has no preview mode, it just makes gifs.

Usage:

```
./gif.sh ./sample_video_files/jellyfish_echo.mov 1
```

Input 1: the video file

Input 2: the quality of the resulting gif (0 = more compressed, smaller file; 1 = less compressed bigger file)

<img src="{{ site.baseurl }}/images/jellyfish_echo.gif" width="80%">


## lagfun
Creates a different kind of echo/ghost/trailing effect, using FFmpeg's [lagfun](https://ffmpeg.org/ffmpeg-filters.html#lagfun_){:target="\_blank"} filter.

Usage:

```
./lagfun -p ./sample_video_files/jellyfish.mov 3
```
Input 1: the video file to be lagged

Input 2: the trail mode (pick 1 thru 3). Try different modes for fun!

Input 3: the trail amount, or intensity of the effect. Default is 1.

Lagfun Jellyfish, trail mode 3, in gif form

<img src="{{ site.baseurl }}/images/jellyfish_lagfun.gif" width="80%">

## life
One of the only Art School scripts to not require an input file, this one uses FFmpeg's [life](https://ffmpeg.org/ffmpeg-filters.html#life){:target="\_blank"} filter to generate a visualization based upon John Conway's [Game of Life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life){:target="\_blank"}. Ideal for testing your FFmpeg installation, and the starting point of FFmpeg Art School's lesson plan. Note: if running this script in save mode, the resulting file will be located in your current working directory (in all likelihood `bash_scripts`)

Usage:

```
./life.sh -p
```
Input 1 (optional): the game size (small, medium, or large). Default is medium.

Input 2 (optional): the color of life (blue, green, red, purple, or orange). Default is yellow.

Input 3 (optional): the color of death (blue, green, red, purple, or orange). Default is red.

Input 4 (optional): the rate (slow, medium, or fast). Default is random selection.

Input 5 (optional): the ratio (low, medium, or high). Default is random selection.

Game of Life, also best seen in gif form

<img src="{{ site.baseurl }}/images/life.gif" width="80%">

## lumakey
Combine two files using FFmpeg's [lumakey](https://ffmpeg.org/ffmpeg-filters.html#lumakey){:target="\_blank"} while transforming certain luma values into transparency.  

Usage:

```
./lumakey.sh ./sample_video_files/green_trex.mov ./sample_video_files/flowers.mov
```

Input 1: the video that will be keyed

Input 2: the background video

Input 3 (optional): the threshold (0 will key out black, 1 will key out white). Default is 0.

Input 4 (optional): the tolerance (if the threshold is 0, use a low number like 0.1 to key out darks. If threshold is 1, use a high number like 0.7 to key out whites). Default is 0.1.

Input 5: the softness (softens the key; 0 has sharp edges, 1 is Downy soft, though it's not advisable to go above 0.4). Default is 0.2.

Green screen T-Rex, lumakeyed over timelape video of Nasturtium flowers (why? who knows)

<img src="{{ site.baseurl }}/images/green_trex_lumakey.gif" width="80%">

## procamp

## proreser

## pseudocolor

## rainbow-trail

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
