<#
.DESCRIPTION
    performs a glitchy tblend on the input video file
.PARAMETER h
    display this help
.PARAMETER p
    previews in FFplay
.PARAMETER s
    saves to file with FFmpeg
.PARAMETER video
    path to the video
.PARAMETER blendMode
    one of 4 pre-defined trail filters [default: 1]
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
    [ValidateRange(1, 4)]
    [Int]
    $blendMode = 1
)


# Display help

if (($h) -or ($PSBoundParameters.Values.Count -eq 0 -and $args.count -eq 0)){
    Get-Help $MyInvocation.MyCommand.Definition -detailed
    if (!$video) {
        exit
    }
}


# Create filter string

Switch ($blendMode)
{
    1 {$filter = "scale=-2:720,tblend=all_mode=difference128,tblend=all_mode=difference128,tblend=all_mode=difference128,spp=4:10,tblend=all_mode=average,tblend=all_mode=difference128,tblend=all_mode=difference128,tblend=all_mode=difference128,spp=4:10,tblend=all_mode=average,tblend=all_mode=difference128,tblend=all_mode=difference128,tblend=all_mode=difference128,spp=4:10,tblend=all_mode=average,tblend=all_mode=difference128,tblend=all_mode=difference128,tblend=all_mode=difference128"}
    2 {$filter = "scale=-2:720,tblend=all_mode=difference128,tblend=all_mode=difference128,tblend=all_mode=difference128,spp=4:10,tblend=all_mode=average,tblend=all_mode=difference128,tblend=all_mode=difference128,tblend=all_mode=difference128,spp=4:10,tblend=all_mode=average,tblend=all_mode=difference128,tblend=all_mode=difference128,tblend=all_mode=difference128,spp=4:10,tblend=all_mode=average,tblend=all_mode=difference128,tblend=all_mode=difference128,tblend=all_mode=difference128,spp=4:10,tblend=all_mode=average,tblend=all_mode=difference128,tblend=all_mode=difference128,tblend=all_mode=difference128,spp=4:10,tblend=all_mode=average,tblend=all_mode=difference128,tblend=all_mode=difference128,tblend=all_mode=difference128,spp=4:10,tblend=all_mode=average,tblend=all_mode=difference128,tblend=all_mode=difference128,tblend=all_mode=difference128,spp=4:10,tblend=all_mode=average,tblend=all_mode=difference128,tblend=all_mode=difference128,tblend=all_mode=difference128,spp=4:10,tblend=all_mode=average,tblend=all_mode=difference128,tblend=all_mode=difference128,tblend=all_mode=difference128,spp=4:10,tblend=all_mode=average,tblend=all_mode=difference128,tblend=all_mode=difference128,tblend=all_mode=difference128,spp=4:10,tblend=all_mode=average,tblend=all_mode=difference128,tblend=all_mode=difference128,tblend=all_mode=difference128,spp=4:10,tblend=all_mode=average,tblend=all_mode=difference128,tblend=all_mode=difference128,tblend=all_mode=difference128,spp=4:10,tblend=all_mode=average,tblend=all_mode=difference128,tblend=all_mode=difference128,tblend=all_mode=difference128,spp=4:10,tblend=all_mode=average,tblend=all_mode=difference128,tblend=all_mode=difference128,tblend=all_mode=difference128,spp=4:10,tblend=all_mode=average,tblend=all_mode=difference128,tblend=all_mode=difference128,tblend=all_mode=difference128"}
    3 {$filter = "scale=-2:720,tblend=all_mode=difference,tblend=all_mode=difference,tblend=all_mode=difference,spp=4:10,tblend=all_mode=average,tblend=all_mode=difference,tblend=all_mode=difference,tblend=all_mode=difference,spp=4:10,tblend=all_mode=average,tblend=all_mode=difference,tblend=all_mode=difference,tblend=all_mode=difference,spp=4:10,tblend=all_mode=average,tblend=all_mode=difference,tblend=all_mode=difference,tblend=all_mode=difference"}
    4 {$filter = "scale=-2:720,tblend=all_mode=difference128,tblend=all_mode=average,tblend=all_mode=difference128,tblend=all_mode=average,tblend=all_mode=difference128,spp=4:10,tblend=all_mode=average,tblend=all_mode=difference128,tblend=all_mode=average,tblend=all_mode=difference128,tblend=all_mode=average,tblend=all_mode=difference128,spp=4:10,tblend=all_mode=average,tblend=all_mode=difference128,tblend=all_mode=average,tblend=all_mode=difference128,tblend=all_mode=average,tblend=all_mode=difference128,spp=4:10,tblend=all_mode=average,tblend=all_mode=difference128,tblend=all_mode=average,tblend=all_mode=difference128,tblend=all_mode=average,tblend=all_mode=difference128"}
}


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
    ffmpeg.exe -hide_banner -i $video -c:v prores -profile:v 3 -filter_complex $filter -map "[v]" "$(Join-path (Get-Item $video).DirectoryName -ChildPath (Get-Item $video).BaseName)_tblend_glitch.mov"

    Write-Host @"


*******START FFMPEG COMMANDS*******

ffmpeg.exe -hide_banner -i $video -c:v prores -profile:v 3 -filter_complex `"$($filter)`" -map `"[v]`" `"$(Join-path (Get-Item $video).DirectoryName -ChildPath (Get-Item $video).BaseName)_tblend_glitch.mov`"

********END FFMPEG COMMANDS********


"@
}
