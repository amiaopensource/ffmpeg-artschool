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

    [Parameter(Position=1, Mandatory)]
    [ValidateScript({
        if(-Not ($_ | Test-Path) ){
            throw "File or folder does not exist" 
        }
        if(-Not ($_ | Test-Path -PathType Leaf) ){
            throw "The Path argument must be a file. Folder paths are not allowed."
        }
        return $true
    })]
    [System.IO.FileInfo]$v2,

    [Parameter(Position=2)]
    [ValidateRange(0, 1)]
    [Decimal]
    $thresh = 0,

    [Parameter(Position=3)]
    [ValidateRange(0, 1)]
    [Decimal]
    $tol = 0.1,

    [Parameter(Position=4)]
    [ValidateRange(0, 1)]
    [Decimal]
    $soft = 0.2
)

# Build filter string
$filterComplex = "[0:v][1:v]scale2ref[v0][v1];[v1]lumakey=threshold=$($thresh):tolerance=$($tol):softness=$($soft)[1v];[v0][1v]overlay,format=yuv422p10le[v]"

# Run ffmpeg command
ffmpeg.exe -i $v2 -i $v1 -c:v prores -profile:v 3 -filter_complex $filterComplex -map '[v]' "$((Get-Item $v1).Basename)_lumakey.mov"
