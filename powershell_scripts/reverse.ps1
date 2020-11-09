<#
.DESCRIPTION
    reverses the input file
.PARAMETER h
    display this help
.PARAMETER s
    saves to file with FFmpeg
.PARAMETER video
    path to the video
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
    [System.IO.FileInfo]$video
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
    ffmpeg.exe -hide_banner -stats -y -i $video -c:v prores -profile:v 3 -vf reverse -f matroska $tempFile
    ffplay.exe $tempFile
    
    Write-Host @"


*******START FFPLAY COMMANDS*******

ffmpeg.exe -hide_banner -stats -y -i $video -c:v prores -profile:v 3 -vf reverse -f matroska $tempFile
ffplay $tempFile.FullName

********END FFPLAY COMMANDS********


"@
}
else {
    ffmpeg.exe -hide_banner -i $video -c:v prores -profile:v 3 -vf reverse "$((Get-Item $video).Basename)_reverse.mov"

    Write-Host @"


*******START FFMPEG COMMANDS*******

ffmpeg.exe -hide_banner -i $video -c:v prores -profile:v 3 -vf reverse `"$((Get-Item $video).Basename)_reverse.mov`"

********END FFMPEG COMMANDS********


"@
}
