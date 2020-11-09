<#
.DESCRIPTION
    ---
.PARAMETER h
    display this help
.PARAMETER p
    previews in FFplay
.PARAMETER s
    saves to file with FFmpeg
.PARAMETER video1
    path to the first video
.PARAMETER video2
    path to the second video
.PARAMETER key
    color that will be replaced with transparency. Options include: blue, green, red, purple, orange, and yellow
.PARAMETER colorSim
    similarity percentage with the key color. Between 0.01 and 1. 0.01 matches only the exact key color, while 1.0 matches everything.
.PARAMETER colorBlend
    blend percentage for overlay video. Between 0 and 1. 9 makes pixels fully transparent or not transparent at all. The closer to 1, the more transparency.
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
    [System.IO.FileInfo]$video1,

    [Parameter(Position=1, Mandatory, ParameterSetName="Run")]
    [ValidateScript({
        if(-Not ($_ | Test-Path) ){
            throw "File or folder does not exist" 
        }
        if(-Not ($_ | Test-Path -PathType Leaf) ){
            throw "The Path argument must be a file. Folder paths are not allowed."
        }
        return $true
    })]
    [System.IO.FileInfo]$video2,

    [Parameter(Position=2, ParameterSetName="Run")]
    [ValidateSet("blue", "green", "red", "purple", "orange", "yellow")]
    $key = "green",

    [Parameter(Position=3, ParameterSetName="Run")]
    [ValidateRange(0.01, 1)]
    [Decimal]
    $colorSim = 0.3,

    [Parameter(Position=4, ParameterSetName="Run")]
    [ValidateRange(0, 1)]
    [Decimal]
    $colorBlend = 0.1
)


# Display help

if (($h) -or ($PSBoundParameters.Values.Count -eq 0 -and $args.count -eq 0)){
    Get-Help $MyInvocation.MyCommand.Definition -detailed
    if (!$video1) {
        exit
    }
}


# Create filter string
Switch ($key)
{
    "blue" {$hexkey = "0000FF"}
    "green" {$hexkey = "00FF00"}
    "red" {$hexkey = "FF0000"}
    "purple" {$hexkey = "FF00FF"}
    "orange" {$hexkey = "FF9900"}
    "yellow" {$hexkey = "FFFF00"}
}

$filter = "[1:v][0:v]scale2ref[v1][v0];[v1]chromakey=0x$($hexkey):$($colorSim):$($colorBlend)[1v];[v0][1v]overlay,format=yuv422p10le[v]"


# Run command

if ($p) {
    $tempFile = New-TemporaryFile
    ffmpeg.exe -hide_banner -stats -y -i $video1 -i $video2 -c:v prores -profile:v 3 -filter_complex $filter -map "[v]" -f matroska $tempFile
    ffplay.exe $tempFile
    
    Write-Host @"


*******START FFPLAY COMMANDS*******

ffmpeg.exe -hide_banner -stats -y -i $video1 -i $video2 -c:v prores -profile:v 3 -filter_complex `"$($filter)`" -map `"[v]`" -f matroska $tempFile
ffplay $tempFile.FullName

********END FFPLAY COMMANDS********


"@
}
else {
    ffmpeg.exe -hide_banner -i $video1 -i $video2 -c:v prores -profile:v 3 -filter_complex $filter -map "[v]" "$((Get-Item $video1).Basename)_chromakey.mov"

    Write-Host @"


*******START FFMPEG COMMANDS*******

ffmpeg.exe -hide_banner -i $video1 -i $video2 -c:v prores -profile:v 3 -filter_complex `"$($filter)`" -map `"[v]`" `"$((Get-Item $video1).Basename)_chromakey.mov`"

********END FFMPEG COMMANDS********


"@
}
