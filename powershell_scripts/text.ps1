<#
.DESCRIPTION
    creates a video from text
.PARAMETER h
    display this help
.PARAMETER p
    previews in FFplay
.PARAMETER s
    saves to file with FFmpeg
.PARAMETER text
    text to be written. Can be text or path to text file. If text, must be quoted
.PARAMETER textColor
    color of the text [default: white] (white, black, silver, grey, green, blue, yellow, red, purple, orange)
.PARAMETER backgroundColor
    color of the background [default: black] (white, black, silver, grey, green, blue, yellow, red, purple, orange)
.PARAMETER textSize
    the size of the text. [default: 30] The higher the bigger
.PARAMETER scrollDirection
    the direction of the scroll. [default: center] Accepts left, right, up, down, center. Center is no motion
.PARAMETER scrollSpeed
    the direction of the scroll. [default: 80] The higher the faster
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
    [String]$text,

    [Parameter(Position=1, Mandatory, ParameterSetName="Run")]
    [ValidateSet("white", "black", "silver", "grey", "green", "blue", "yellow", "red", "purple", "orange")]
    $textColor = "green",

    [Parameter(Position=2, Mandatory, ParameterSetName="Run")]
    [ValidateSet("white", "black", "silver", "grey", "green", "blue", "yellow", "red", "purple", "orange")]
    $backgroundColor = "black",
    
    [Parameter(Position=3, ParameterSetName="Run")]
    [ValidateRange(0,1024)]
    [Int]$textSize = 30

    [Parameter(Position=4, ParameterSetName="Run")]
    [ValidateRange(0,1024)]
    [Int]$scrollDirection = 30

    [Parameter(Position=5, ParameterSetName="Run")]
    [ValidateRange(0,1024)]
    [Int]$scrollSpeed = 80

    [Parameter(Position=6, ParameterSetName="Run")]
    [ValidateSet("left", "right", "up", "down", "center")]
    [Int]$textSize = 30
)


# Display help

if (($h) -or ($PSBoundParameters.Values.Count -eq 0 -and $args.count -eq 0)){
    Get-Help $MyInvocation.MyCommand.Definition -detailed
    if (!$video) {
        exit
    }
}


# Create filter string

Switch ($textColor)
{
    "white" {$ffTextColor = "FFFFFF"}
    "black" {$ffTextColor = "000000"}
    "silver" {$ffTextColor = "C0C0C0"}
    "grey" {$ffTextColor = "808080"}
    "blue" {$ffTextColor = "0000FF"}
    "green" {$ffTextColor = "00FF00"}
    "red" {$ffTextColor = "FF0000"}
    "purple" {$ffTextColor = "FF00FF"}
    "orange" {$ffTextColor = "FF9900"}
    "yellow" {$ffTextColor = "FFFF00"}
}

Switch ($backgroundColor)
{
    "white" {$ffBackgroundColor = "FFFFFF"}
    "black" {$ffBackgroundColor = "000000"}
    "silver" {$ffBackgroundColor = "C0C0C0"}
    "grey" {$ffBackgroundColor = "808080"}
    "blue" {$ffBackgroundColor = "0000FF"}
    "green" {$ffBackgroundColor = "00FF00"}
    "red" {$ffBackgroundColor = "FF0000"}
    "purple" {$ffBackgroundColor = "FF00FF"}
    "orange" {$ffBackgroundColor = "FF9900"}
    "yellow" {$ffBackgroundColor = "FFFF00"}
}

Switch ($scrollDirection) {
    "left" {$posString="x=w-$scrollSpeed*t:y=(h-text_h)/2 "}       #scrolls left
    "right" {$posString="x=$scrollSpeed*t-w:y=(h-text_h)/2 "}
    "up" {$posString="x=(w-text_w)/2:y=h-$scrollSpeed*t"}
    "down" {$posString="x=(w-text_w)/2:y=$scrollSpeed*t-h"}
    "center" {$posString="x=(w-text_w)/2:y=(h-text_h)/2"}    #no scroll, text is centered
}


if (-Not ($_ | Test-Path)) {
    $textString = "text='$text'"
}
else {
    $textString = "textfile='$text'"
}

$lavfiString="color=size=640x480:duration=10:rate=25:color=$bgrColor"
$filter="drawtext=fontfile=/path/to/helvitca.ttf:fontsize=$($textSize):fontcolor=$textColor:$posString:$textFilter"


# Run command

if ($p) {
    $tempFile = New-TemporaryFile
    ffmpeg.exe -hide_banner -stats -f lavfi -i $lavfiString -vf $filter -f matroska $tempFile
    ffplay.exe $tempFile
    
    Write-Host @"


*******START FFPLAY COMMANDS*******

ffmpeg.exe -hide_banner -stats -y -f lavfi -i $lavfiString -vf $filter -f matroska $tempFile
ffplay $tempFile.FullName

********END FFPLAY COMMANDS********


"@
}
else {
    ffmpeg.exe -hide_banner -f lavfi -i $lavfiString -c:v prores -profile:v 3 -vf $filter "text.mov"

    Write-Host @"


*******START FFMPEG COMMANDS*******

ffmpeg.exe -hide_banner -f lavfi -i $lavfiString -c:v prores -profile:v 3 -vf $filter "text.mov"

********END FFMPEG COMMANDS********


"@
}

