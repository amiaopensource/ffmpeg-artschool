<#
.DESCRIPTION
    Turn an input video file into a gif
.PARAMETER h
    display this help
.PARAMETER p
    previews in FFplay
.PARAMETER s
    saves to file with FFmpeg
.PARAMETER video
    path to the video
.PARAMETER quality
    select compromise between file size and quality level. [default: 0] 0 is more compressed at the cost of image quality. 1 is higher image quality at the cost of larger file size
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

    [Parameter(Position=2, ParameterSetName="Run")]
    [ValidateRange(0, 1)]
    [Int]
    $quality = 0
)


# Display help

if (($h) -or ($PSBoundParameters.Values.Count -eq 0 -and $args.count -eq 0)){
    Get-Help $MyInvocation.MyCommand.Definition -detailed
    if (!$video1) {
        exit
    }
}


# Create quality settings

if ($quality -eq 0){
    $paletteFilter="fps=10,scale=500:-1:flags=lanczos,palettegen=stats_mode=diff"
    $gifFilter="[0:v]fps=10,scale=500:-1:flags=lanczos[v],[v][1:v]paletteuse=dither=bayer:bayer_scale=5:diff_mode=rectangle"
}
elseif ($quality -eq 1) {
    $paletteFilter="fps=10,scale=500:-1:flags=lanczos,palettegen"
    $gifFilter="[0:v]fps=10,scale=500:-1:flags=lanczos[v],[v][1:v]paletteuse"
}

$palette = "$(Join-Path -Path (Split-Path -Path $video) -ChildPath palette.png)"



# Run command

ffmpeg -hide_banner -i $video -filter_complex $paletteFilter $palette
ffmpeg -hide_banner -i $video -i ${palette} -filter_complex $gifFilter "$((Get-Item $video).Basename).gif"
rm "${palette}"

Write-Host @"


*******START FFMPEG COMMANDS*******

ffmpeg -hide_banner -i $video -filter_complex $($paletteFilter) $palette
ffmpeg -hide_banner -i $video -i "${palette}" -filter_complex $gifFilter `"$((Get-Item $video).Basename).gif`"

********END FFMPEG COMMANDS********

"@
