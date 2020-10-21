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
    [Int]
    $repeats = 2
)

# Build list for concatenation
$tempFile = New-TemporaryFile

for ($i=1; $i -le $repeats; $i++)
{
    "file '$((Get-Item $v1).FullName)'" | Out-File -Encoding ASCII -Append $tempFile.FullName
}

# Run ffmpeg command
ffmpeg.exe -f concat -safe -0 -i $tempFile.FullName -c copy "$((Get-Item $v1).Basename)_looped_x$($repeats).$((Get-Item $v1).Extension)"
