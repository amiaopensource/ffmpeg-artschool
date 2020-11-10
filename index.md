---
title: Getting Started
layout: default
nav_order: 1
---

# Getting Started

<img src="{{ site.baseurl }}/images/rainbowjellies.gif">

Please complete the following instructions before the start of the workshop. Total setup time is approximately 15 minutes.

## Download the scripts for the workshop
1. Go the [Github repository for the workshop](https://github.com/iamdamosuzuki/ffmpeg-artschool)
2. Click the green button labeled `Code` and choose Download ZIP from the drop-down menu.
3. Open the folder where the ZIP file was downloaded (probably your Downloads folder) and unzip the file.
4. Open the unzipped folder, and then open the folder named `ffmpeg-artschool-main`. You should see folders named `bash_scripts` and `powershell_scripts`.

## Download the sample files for the workshop
1. Go the [sample data folder for the workshop](link to come)
2. Click the name of the folder `ffmpeg-art-school-sampledata` and select Download from the drop-down menu.
3. Open the folder where the ZIP file was downloaded (probably your Downloads folder) in a new window and unzip the file.
4. Open the unzipped folder, copy the folders named `sample_video_files` and `sample_audio_files`, and paste them into the `ffmpeg-artschool-main` folder.

## Install or update ffmpeg
These instructions differ depending on what operating system you are using.

### Mac/Linux
1. Open a terminal window by pressing `command` and `space` on your keyboard to open Spotlight, typing Terminal, and pressing enter.
2. Check if you have ffmpeg installed and what version you have installed. In the terminal, type `ffmpeg -version` and press enter.
* If the output says `command not found`, you will have to install ffmpeg. Continue to step 3.
* If the first line of output starts with `ffmpeg version 3` or lower, you will have to update your installation of ffmpeg. Continue to step 3
* If the first line of output starts with `ffmpeg version 4`, you have the version of ffmpeg required for the workshop. Go to Testing Your Setup.
3. We will use homebrew to install or upgrade ffmpeg. To check you have homebrew installed, type `brew --version` and press enter.
	* If the output says `command not found`, you will have to install homebrew. Copy the following command, paste it into your terminal, and run it. While this command runs, you may have to enter your password or respond `y` several times in order to grant permission for the installation to complete. Then, continue to step 4
`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"`
	* Otherwise, continue to step 4.
4. In the terminal, type `brew update && brew upgrade ffmpeg` and press enter.
	* If the output says `brew not installed`, type `brew install ffmpeg` and press enter.

### Windows
1. Open a Powershell window, by opening the Start Menu, typing Powershell, and then clicking Powershell.
2. Check if you have ffmpeg installed and what version you have installed. In the Powershell window, type `ffmpeg.exe -version` and press enter.
* If the output says `command not found`, you will have to install ffmpeg. Continue to step 3.
* If the first line of output starts with `ffmpeg version 3` or lower, you will have to update your installation of ffmpeg. Continue to step 3
* If the first line of output starts with `ffmpeg version 4`, you have the version of ffmpeg required for the workshop. Go to Testing Your Setup.
3. We will use scoop to install or upgrade ffmpeg and install ported versions of common bash programs (coreutils). To check you have scoop installed, type `scoop` and press enter.
	* If the output says `command not found`, you will have to install scoop. Copy the following command, paste it into your Powershell window, and run it. While this command runs, you may have to enter your password or respond `y` several times in order to grant permission for the installation to complete. Then, continue to step 4
`iwr -useb get.scoop.sh | iex`
		* If you get an error, you will need to grant permissions to run the installation script. Copy the following command, paste it into your Powershell window, and run it.
`Set-ExecutionPolicy RemoteSigned -scope CurrentUser`
	* Otherwise, continue to step 4.
4. In the Powershell window, type `scoop install ffmpeg coreutils` and press enter.
	* If ffmpeg is already installed, type `scoop update ffmpeg` and press enter.
5.

## Test that everything is working
### Mac/Linux
1. In the terminal, change your working directory to the workshop folder. For example, if you downloaded and unzipped the github repository to your Downloads folder, you would use the following command `cd ~/Downloads/ffmpeg-artschool-main/ffmpeg-artschool-main`
2. Test a script
`./bash_scripts/life.sh -p`
	* If you see any errors, please email the workshop organizers.

### Windows
1. In the terminal, change your working directory to the workshop folder. For example, if you downloaded and unzipped the github repository to your Downloads folder, you would use the following command `cd ~\Downloads\ffmpeg-artschool-main\ffmpeg-artschool-main\`
2. Test a script
`.\powershell_scripts\life.ps1 -p`
	* If you see any errors, please email the workshop organizers.
