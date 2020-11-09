<#
.DESCRIPTION
    creates audio visualization overlay by blending video and audio using displace and showcqt
.PARAMETER h
    display this help
.PARAMETER p
    previews in FFplay
.PARAMETER s
    saves to file with FFmpeg
.PARAMETER audio
    path to the audio file
.PARAMETER video
    path to the video file
.NOTES
    Audio file must be the first argument, video file must be the second argument
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
    [System.IO.FileInfo]$audio,

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
    [System.IO.FileInfo]$video
)


# Display help

if (($h) -or ($PSBoundParameters.Values.Count -eq 0 -and $args.count -eq 0)){
    Get-Help $MyInvocation.MyCommand.Definition -detailed
    if (!$audio) {
        exit
    }
}


# Create filter string

$filter = "color=0x808080:s=720x480,format=rgb24,loop=-1:size=2[base];
   [0:a]showcqt=s=720x480:basefreq=73.41:endfreq=1567.98,format=rgb24,geq='p(X,363)',setsar=1,colorkey=black:similarity=0.1[vcqt];[base][vcqt]overlay,split[vcqt1][vcqt2];[1:v]scale=720x480,format=rgb24,setsar=1[bgv];[bgv][vcqt1][vcqt2]displace=edge=blank,format=yuv420p10le[v]"


# Run command

if ($p) {
    $tempFile = New-TemporaryFile
    ffmpeg.exe -hide_banner -stats -y -i $audio -i $video -c:v prores -profile:v 3 -filter_complex $filter -map "[v]" -map "0:a" -shortest -f matroska $tempFile
    ffplay.exe $tempFile
    
    Write-Host @"


*******START FFPLAY COMMANDS*******

ffmpeg.exe -hide_banner -stats -i $audio -i $video -c:v prores -profile:v 3 -filter_complex `"$($filter)`" -map `"[v]`" -map `"0:a`" -shortest -f matroska $tempFile`n"
ffplay $tempFile.FullName

********END FFPLAY COMMANDS********


"@
}
else {
    ffmpeg.exe -hide_banner -i $audio -i $video -c:v prores -profile:v 3 -filter_complex $filter -map "[v]" "$((Get-Item $audio).Basename)_audioviz.mov"

    Write-Host @"


*******START FFMPEG COMMANDS*******

ffmpeg.exe -hide_banner -i $audio -i $video -c:v prores -profile:v 3 -filter_complex `"$($filter)`" -map `"[v]`" `"$((Get-Item $audio).Basename)_audioviz.mov`"`n"

********END FFMPEG COMMANDS********


"@
}

