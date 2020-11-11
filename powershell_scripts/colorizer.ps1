<#
.DESCRIPTION
    colorize a video using colorchanelmixer
.PARAMETER h
    display this help
.PARAMETER p
    previews in FFplay
.PARAMETER s
    saves to file with FFmpeg
.PARAMETER video
    path to the video
.PARAMETER color
    color that will be replaced with transparency. Options include: blue, green, red, purple, orange, yellow, white, and black
#>


# Parse arguments
Param(
    [Parameter(ParameterSetName="Help")]
    [Parameter(ParameterSetName="Run")]
    [Switch]
    $h,

    [Parameter(ParameterSetName="Run")]
    [Switch]
    $p,

    [Parameter(ParameterSetName="Run")]
    [Switch]
    $s = $true,

    [Parameter(Position=0, Mandatory, ParameterSetName="Run")]
    [ValidateScript({
        if(-Not ($_ | Test-Path) ){
            throw "File or folder does not exist" 
        }
        if(-Not ($_ | Test-Path -PathType Leaf) ){
            throw "The Path argument must be a file. Folder paths are not allowed."
        }
        return $true
    })]
    [System.IO.FileInfo]$video,

    [Parameter(Position=1, Mandatory, ParameterSetName="Run")]
    [ValidateSet("blue", "green", "red", "purple", "orange", "yellow", "white", "black")]
    $color
)


# Display help

if (($h) -or ($PSBoundParameters.Values.Count -eq 0 -and $args.count -eq 0)){
    Get-Help $MyInvocation.MyCommand.Definition -detailed
    if (!$video) {
        exit
    }
}


# Create filter string
Switch ($color)
{
    "blue" {$colorNumbers = "0:0:0:0:0:0:0:0:2:0:0:0"}
    "green" {$colorNumbers = "0:0:0:0:2:0:0:0:0:0:0:0"}
    "red" {$colorNumbers = "2:0:0:0:0:0:0:0:0:0:0:0"}
    "purple" {$colorNumbers = "2:0:0:0:0:0:0:0:2:0:0:0"}
    "orange" {$colorNumbers = "2:0:0:0:.5:0:0:0:0:0:0:0"}
    "yellow" {$colorNumbers = "2:0:0:0:2:0:0:0:0:0:0:0"}
    "white" {$colorNumbers = "2:2:2:2:2:2:2:2:2:2:2:2"}
    "black" {$colorNumbers = "2:2:2:2:2:2:2:2:2:2:2:2,lutyuv=y=negval"}
}

$filter = "colorchannelmixer=$colorNums,format=yuv422p10le"


# Run command

if ($p) {
    $tempFile = New-TemporaryFile
    ffmpeg.exe -hide_banner -stats -y -i $video1 -c:v prores -profile:v 3 -vf $filter -f matroska $tempFile
    ffplay.exe $tempFile
    Remove-Item $tempFile
    
    Write-Host @"


*******START FFPLAY COMMANDS*******

ffmpeg.exe -hide_banner -stats -y -i $video -c:v prores -profile:v 3 -vf `"$($filter)`" -f matroska $tempFile
ffplay $tempFile.FullName
Remove-Item $tempFile

********END FFPLAY COMMANDS********


"@
}
else {
    ffmpeg.exe -hide_banner -i $video -c:v prores -profile:v 3 -vf $filter "$((Get-Item $video).Basename)_colorizer_$($color).mov"

    Write-Host @"


*******START FFMPEG COMMANDS*******

ffmpeg.exe -hide_banner -i $video -c:v prores -profile:v 3 -vf `"$($filter)`" `"$((Get-Item $video).Basename)_colorizer_$($color).mov`"

********END FFMPEG COMMANDS********


"@
}
