<#
.DESCRIPTION
    Corrupts a file using Bitstream Filter Noise
.PARAMETER h
    display this help
.PARAMETER p
    previews in FFplay
.PARAMETER s
    saves to file with FFmpeg
.PARAMETER video
    path to the video
.PARAMETER corruption
    the percentage of corruption added. 0 is no error and 1 is all error. Anything above 0.5 will likely not play
.PARAMETER keepTemp
    whether to delete or keep the temporary intermediate file. [default: 0] 0 to delete, 1 to keep. The temp file is really finnicky. You only want to keep it if you're ready for how wonky it can be.
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
    $corruption = 0.1,

    [Parameter(Position=2, ParameterSetName="Run")]
    [ValidateRange(0, 1)]
    [Int]
    $keepTemp = 0
)


# Display help

if (($h) -or ($PSBoundParameters.Values.Count -eq 0 -and $args.count -eq 0)){
    Get-Help $MyInvocation.MyCommand.Definition -detailed
    if (!$video) {
        exit
    }
}


# Run command

if ($p) {
    $tempFile = New-TemporaryFile
    ffmpeg.exe -hide_banner -stats -y -i $video -c copy -bsf noise=$corruption -f matroska $tempFile
    ffplay.exe $tempFile
    
    Write-Host @"


*******START FFPLAY COMMANDS*******

ffmpeg.exe -hide_banner -stats -y -i $video -c copy -bsf noise=$($corruption) -f matroska $tempFile
ffplay $tempFile.FullName

********END FFPLAY COMMANDS********


"@
}
else {
    $tempFile = "$((Get-Item $video).Basename)_corruptor_temp.mov"
    ffmpeg.exe -hide_banner -i $video -c copy -bsf noise=$corruption -y $tempFile
    ffmpeg.exe -i $tempFile -c:v prores -profile:v 3 -y "$((Get-Item $video).Basename)_corruptor.mov"

    Write-Host @"


*******START FFMPEG COMMANDS*******

ffmpeg.exe -hide_banner -i $video -c copy -bsf noise=$($corruption) -y `"$($tempFile)`"
ffmpeg.exe -i `"$($tempFile)`" -c:v prores -profile:v 3 -y `"$((Get-Item $video).Basename)_corruptor.mov`"

********END FFMPEG COMMANDS********


"@

    if ($keepTemp -eq 1) {
        rm $tempFile
    }
}