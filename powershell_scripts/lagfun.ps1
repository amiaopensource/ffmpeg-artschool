<#
.DESCRIPTION
    creates ghost trails using the lagfun effect
.PARAMETER h
    display this help
.PARAMETER p
    previews in FFplay
.PARAMETER s
    saves to file with FFmpeg
.PARAMETER video
    path to the video
.PARAMETER trailMode
    one of 3 pre-defined trail filters [default: 1]
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
    $trailMode = 1
)


# Display help

if (($h) -or ($PSBoundParameters.Values.Count -eq 0 -and $args.count -eq 0)){
    Get-Help $MyInvocation.MyCommand.Definition -detailed
    if (!$video) {
        exit
    }
}


# Create filter string

Switch ($trailMode)
{
    1 {$filter = "lagfun=decay=.95[v]"}
    2 {$filter = "format=gbrp10[formatted];[formatted]lagfun=decay=.95:planes=5,format=yuv422p10le[v]"}
    3 {$filter = "format=gbrp10[formatted];[formatted]split[a][b];[a]lagfun=decay=.99:planes=1[a];[b]lagfun=decay=.98:planes=2[b];[a][b]blend=all_mode=screen:c0_opacity=.5:c1_opacity=.5,format=yuv422p10le[v]"}
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
    ffmpeg.exe -hide_banner -i $video -c:v prores -profile:v 3 -filter_complex $filter -map "[v]" "$(Join-path (Get-Item $video).DirectoryName -ChildPath (Get-Item $video).BaseName)_lagfun.mov"

    Write-Host @"


*******START FFMPEG COMMANDS*******

ffmpeg.exe -hide_banner -i $video -c:v prores -profile:v 3 -filter_complex `"$($filter)`" -map `"[v]`" `"$(Join-path (Get-Item $video).DirectoryName -ChildPath (Get-Item $video).BaseName)_lagfun.mov`"

********END FFMPEG COMMANDS********


"@
}
