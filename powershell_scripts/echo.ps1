<#
.DESCRIPTION
    add trail effects to a video
.PARAMETER h
    display this help
.PARAMETER p
    previews in FFplay
.PARAMETER s
    saves to file with FFmpeg
.PARAMETER video
    path to the video
.PARAMETER echoRate
    echo rate in seconds. [default: 0.2]
.PARAMETER trailLength
    length of trails. [default: 2] 1 is a single trail, number increases exponentially with higher tail length
.PARAMETER echoMode
   preset blends between trails. [default: 1] 
   1: Normal mode, nice and balanced with evenly blending trails, but gets out of hand with a higher tail length.
   2: Screen mode, Works well with high contrast stuff but gets out of hand very quickly
   3: Phoenix mode, cool psychedelic effect
   4: Softlight mode, trails dissapapte very quickly, a subtle effect.
   5: Average mode, Similar to normal with slightly different colors.
   6: Heat mode, image is harshly affects.
   7: Xor mode, very cool strobing effect
   8: Difference mode, slightly less intense than xor but similar
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
    [ValidateRange(0, 1)]
    [Decimal]
    $echoRate = 0.2,
    
    [Parameter(Position=2, ParameterSetName="Run")]
    [ValidateRange(1, 10)]
    [Int]
    $trailLength = 2,

    [Parameter(Position=3, ParameterSetName="Run")]
    [ValidateRange(1, 8)]
    [Int]
    $echoMode = 1
)


# Display help

if (($h) -or ($PSBoundParameters.Values.Count -eq 0 -and $args.count -eq 0)){
    Get-Help $MyInvocation.MyCommand.Definition -detailed
    if (!$video1) {
        exit
    }
}


# Create filter string

Switch($echoMode)
{
    1 
    {
        $blendString="blend=all_mode=normal:c0_opacity=.5:c1_opacity=.5"
        $formatMode="yuv422p10le"
    }
    2
    {
        $blendString="blend=all_mode=screen"
        $formatMode="gbrp10le"
    }
    3
    {
        $blendString="blend=all_mode=phoenix"
        $formatMode="gbrp10le"
    }
    4
    {
        $blendString="blend=all_mode=softlight"
        $formatMode="gbrp10le"
    }
    5
    {
        $blendString="blend=all_mode=average:c0_opacity=.5:c1_opacity=.5"
        $formatMode="yuv422p10le"
    }
    6
    {
        $blendString="blend=all_mode=heat:c0_opacity=.75:c1_opacity=.25"
        $formatMode="yuv422p10le"
    }
    7
    {
        $blendString="blend=all_mode=xor"
        $formatMode="yuv422p10le"
    }
    8
    {
        $blendString="blend=all_mode=difference"
        $formatMode="gbrp10le"
    }
}


# Create filter
$ptsDelay = 0
$echoFeedback = ""

For ( $i=1; $i -le $trailLength; $i++ ){
    $ptsDelay = $ptsDelay + $echoRate
    $echoFeedback = "[wet]split[wet2Blend][wet2Feedback],[wet2Feedback]setpts=PTS+$ptsDelay/TB[wetFromFeedback];[wetFromFeedback]format=$formatMode[wetFromFeedback];[wetFromFeedback]format=$formatMode[wetFromFeedback];[wetFromFeedback][wet2Blend]$blendString[wet];" + $echoFeedback
}
   
$filter = "split[dry][toEcho];[toEcho]setpts=PTS+($echoRate/TB)[wet];$echoFeedback[wet]format=$formatMode[wet];[dry]format=$formatMode[dry];[wet][dry]$blendString[outRGB];[outRGB]format=yuv422p10le[v]"


# Run command

if ($p) {
    $tempFile = New-TemporaryFile
    ffmpeg.exe -hide_banner -stats -y -i $video -c:v prores -profile:v 3 -filter_complex $filter -map "[v]" -f matroska $tempFile
    ffplay.exe $tempFile
    Remove-Item $tempFile
    
    Write-Host @"


*******START FFPLAY COMMANDS*******

ffmpeg.exe -hide_banner -stats -y -i $video -c:v prores -profile:v 3 -filter_complex `"$($filter)`" -map `"[v]`" -f matroska $tempFile
ffplay $tempFile.FullName
Remove-Item $tempFile

********END FFPLAY COMMANDS********


"@
}
else {
    ffmpeg.exe -hide_banner -i $video -c:v prores -profile:v 3 -filter_complex $filter -map "[v]" "$(Join-path (Get-Item $video).DirectoryName -ChildPath (Get-Item $video).BaseName)_echo.mov"

    Write-Host @"


*******START FFMPEG COMMANDS*******

ffmpeg.exe -hide_banner -i $video -c:v prores -profile:v 3 -filter_complex `"$($filter)`" -map `"[v]`" `"$(Join-path (Get-Item $video).DirectoryName -ChildPath (Get-Item $video).BaseName)_echo.mov`"

********END FFMPEG COMMANDS********


"@
}
