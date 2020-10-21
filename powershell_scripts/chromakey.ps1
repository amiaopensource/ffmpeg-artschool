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

    [Parameter(Mandatory)]
    [ValidateSet("blue", "green", "red", "purple", "orange", "yellow")]
    $key = "green",

    [ValidateRange(0.01, 1)]
    [Decimal]
    $colorSim = 0.3,

    [ValidateRange(0, 1)]
    [Decimal]
    $colorBlend = 0.1
)

# Convert key color to hex code
Switch ($key)
{
    "blue" {$hexkey = "0000FF"}
    "green" {$hexkey = "00FF00"}
    "red" {$hexkey = "FF0000"}
    "purple" {$hexkey = "FF00FF"}
    "orange" {$hexkey = "FF9900"}
    "yellow" {$hexkey = "FFFF00"}
}


# Run ffmpeg command
ffmpeg.exe -i $v1 -i $v2 -c:v prores_ks -profile:v 3 -filter_complex "[1:v][0:v]scale2ref[v1][v0];[v1]chromakey=0x$hexkey:$colorSim:$colorBlend[1v];[v0][1v]overlay[v]" -map '[v]' "$((Get-Item $v1).Basename)_chromakey.mov"
