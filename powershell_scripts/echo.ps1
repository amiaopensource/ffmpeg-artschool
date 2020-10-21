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

    [ValidateRange(0, 1)]
    [Decimal]
    $echoRate = 0.1,

    [ValidateRange(1, 10)]
    [Int]
    $trails = 3


)

# Create echo filter
For ( $i=1; $i -le $trails; $i++ ){
    $echoFeedback="[wet]split[wet2Blend][wet2Feedback],[wet2Feedback]setpts=PTS+$echoRate/TB[wetFromFeedback];[wet2Blend]lutyuv=y=val*0.75[wet2Blend];[wetFromFeedback]lutyuv=y=val*0.50[wetFromFeedback];[wetFromFeedback][wet2Blend]blend=all_mode=screen[wet];"+$echoFeedback
}

$echoFilter="format=rgb24,split[dry][toEcho];[toEcho]setpts=PTS+$echoRate/TB[wet];$echoFeedback[dry]lutyuv=y=val*0.75[dry];[wet]lutyuv=y=val*0.50[wet];[wet][dry]blend=all_mode=screen,format=yuv422p10le[out]"

# Run ffmpeg command
ffmpeg.exe -i $v1 -c:v prores -profile:v 3 -filter_complex "$($echoFilter)" -map '[out]' "$((Get-Item $v1).Basename)_echo.mov"
