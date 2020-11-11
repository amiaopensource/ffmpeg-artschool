<#
.DESCRIPTION
    Allows the user to adjust the luma, black, chroma, and hue like a proc amp
    This script is set up to work like a DPS-290 Proc amp, where each value can be between -128 and 128, with 0 being the unchanged amount.
.PARAMETER h
    display this help
.PARAMETER p
    previews in FFplay
.PARAMETER s
    saves to file with FFmpeg
.PARAMETER video
    path to the first video
.PARAMETER luma
    adjusts the luma/contrast. [default: 0]
.PARAMETER black
    adjusts the black/brightness. [default: 0]
.PARAMETER chroma
    adjusts the chroma/saturation. [default: 0]
.PARAMETER hue
    adjusts the hue/color. [default: 0]
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
    [ValidateRange(-128, 128)]
    [Int]
    $luma = 0,

    [Parameter(Position=2, ParameterSetName="Run")]
    [ValidateRange(-128, 128)]
    [Int]
    $black = 0,

    [Parameter(Position=3, ParameterSetName="Run")]
    [ValidateRange(-128, 128)]
    [Int]
    $chroma = 0,

    [Parameter(Position=4, ParameterSetName="Run")]
    [ValidateRange(-128, 128)]
    [Int]
    $hue = 0
)


# Display help

if (($h) -or ($PSBoundParameters.Values.Count -eq 0 -and $args.count -eq 0)){
    Get-Help $MyInvocation.MyCommand.Definition -detailed
    if (!$video) {
        exit
    }
}


# Create filter string

if ($luma -lt 1) {
    $lumaTemp = [Math]::Round($luma*0.0078125, 4)
}
else {
    $lumaTemp = [Math]::Round($luma*0.015625, 4)
}
$ffLuma = $lumaTemp + 1

$ffBlack = [Math]::Round($black*1.40625, 4)

if ($chroma -lt 1) {
    $chromaTemp = [Math]::Round($chroma*0.0078125, 4)
}
else {
    $chromaTemp = [Math]::Round($chroma*0.0703125, 4)
}
$ffChroma = $chromaTemp + 1

$ffHue = [Math]::Round($hue*1.40625, 4)

$filter = "lutyuv=y=(val+$($ffBlack))*$($ffLuma):u=val:v=val,hue=h=$($ffLuma):s=$($ffChroma)"


# Run command

if ($p) {
    $tempFile = New-TemporaryFile
    ffmpeg.exe -hide_banner -stats -y -i $video -c:v prores -profile:v 3 -filter_complex $filter -f matroska $tempFile
    ffplay.exe $tempFile
    Remove-Item $tempFile
    
    Write-Host @"


*******START FFPLAY COMMANDS*******

ffmpeg.exe -hide_banner -stats -y -i $video -c:v prores -profile:v 3 -filter_complex `"$($filter)`" -f matroska $tempFile
ffplay $tempFile.FullName
Remove-Item $tempFile

********END FFPLAY COMMANDS********


"@
}
else {
    ffmpeg.exe -hide_banner -i $video -c:v prores -profile:v 3 -filter_complex $filter "$(Join-path (Get-Item $video).DirectoryName -ChildPath (Get-Item $video).BaseName)_procamp.mov"

    Write-Host @"


*******START FFMPEG COMMANDS*******

ffmpeg.exe -hide_banner -i $video -c:v prores -profile:v 3 -filter_complex `"$($filter)`" `"$(Join-path (Get-Item $video).DirectoryName -ChildPath (Get-Item $video).BaseName)_procamp.mov`"

********END FFMPEG COMMANDS********


"@
}

