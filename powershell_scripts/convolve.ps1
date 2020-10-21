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
    [System.IO.FileInfo]$v2
)

# Run ffmpeg command
ffmpeg.exe -i $v1 -i $v2 -c:v prores_ks -profile:v 3 -filter_complex '[0:v][1:v]scale2ref[v0][v1];[v0]format=yuv422p10le[v0];[v1]format=yuv422p10le[v1];[v0][v1]convolve [out]' -map '[out]' "$((Get-Item $v1).Basename)_convolve.mov"
