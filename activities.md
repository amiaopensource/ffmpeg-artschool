---
title: Activities and Exercises
layout: default
nav_order: 5
---

# Activities

This document will describe how to run certain scripts for artistic effects!

***Note***: The commands in these activities assume you are operating out of the root directory of your copy of the ffmpeg-art-school repo, which should be called `ffmpeg-artschool-main` (which contains `sample_audio_files` and `sample_video_files` directories), and also that you have moved the directory of additional `sample_files` that you downloaded into that root directory.

### Art School Gallery
Please add works of FFmpeg art to the [Gallery](https://drive.google.com/drive/folders/1qATrOpNoNwELoHKTRHSl9reshhqXT-Vt?usp=sharing) folder so we can share them with the community! Include your first and last name in the filename if you wish to be credited, like so: ```glitchMasterpiece_JaneDoe.gif```


## Activity 0: Testing your Installation with the Game of Life

Before doing anything else, a good first activity (carried over from the Getting Started page) is to make sure you have FFmpeg installed properly. To do this, open a terminal or powershell window and `cd` into the `ffmpeg-artschool-main` directory (`cd` space drag-and-drop `ffmpeg-artschool-main` is a solid workable approach).

You'll be testing your installation with one of the only Art School scripts that does NOT require an input file: life, which calls on FFmpeg and asks it to generate a visualization based upon John Conway’s [Game of Life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life){:target="\_blank"}.

1. From the root level of `ffmpeg-artschool-main`, run the following:

Mac

```
./bash_scripts/life.sh -p
```

Windows
```
 .\powershell_scripts\life.ps1 -p
```

If all goes according to plan, an FFplay window should pop up with a visualization that looks similar to the following:

<img src="{{ site.baseurl }}/images/life.gif" width="80%">

Congratulations! You're ready to proceed forward. Hit `q` to quit FFplay, and let's move on.

## Activity 1: Normalize/Trim/GIF

From here on out, we'll assume that your terminal or powershell window is still at the root level of `ffmpeg-artschool-main`.

The next set of activities, while not necessarily the most exciting, serve as a good primer to FFmpeg Art School and will help you circumvent any issues you might enocunter when beginning to run various files through the Art School scripts.

### Normalize
Most of the video files that we've provided have been normalized to ProRes/MOV, with a resolution of 640x480, which is easier for a CPU to handle than a large HD or 2K file. However, if you have your own sample files that you'd like to use, it's best to make sure they've been transcoded to ProRes and resized to SD before working with them.

1. Let's start here, with 'normalizing' one of the abnormal sample files we've provided, `fonda.mp4,` a brief clip from Jane Fonda's 1982 classic exercise video.

```
./bash_scripts/proreser.sh -s ./video_files/fonda.mp4 640x480
```

```
.\powershell_scripts\proreser.ps1 -s .\video_files\fonda.mp4 640x480
```
By default, `proreser` will convert your file to ProRes, and by adding the `-s` flag, we're telling the script to save to an output file. By adding `640x480` to the end of the command, we're telling the script to resize the file to 640 pixels by 480 pixels. `proreser` will also remove any audio tracks during this transformation, which may not be ideal for you, but will again help you avoid script fails down the road.

Ta-daah! You've now got a new Quicktime file, `fonda_prores.mov` that should be living alongside the MP4 original.

### Trim
You're loving your new Fonda ProRes file, but after watching it again, you've realized that you'd prefer a shorter, more targeted clip: the group performing jumping jacks (right around the 00:00:07 mark).

1. To make a clip of just this section (00:00:07-00:00:14), we'll use of the Art School `trim` script. Usage is similar and straightforward (a `-s` flag and timestamp in and out points):

```
./bash_scripts/trim.sh -s ./video_files/fonda_prores.mov 00:00:07 00:00:14
```

```
.\powershell_scripts\trim.ps1 -s .\video_files\fonda_prores.mov 00:00:07 00:00:14
```

Now we're cooking! You should see, again alongside your original file, a new trimmed version called `fonda_prores_trim.mov`

### GIF
No Art School experience would be complete without transforming your art into something easily shareable online. For this, we've created a `gif`, a script which will take any input file and turn it into duh, a gif (as with the previous scripts, `gif` does have an optional parameter: 0 results in a more compressed gif; 1 a less compressed, higher quality one).

1. Let's give this a try, making a better looking Fonda crew jumping jack GIF:

```
./bash_scripts/gif.sh -s ./video_files/fonda_prores_trim.mov 1
```

```
.\powershell_scripts\gif.ps1 -s .\video_files\fonda_prores_trim.mov 1
```

With these three scripts working, you should be ready for all the colorful and crazy stuff that follows. Good luck!

## Activity 2: Chromakey and Echo

### Chromakey
The Chromakey effect is used to remove any pixel that is a specific color from a video and turn it transparent. Once the color has been turned transparent the video can be overlayed over another video file and the second file will appear "behind" the removed pixels. The bash script chromakey.sh takes care of the chromakey AND the overlay at once. Let's take it step by step.

1. Find any file in the `video_files` directory that starts with `greenscreen_` of `green_`. We'll use `greenscreen_diamond_02.mov` for the main file. You can use any other video file for the second. We'll use `Cat01.mov` for this example
2. We'll see what it looks like to overlay two files without Chromakey
```
ffmpeg -i ./video_files/Cat01.mov -i ./video_files/greenscreen_diamond_02.mov -c:v prores -filter_complex '[0:v][1:v]overlay,format=yuv422p10le[v]' -map '[v]' -f matroska - | ffplay -
```
3. Well that wasn't very fun! All you'll see is the original greenscreen video. This is just to prove that you can't overlay files with out the chromakey filter.
4. Now we'll see what it looks like to remove the green in the main file with with the following command
```
ffmpeg -i ./video_files/greenscreen_diamond_02.mov -c:v prores -filter_complex 'chromakey=0x00FF00:0.25:0.1' -f matroska - | ffplay -
```
5. You should see that the green has all been removed. The black that's leftover is a special black. It's not actually a black pixel, but an absence of any video data at all! Now see what it looks like when we perform the overlay after chromakeying with the following command:
```
ffmpeg -i ./video_files/Cat01.mov -i ./video_files/greenscreen_diamond_02.mov -c:v prores -filter_complex '[1:v]chromakey=0x00FF00:0.25:0.1[1v];[0:v][1v]overlay,format=yuv422p10le[v]' -map '[v]' -f matroska - | ffplay -
```
6. Congrats! You've now chromakeyed a file and overlayed over another file! The script `chromakey.sh` will do this for you automatically, with many extra options. It will also automatically resize the files so that their dimensions match.

### Echo
This echo effect is based off [a classic tape echo effect](https://www.youtube.com/watch?v=y3Whi-g-0A0) for audio. It adds decaying repetitions to an input file. When using this effect make sure to use an effects with big sweeping motions (like dancers!) for the best results. For this example we'll use `retrodancers.mov`

1. Run the default echo effects on RetroDancer.mov with the following command
```
./bash_scripts/echo.sh -p ./video_files/retrodancers.mov
```

2. For the sake of clarity, this is the same as running this command, which shows all the default arguments used (0.2 second echo, Level 2 trails, Blend mode 1)
```
./bash_scripts/echo.sh -p ./video_files/retrodancers.mov 0.2 2 1
```
3. Now let's adjust the time of the echo. We can set it to a much shorter time with more trails for a more washy effect:
```
./bash_scripts/echo.sh -p ./video_files/retrodancers.mov 0.05 5 1
```
4. The fun really starts when we try different blend modes. Let's do the same short delay time with heavy trails, but using the Pheonix blend mode, which is mode 3
```
./bash_scripts/echo.sh -p ./video_files/retrodancers.mov 0.05 5 3
```
5. We can make it even crazier with the XOR blend mode: 5
```
./bash_scripts/echo.sh -p ./video_files/retrodancers.mov 0.05 5 7
```
6. XOR mode is wild! But we can actually make it a bit more interesting by really slowing down the delay time and reducing the trails. Let's try that
```
./bash_scripts/echo.sh -p ./video_files/retrodancers.mov 0.5 3 7
```
7. Now you've seen some of what echo can do, try experimenting!

## Activity 3: Bitplane, Blend, Zoom/Scroll

### Bitplane
This one is based on the QCTools bitplane visualization, which “binds” the bit position of the Y, U, and V planes of a video file using FFmpeg’s lutyuv filter. This script has  randomness built right into it, yielding different, often colorful results, each time you run it.

1. Let's start here, with a totally random call:
```
./bash_scripts/bitplane.sh -p ./video_files/jumpinjackflash.mov
```
2. Let's test this, by playing Jumpin' Jack Flash but visualizing ONLY the 2 bitplane of the Y channel:
```
./bash_scripts/bitplane.sh -p ./video_files/jumpinjackflash.mov 2 -1 -1
```
You can see how this plays out, with a black and white, fairly blocky image as a result (remember: in this kind of YUV video, the lower bits are "more significant," meaning they contain more image data and serve as the foundational building blocks of your digital image).
Returning to a random run, you should be able to see in your terminal window another fun aspect of this script: it prints out the Y, U, and V values that were either randomly chosen or hand-selected.
```
*******START FFPLAY COMMANDS*******
Y: 5
U: 9
V: 10
```
The idea here is that you can run the script over and over (`q` is a good way to quit FFplay between runs) and when you end up with a video that most suits your artistic temperament, you can easily swap out the `-p` flag for a `-s`.
3. Do this and save your favorite file for our next activity, Zoom/Flip/Scroll.
```
./bash_scripts/bitplane.sh -s ./video_files/jumpinjackflash.mov FAVORITE_Y FAVORITE_U FAVORITE_V
```

### Zoom/Flip/Scroll
A play on the Line 21 closed caption extraction tool sccyou, zoom/flip/scroller takes a single line of video, zooms in extra close, flips it on its axis, and scrolls up vertically. Designed to visualize and analyze closed captioning information, which lives at the tippy top of the video raster, this re-purposing generates results unlike any other. And, as with bitplane, zoomflipscroller defaults to a randomly selected line (between 1-350) but will also accept a user-specified input.

1. Let's start with the original intention for this code, visualizing the closed captions in Jumpin' Jack Flash. Note: it's confusing, but "line 21" captions typically live around lines 1 or 2 in a digital video (the "21" refers to an analog space):
```
./bash_scripts/zoomflipscroller.sh -p ./video_files/jumpinjackflash.mov 1
```
It's fun to be able to see captions in this way, and it helps us understand how this digital information gets "read" and transformed into text, but it's also worth checking out what other lines of video look like this close up.
2. So let's try the script one more time, on the same video, but let's let zoom/flip/scroller randomly choose a line for us:
```
./bash_scripts/zoomflipscroller.sh -p ./video_files/jumpinjackflash.mov
```
To us, this results in video that has a distinct modern art vibe; it's all color and lines and weird squiggly shapes.
3. But what might be even MORE FUN is to try it out on our bitplaned Jumpin' Jack Flash:
```
./bash_scripts/zoomflipscroller.sh -p ./video_files/jumpinjackflash_bitplane.mov
```

What kinds of results did you get, and did you dig them?

## Activity 4: Tblend | Pseudocolor | Showcqt + Displace


1. Find ```bloodmoon_a.mov``` and ```bloodmoon_b.mov``` in the ```video_files``` directory.
2. Use tblend’s difference128 filter and hstack to compare these two similar videos and see if the bad frame/s jump out from behind the gray.
```
ffmpeg -i ./video_files/bloodmoon_a.mov -i ./video_files/bloodmoon_b.mov -filter_complex "[0:v:0]tblend=all_mode=difference128[a];[1:v:0]tblend=all_mode=difference128[b];[a][b]hstack[out]" -map [out] -f nut -c:v rawvideo - | ffplay -
```
3. Now lets make some illegal art. To try out tblend.sh, let's use vividlight mode and with ```bloodmoon_b.mov``` in the sample videos folder:
```
./bash_scripts/tblend.sh -s ./video_files/bloodmoon_b.mov vividlight
```
4. For educational purposes, we'll check out just how illegal the video we made is, using signalstats brng option:
```
ffplay ./video_files/bloodmoon_b_tblend_vividlight.mov -vf signalstats="out=brng:color=turquoise"
```
5. Now let's use tblend to have fun with the output file, ```bloodmoon_b_tblend_vividlight.mov``` using xor mode:
```
./bash_scripts/tblend.sh -s ./video_files/bloodmoon_b_tblend_vividlight.mov xor
```
6. Change things up and use ```audioviz.sh``` with your new output file ```bloodmoon_b_tblend_vividlight_tblend_xor.mov```!(
  * **Note**: if copy/pasting, keep in mind that your final video might be named differently if you used other blend modes than those mentioned above).
```
./bash_scripts/audioviz.sh -s ./audio_files/cage_harmonies.mp3 ./video_files/bloodmoon_b_tblend_vividlight_tblend_xor.mov
```
  * Audioviz.sh outputs to the location of input 1 (so, wherever the audio file lives), let's play it!
```
ffplay ./audio_files/cage_harmonies_audioviz.mov
```

7. Additionally, you can use your illegal art to play with ```pseudocolor.sh```
```
./bash_scripts/pseudocolor.sh -p ./video_files/bloodmoon_b_tblend_vividlight.mov
```

8. You can make things more interesting by adjusting the `eq` or YUV thresholds in that script (I recommend making a copy of it first and working on your copy). Example:
```
filter_string="eq=brightness=0.1:saturation=5,pseudocolor='if(between(val,ymax*0.75,amax),lerp(ymin*10,ymax,(val-ymax)/(amax-ymax)),-2):if(between(val,ymax*0.75,amax),lerp(umax,umin*10,(val-ymax)/(amax-ymax)),-2):if(between(val,ymax*0.75,amax),lerp(vmin*5,vmax,(val-ymax)/(amax-ymax)),-2):-2'"
```

**Neato!**
