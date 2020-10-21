# Parse arguments
Param(
    [Parameter(Position=0, Mandatory)]
    [ValidateScript({
        if(-Not ($_ | Test-Path) ){
            throw "File or folder does not exist" 
        }
        if(-Not ($_ | Test-Path -PathType Leaf) ){
            throw "The Path argument must be a file. Folder paths are not allowed."
        }
        return $true
    })]
    [System.IO.FileInfo]$v1,

    [Parameter(Position=1)]
    [ValidateRange(1, 7)]
    [Int]
    $trailMode = 1
)

Switch ($trailMode)
{
    1 {$filterComplex = "lagfun=decay=.95[out]"}
    2 {$filterComplex = "format=gbrp10[formatted];[formatted]lagfun=decay=.95:planes=5,format=yuv422p10le[out]"}
    3 {$filterComplex = "format=gbrp10[formatted];[formatted]split[a][b];[a]lagfun=decay=.99:planes=1[a];[b]lagfun=decay=.98:planes=2[b];[a][b]blend=all_mode=screen:c0_opacity=.5:c1_opacity=.5,format=yuv422p10le[out]"}
    4 {$filterComplex = "blend=all_mode=normal:c0_opacity=.5:c1_opacity=.5"}
    5 {$filterComplex = "blend=all_mode=normal:c0_opacity=.5:c1_opacity=.5"}
    6 {$filterComplex = "blend=all_mode=normal:c0_opacity=.5:c1_opacity=.5"}
    7 {$filterComplex = "blend=all_mode=normal:c0_opacity=.5:c1_opacity=.5"}
}


# Run ffmpeg command
ffmpeg.exe -i $v1 -c:v prores -profile:v 3 -filter_complex $filterComplex -map '[out]' "$((Get-Item $v1).Basename)_lagfun.mov"
