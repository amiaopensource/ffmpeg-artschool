<#
.DESCRIPTION
    reverses the input file
.PARAMETER h
    display this help
.PARAMETER s
    saves to file with FFmpeg
.PARAMETER video
    path to the video
.PARAMETER rotation
    rotation amount in degrees. [default: 180] Must be 90, 180, or 270
.PARAMETER stretch
    stretch to conform output to input aspect ratio. [default: 0] 1 for true, 0 for false
#>


# Parse arguments

Param(
    [Parameter(ParameterSetName="Help")]
    [Parameter(ParameterSetName="Run")]
    [Switch]
    $h,

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
    [ValidateSet(90, 180, 270)]
    $rotation = 180,

    [Parameter(Position=2, ParameterSetName="Run")]
    [ValidateRange(0, 1)]
    [Int]
    $stretch = 0
)


# Display help

if (($h) -or ($PSBoundParameters.Values.Count -eq 0 -and $args.count -eq 0)){
    Get-Help $MyInvocation.MyCommand.Definition -detailed
    if (!$video) {
        exit
    }
}


# Create filter string

Switch ($rotation)
{
    90 {$ffRotation = "transpose=2"}
    180 {$ffRotation = "transpose=2,transpose=2"}
    270 {$ffRotation = "transpose=2,transpose=2,transpose=2"}
}

if ($stretch -eq 0) {
    $filter = "$ffRotation,format=yuv422p10le"
}
else {
    $inputFrameSize = $(ffprobe -v error -select_streams v:0 -show_entries "stream=width,height" -of csv=s=x:p=0 $video) #gets input file dimensions
    $inputDAR = $(ffprobe -v error -select_streams v:0 -show_entries "stream=display_aspect_ratio" -of csv=s=x:p=0 $video) #gets input file display aspect ratio
    $filter = "$($ffRotation),scale=$($inputFrameSize -Split 'x' -Join ':'),setdar=$inputDAR,format=yuv422p10le"
}


# Run command

if ($p) {
    $tempFile = New-TemporaryFile
    ffmpeg.exe -hide_banner -stats -y -i $video -c:v prores -profile:v 3 -filter_complex $filter -f matroska $tempFile
    ffplay.exe $tempFile
    Remove-Item $tempFile
    
    Write-Host @"


*******START FFPLAY COMMANDS*******

ffmpeg.exe -hide_banner -stats -y -i $video -c:v prores -profile:v 3 -filter_complex $filter -f matroska $tempFile
ffplay $tempFile.FullName
Remove-Item $tempFile

********END FFPLAY COMMANDS********


"@
}
else {
    ffmpeg.exe -hide_banner -i $video -c:v prores -profile:v 3 -filter_complex $filter "$(Join-path (Get-Item $video).DirectoryName -ChildPath (Get-Item $video).BaseName)_rotate.mov"

    Write-Host @"


*******START FFMPEG COMMANDS*******

ffmpeg.exe -hide_banner -i $video -c:v prores -profile:v 3 -filter_complex $filter `"$(Join-path (Get-Item $video).DirectoryName -ChildPath (Get-Item $video).BaseName)_rotate.mov`"

********END FFMPEG COMMANDS********


"@
}
