# ffmpeg-artschool
FFmpeg Artschool: An AMIA Workshop

## repeat.sh
Repeats the input file an arbitrary number of times

Input 1: The video file to be repeated

Input 2 (optional): The number of times to repeat the file. If nothing is entered this will default to 2

## reverse.sh
Reverses the input file

Input 1: The video file to be reversed

## tile.sh
Based off the QCTools filter "Filmstrip". Tiles the input file, rows and columns can be defined

Input 1: The video file to be tiled

Input 2 (optional): Number of columns (width). Default is 2

Input 3 (optional): Number of columns (height). Default is 2

Input 4 (optional): Output frame size. This will squeeze the output into a specific size. Must be in format "WIDTHxHEIGHT" to work

## chromakey.sh
Based off the QCTools filter "Filmstrip". Tiles the input file, rows and columns can be defined

Input 1: The video file that contains the "green screen" or color to be keyed out

Input 2: The video file that will appear behind the keyed video

Input 3 (optional): The color to be keyed. Any hex color code can be entered, as well as the following colors: green, blue, red, purple, orange, and yellow. The default value is green or 00FF00

Input 4 (optional): The similarity level. Default value is 0.6 The closer to 1 the more will be keyed out.

Input 5 (optional): The blending level. Default value is 0.1
