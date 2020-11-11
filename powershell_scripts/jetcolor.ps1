<#
.DESCRIPTION
    uses pseudocolor to create a "jet color" effect
.PARAMETER h
    display this help
.PARAMETER p
    previews in FFplay
.PARAMETER s
    saves to file with FFmpeg
.PARAMETER video
    path to the video
.PARAMETER mode
    one of 3 modes [default: 1]
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
    [ValidateRange(1, 3)]
    [Int]
    $mode = 1
)


# Display help

if (($h) -or ($PSBoundParameters.Values.Count -eq 0 -and $args.count -eq 0)){
    Get-Help $MyInvocation.MyCommand.Definition -detailed
    if (!$video) {
        exit
    }
}


# Create filter string

Switch ($mode)
{
    1 {$modeSelect = 0}
    2 {$modeSelect = 1}
    3 {$modeSelect = 2}
}

$filter = "format=gbrp10le,eq=brightness=0.40:saturation=8,pseudocolor='if(between(val,0,85),lerp(45,159,(val-0)/(85-0)),if(between(val,85,170),lerp(159,177,(val-85)/(170-85)),if(between(val,170,255),lerp(177,70,(val-170)/(255-170))))):if(between(val,0,85),lerp(205,132,(val-0)/(85-0)),if(between(val,85,170),lerp(132,59,(val-85)/(170-85)),if(between(val,170,255),lerp(59,100,(val-170)/(255-170))))):if(between(val,0,85),lerp(110,59,(val-0)/(85-0)),if(between(val,85,170),lerp(59,127,(val-85)/(170-85)),if(between(val,170,255),lerp(127,202,(val-170)/(255-170))))):i=$modeSelect',format=yuv422p10le"


# Run command

if ($p) {
    $tempFile = New-TemporaryFile
    ffmpeg.exe -hide_banner -stats -y -i $video -c:v prores -profile:v 3 -vf -f matroska $tempFile
    ffplay.exe $tempFile
    Remove-Item $tempFile
    
    Write-Host @"


*******START FFPLAY COMMANDS*******

ffmpeg.exe -hide_banner -stats -y -i $video -c:v prores -profile:v 3 -vf `"$($filter)`" -f matroska $tempFile
ffplay $tempFile.FullName
Remove-Item $tempFile

********END FFPLAY COMMANDS********


"@
}
else {
    ffmpeg.exe -hide_banner -i $video -c:v prores -profile:v 3 -vf $filter "$(Join-path (Get-Item $video).DirectoryName -ChildPath (Get-Item $video).BaseName)_jetcolor.mov"

    Write-Host @"


*******START FFMPEG COMMANDS*******

ffmpeg.exe -hide_banner -i $video -c:v prores -profile:v 3 -vf `"$($filter)`" `"$(Join-path (Get-Item $video).DirectoryName -ChildPath (Get-Item $video).BaseName)_jetcolor.mov`"

********END FFMPEG COMMANDS********


"@
}
