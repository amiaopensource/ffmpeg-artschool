<#
.DESCRIPTION
    repeats/loops the input file as many times as requested
.PARAMETER h
    display this help
.PARAMETER s
    saves to file with FFmpeg
.PARAMETER video
    path to the video
.PARAMETER repeats 
    the number of times to loop the video [default: 2]
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
    [Int]
    $repeats = 2
)


# Display help

if (($h) -or ($PSBoundParameters.Values.Count -eq 0 -and $args.count -eq 0)){
    Get-Help $MyInvocation.MyCommand.Definition -detailed
    if (!$video) {
        exit
    }
}


# Create list for concatenation

$tempFile = New-TemporaryFile

for ($i=1; $i -le $repeats; $i++)
{
    "file '$((Get-Item $v1).FullName)'" | Out-File -Encoding ASCII -Append $tempFile.FullName
}


# Run ffmpeg command

ffmpeg.exe -f concat -safe -0 -i $tempFile.FullName -c copy "$((Get-Item $video).Basename)_looped_x$($repeats).$((Get-Item $video).Extension)"

Write-Host @"


*******START FFMPEG COMMANDS*******

ffmpeg.exe -f concat -safe -0 -i $($tempFile.FullName) -c copy `"$((Get-Item $video).Basename)_looped_x$($repeats).$((Get-Item $video).Extension)`"

********END FFMPEG COMMANDS********


"@
}
