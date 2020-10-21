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
    [ValidateRange(0, 1)]
    [Decimal]
    $corruption = 0.1,

    [Parameter(Position=2)]
    [ValidateRange(0, 1)]
    [Int]
    $keepTemp = 0


)


# Run ffmpeg command for temp file
ffmpeg.exe -i $v1 -c copy -bsf noise=$corruption -y "$((Get-Item $v1).Basename)_corruptor_temp.mov"
# Run ffmpeg command for final file
ffmpeg.exe -i "$((Get-Item $v1).Basename)_corruptor_temp.mov" -c:v prores -profile:v 3 -y "$((Get-Item $v1).Basename)_corruptor.mov"

# Delete temp file
if ($keepTemp -eq 0)
{
    rm "$((Get-Item $v1).Basename)_corruptor_temp.mov"
}
