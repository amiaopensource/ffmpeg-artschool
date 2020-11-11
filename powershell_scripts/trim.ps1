<#
.DESCRIPTION
    trims file based upon user-defined timestamps (HH:MM:SS)
.PARAMETER h
    display this help
.PARAMETER p
    previews in FFplay
.PARAMETER s
    saves to file with FFmpeg
.PARAMETER video
    path to the video
.PARAMETER begin
    timestamp of the input video to start the output video (HH:MM:SS)
.PARAMETER end
    timestamp of the input video to end the output video (HH:MM:SS)
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
    [ValidateScript({
        if(-Not ($_ -match "\d{2}:\d{2}:\d{2}") ){
            throw "Timestamp must be in the format HH:MM:SS\n"
        }
        return $true
    })]
    [String]$begin = "",

    [Parameter(Position=2, ParameterSetName="Run")]
    [ValidateScript({
        if(-Not ($_ -match "\d{2}:\d{2}:\d{2}") ){
            throw "Timestamp must be in the format HH:MM:SS\n"
        }
        return $true
    })]
    [String]$end = ""
)


# Display help

if (($h) -or ($PSBoundParameters.Values.Count -eq 0 -and $args.count -eq 0)){
    Get-Help $MyInvocation.MyCommand.Definition -detailed
    if (!$video) {
        exit
    }
}


# Create trim string

$trim = "-ss $begin -t $end"


# Run command

if ($p) {
    $tempFile = New-TemporaryFile
    ffmpeg.exe -hide_banner -stats -i $video $trim -f matroska $tempFile
    ffplay.exe $tempFile
    Remove-Item $tempFile
    
    Write-Host @"


*******START FFPLAY COMMANDS*******

ffmpeg.exe -hide_banner -stats -y -i $video $trim -f matroska $tempFile
ffplay $tempFile.FullName
Remove-Item $tempFile

********END FFPLAY COMMANDS********


"@
}
else {
    ffmpeg.exe -hide_banner -i $video $trim -c copy -map 0 "$(Join-path (Get-Item $video).DirectoryName -ChildPath (Get-Item $video).BaseName)_trim.mov"

    Write-Host @"


*******START FFMPEG COMMANDS*******

ffmpeg.exe -hide_banner -i $video $trim -c copy -map 0 `"$(Join-path (Get-Item $video).DirectoryName -ChildPath (Get-Item $video).BaseName)_trim.mov`"

********END FFMPEG COMMANDS********


"@
}

