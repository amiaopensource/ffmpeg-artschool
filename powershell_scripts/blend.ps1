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
    [ValidateSet("addition", "addition128", "grainmerge", "and", "average", "burn", "darken", "difference", "difference128", "grainextract",
    "divide", "dodge", "freeze", "exclusion", "extremity", "glow", "hardlight", "hardmix", "heat",
    "lighten", "linearlight", "multiply", "multiply128", "negation", "normal", "or", "overlay",
    "phoenix", "pinlight", "reflect", "screen", "softlight", "subtract", "vividlight", "xor")]
    $mode
)

# Run ffmpeg command
ffmpeg.exe -i $v1 -i $v2 -c:v prores_ks -profile:v 3 -filter_complex "[1:v]format=yuv422p10le[v1];[0:v]format=yuv422p10le[v0];[v1][v0]scale2ref[v1][v0];[v0][v1]blend=all_mode=$($mode) [out]" -map '[out]' "$((Get-Item $v1).Basename)_blend_$($mode).mov"
