<#
.DESCRIPTION
    Manipulate Y, U, and V bitplanes to make colorful creations
.PARAMETER h
    display this help
.PARAMETER p
    previews in FFplay
.PARAMETER s
    saves to file with FFmpeg
.PARAMETER video
    path to the video
.PARAMETER Y
    the part(s) of Y component to display, -1 for do not display, 0 for all bits, [1-8] for that specific bit position
.PARAMETER U
    the part(s) of U component to display, -1 for do not display, 0 for all bits, [1-8] for that specific bit positionthe number of bits of the U component to boost
.PARAMETER V
    the part(s) of V component to display, -1 for do not display, 0 for all bits, [1-8] for that specific bit position
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
    [ValidateRange(-1, 10)]
    [Int]
    $Y = $(Get-Random -Minimum -1 -Maximum 10),

    [Parameter(Position=2, ParameterSetName="Run")]
    [ValidateRange(-1, 10)]
    [Int]
    $U = $(Get-Random -Minimum -1 -Maximum 10),

    [Parameter(Position=3, ParameterSetName="Run")]
    [ValidateRange(-1, 10)]
    [Int]
    $V = $(Get-Random -Minimum -1 -Maximum 10)
)


# Display help

if (($h) -or ($PSBoundParameters.Values.Count -eq 0 -and $args.count -eq 0)){
    Get-Help $MyInvocation.MyCommand.Definition -detailed
    if (!$video) {
        exit
    }
}


# Create filter string

$filter = "format=yuv420p10le|yuv422p10le|yuv444p10le|yuv440p10le,lutyuv=y=if(eq($($Y)\,-1)\,512\,if(eq($($Y)\,0)\,val\,bitand(val\,pow(2\,10-$($Y)))*pow(2\,$($Y)))):u=if(eq($($U)\,-1)\,512\,if(eq($($U)\,0)\,val\,bitand(val\,pow(2\,10-$($U)))*pow(2\,$($U)))):v=if(eq($($V)\,-1)\,512\,if(eq($($V)\,0)\,val\,bitand(val\,pow(2\,10-$($V)))*pow(2\,$($V)))),format=yuv422p10le"


# Run command

if ($p) {
    $tempFile = New-TemporaryFile
    ffmpeg.exe -hide_banner -stats -y -i $video -c:v prores -profile:v 3 -filter_complex $filter -f matroska $tempFile
    ffplay.exe $tempFile
    Remove-Item $tempFile

    Write-Host @"


*******START FFPLAY COMMANDS*******

Y:$($Y)    U:$($U)    V:$($V)
ffmpeg.exe -hide_banner -stats -i $video -c:v prores -profile:v 3 -filter_complex `"$($filter)`" -f matroska $tempFile
ffplay $tempFile.FullName
Remove-Item $tempFile

********END FFPLAY COMMANDS********


"@
}
else {
    ffmpeg.exe -hide_banner -i $video -c:v prores -profile:v 3 -filter_complex $filter "$((Get-Item $video).Basename)_bitplane.mov"

    Write-Host @"


*******START FFMPEG COMMANDS*******

Y:$($Y)    U:$($U)    V:$($V)
ffmpeg.exe -hide_banner -i $video -c:v prores -profile:v 3 -filter_complex `"$($filter)`" `"$((Get-Item $video).Basename)_bitplane.mov`"

********END FFMPEG COMMANDS********


"@
}

