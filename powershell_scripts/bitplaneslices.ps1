<#
.DESCRIPTION
    Divide video into 10 Y channel bitplane slices, taken from QCTools
.PARAMETER h
    display this help
.PARAMETER p
    previews in FFplay
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
    [System.IO.FileInfo]$video
)


# Display help

if (($h) -or ($PSBoundParameters.Values.Count -eq 0 -and $args.count -eq 0)){
    Get-Help $MyInvocation.MyCommand.Definition -detailed
    if (!$video) {
        exit
    }
}


# Create filter string

$filter = "format=yuv420p10le|yuv422p10le|yuv444p10le|yuv440p10le,split=10[b0][b1][b2][b3][b4][b5][b6][b7][b8][b9];[b0]crop=iw/10:ih:(iw/10)*0:0,lutyuv=y=512:u=512:v=512:y=bitand(val\,pow(2\,10-1))*pow(2\,1)[b0c];[b1]crop=iw/10:ih:(iw/10)*1:0,lutyuv=y=512:u=512:v=512:y=bitand(val\,pow(2\,10-2))*pow(2\,2)[b1c];[b2]crop=iw/10:ih:(iw/10)*2:0,lutyuv=y=512:u=512:v=512:y=bitand(val\,pow(2\,10-3))*pow(2\,3)[b2c];[b3]crop=iw/10:ih:(iw/10)*3:0,lutyuv=y=512:u=512:v=512:y=bitand(val\,pow(2\,10-4))*pow(2\,4)[b3c];[b4]crop=iw/10:ih:(iw/10)*4:0,lutyuv=y=512:u=512:v=512:y=bitand(val\,pow(2\,10-5))*pow(2\,5)[b4c];[b5]crop=iw/10:ih:(iw/10)*5:0,lutyuv=y=512:u=512:v=512:y=bitand(val\,pow(2\,10-6))*pow(2\,6)[b5c];[b6]crop=iw/10:ih:(iw/10)*6:0,lutyuv=y=512:u=512:v=512:y=bitand(val\,pow(2\,10-7))*pow(2\,7)[b6c];[b7]crop=iw/10:ih:(iw/10)*7:0,lutyuv=y=512:u=512:v=512:y=bitand(val\,pow(2\,10-8))*pow(2\,8)[b7c]; [b8]crop=iw/10:ih:(iw/10)*8:0,lutyuv=y=512:u=512:v=512:y=bitand(val\,pow(2\,10-9))*pow(2\,9)[b8c];[b9]crop=iw/10:ih:(iw/10)*9:0,lutyuv=y=512:u=512:v=512:y=bitand(val\,pow(2\,10-10))*pow(2\,10)[b9c]; [b0c][b1c][b2c][b3c][b4c][b5c][b6c][b7c][b8c][b9c]hstack=10,format=yuv422p10le,drawgrid=w=iw/10:h=ih:t=2:c=cyan@1"


# Run command

if ($p) {
    ffplay.exe $video -vf $filter
    
    Write-Host @"


*******START FFPLAY COMMANDS*******

ffmpeg.exe -hide_banner -stats -i $input1 -i $input2 -c:v prores -profile:v 3 -filter_complex `"$($filter)`" -map `"[v]`" -f matroska $tempFile`n"
ffplay $tempFile.FullName

********END FFPLAY COMMANDS********


"@
}
else {
    ffmpeg.exe -hide_banner -i $video -c:v prores -profile:v 3 -filter_complex $filter "$((Get-Item $video).Basename)_bitslices.mov"

    Write-Host @"


*******START FFMPEG COMMANDS*******

ffmpeg.exe -hide_banner -i $video -c:v prores -profile:v 3 -filter_complex `"$($filter)`" `"$((Get-Item $video).Basename)_bitslices.mov`"`n"

********END FFMPEG COMMANDS********


"@
}

