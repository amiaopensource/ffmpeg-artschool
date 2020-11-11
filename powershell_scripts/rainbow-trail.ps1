<#
.DESCRIPTION
    generate rainbow-trail video effect
.PARAMETER h
    display this help
.PARAMETER p
    previews in FFplay
.PARAMETER s
    saves to file with FFmpeg
.PARAMETER video
    path to the video
.PARAMETER key 
    color that will be replaced with transparency. [default: "blue"] Options include: blue, green, red, purple, orange, and yellow
.PARAMETER colorSim
    similarity percentage with the key color. Between 0.01 and 1. 0.01 matches only the exact key color, while 1.0 matches everything.
.PARAMETER colorBlend
    blend percentage for overlay video. Between 0 and 1. 9 makes pixels fully transparent or not transparent at all. The closer to 1, the more transparency.
.PARAMETER colorIter
    number of color iterations [default: 7]
.PARAMETER colorDelay
    delay between colors in seconds [default: 0.1]
.PARAMETER alphaExtract
    alpha plane extraction [default: true]
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

    [Parameter(Position=1, ParameterSetName="Run")]
    [ValidateSet("blue", "green", "red", "purple", "orange", "yellow")]
    $key = "blue",

    [Parameter(Position=2, ParameterSetName="Run")]
    [ValidateRange(0.01, 1)]
    [Decimal]
    $colorSim = 0.3,

    [Parameter(Position=3, ParameterSetName="Run")]
    [ValidateRange(0, 1)]
    [Decimal]
    $colorBlend = 0.1,

    [Parameter(Position=4, ParameterSetName="Run")]
    [ValidateRange(1, 7)]
    [Int]
    $colorIter = 7,

    [Parameter(Position=5, ParameterSetName="Run")]
    [ValidateRange(0, 10)]
    [Decimal]
    $colorDelay = 0.1,

    [Parameter(Position=6, ParameterSetName="Run")]
    [Switch]
    $alphaExtract = $true
)


# Display help

if (($h) -or ($PSBoundParameters.Values.Count -eq 0 -and $args.count -eq 0)){
    Get-Help $MyInvocation.MyCommand.Definition -detailed
    if (!$video) {
        exit
    }
}


# Create filter string

Switch ($key)
{
    "blue" {$ffKeyColor="#0000FF"}
    "green" {$ffKeyColor="#00FF00"}
    "red" {$ffKeyColor="#FF0000"}
    "purple" {$ffKeyColor="#9900FF"}
    "orange" {$ffKeyColor="#0099FF"}
    "yellow" {$ffKeyColor="#FFFF00"}
}

# Array of colours (Violet, Indigo, Blue, Green, Yellow, Orange, Red)

$rainbowColors = @("2:0:0:0:0:0:0:0:2:0:0:0",
    ".5:0:0:0:0:0:0:0:2:0:0:0", 
    "0:0:0:0:0:0:0:0:2:0:0:0", 
    "0:0:0:0:2:0:0:0:0:0:0:0", 
    "2:0:0:0:2:0:0:0:0:0:0:0", 
    "2:0:0:0:.5:0:0:0:0:0:0:0", 
    "2:0:0:0:0:0:0:0:0:0:0:0"
)

# Interprete alphaExtract
if ($alphaExtract) {
    $extractFilter = "extractplanes=a"
}
else {
    $extractFilter = "null"
}

# Build color layers part of filtergraph
$ptsDelay = 0
$filtergraph = ""

For ( $i=0; $i -lt $trailLength; $i++ ){
  ptsDelay = $ptsDelay + $delay
  filtergraph="[original]split[original][top];[top]colorkey=$($key):$($colorSim):$($colorBlend),$($extractFilter),colorchannelmixer=$($rainbowColors[i]),setpts=PTS+$ptsDelay/TB,chromakey=black:0.01:0.1[top];[bottom][top]overlay[bottom];$filtergraph"
}

$filter = "colorkey=$($key):$($colorSim):$($colorBlend),split[original][bottom];[bottom]colorchannelmixer=0:0:0:0:0:0:0:0:0:0:0:0[bottom];$filtergraph[bottom][original]overlay,format=yuv422p10le"


# Run command

if ($p) {
    $tempFile = New-TemporaryFile
    ffmpeg.exe -hide_banner -stats -y -i $video -c:v prores -profile:v 3 -vf $filter -f matroska $tempFile
    ffplay.exe $tempFile
    Remove-Item $tempFile
    
    Write-Host @"


*******START FFPLAY COMMANDS*******

ffmpeg.exe -hide_banner -stats -y -i $video -c:v prores -profile:v 3 -vf $filter -f matroska $tempFile
ffplay $tempFile.FullName
Remove-Item $tempFile

********END FFPLAY COMMANDS********


"@
}
else {
    ffmpeg.exe -hide_banner -i $video -c:v prores -profile:v 3 -vf $filter "$(Join-path (Get-Item $video).DirectoryName -ChildPath (Get-Item $video).BaseName)_rainbowTrails.mov"

    Write-Host @"


*******START FFMPEG COMMANDS*******

ffmpeg.exe -hide_banner -i $video -c:v prores -profile:v 3 -vf $($filter) `"$(Join-path (Get-Item $video).DirectoryName -ChildPath (Get-Item $video).BaseName)_rainbowTrails.mov`"

********END FFMPEG COMMANDS********


"@
}

