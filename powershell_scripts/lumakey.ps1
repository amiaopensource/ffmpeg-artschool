<#
.DESCRIPTION
    Create visuals based on Conway's Game of Life
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
.PARAMETER threshhold
    luma value to key out [default: 0]. 0 will key out black, 1 will key out white
.PARAMETER tolerance
    proximity to luma value to key out [default 0.1]. If threshold is 0, then use a low number like 0.1 to key out darks. If threshold is 1, use a high number like 0.7 to key out whites
.PARAMETER softness
    blend between keyed and unkeyed values [default: 0.2]. this softens the key. 0 has sharp edges, 1 is totally soft, however it's not advisable to go above 0.4
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
    [ValidateRange(0, 1)]
    [Int]
    $threshhold = 0,

    [Parameter(Position=3, ParameterSetName="Run")]
    [ValidateRange(0, 1)]
    [Decimal]
    $tolerance = 0.1,

    [Parameter(Position=4, ParameterSetName="Run")]
    [ValidateRange(0, 1)]
    [Decimal]
    $softness = 0.2
)


# Display help

if (($h) -or ($PSBoundParameters.Values.Count -eq 0 -and $args.count -eq 0)){
    Get-Help $MyInvocation.MyCommand.Definition -detailed
    if (!$video) {
        exit
    }
}


# Build filter string

$filter = "[0:v][1:v]scale2ref[v0][v1];[v1]lumakey=threshold=$($threshhold):tolerance=$($tolerance):softness=$($softness)[1v];[v0][1v]overlay,format=yuv422p10le[v]"


# Run command

if ($p) {
    $tempFile = New-TemporaryFile
    ffmpeg.exe -hide_banner -stats -y -i $video1 -i $video2 -c:v prores -profile:v 3 -filter_complex $filter -map "[v]" -f matroska $tempFile
    ffplay.exe $tempFile
    Remove-Item $tempFile
    
    Write-Host @"


*******START FFPLAY COMMANDS*******

ffmpeg.exe -hide_banner -stats -y -i $video1 -i $video2 -c:v prores -profile:v 3 -filter_complex `"$($filter)`" -map `"[v]`" -f matroska $tempFile
ffplay $tempFile.FullName
Remove-Item $tempFile

********END FFPLAY COMMANDS********


"@
}
else {
    ffmpeg.exe -hide_banner -i $video1 -i $video2 -c:v prores -profile:v 3 -filter_complex $filter -map "[v]" "$(Join-path (Get-Item $video1).DirectoryName -ChildPath (Get-Item $video1).BaseName)_lumakey.mov"

    Write-Host @"


*******START FFMPEG COMMANDS*******

ffmpeg.exe -hide_banner -i $video1 -i $video2 -c:v prores -profile:v 3 -filter_complex `"$($filter)`" -map `"[v]`" `"$(Join-path (Get-Item $video1).DirectoryName -ChildPath (Get-Item $video1).BaseName)_lumakey.mov`"

********END FFMPEG COMMANDS********


"@
}
