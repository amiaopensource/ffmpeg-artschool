<#
.DESCRIPTION
    creates a mosaic of videos
.PARAMETER h
    display this help
.PARAMETER p
    previews in FFplay
.PARAMETER s
    saves to file with FFmpeg
.PARAMETER videos
    path to the videos
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
    [System.IO.FileInfo[]]$videos
)


# Display help

if (($h) -or ($PSBoundParameters.Values.Count -eq 0 -and $args.count -eq 0)){
    Get-Help $MyInvocation.MyCommand.Definition -detailed
    if (!$video) {
        exit
    }
}


# Create filter string
$leastRoot = [Math]::Ceiling([Math]::Sqrt($videos.Length))
$leastSquare = [Math]::Pow($leastRoot, 2)

$inputString = ""
$filterString = ""
$xstackString = ""
$layoutString = ""
if ($leastSquare -ge 16) {
    $tileRes = "qqvga"
}
else {
    $tileRes = "qvga"
}

For ( $i=0; $i -lt $leastSquare; $i++ ) {

    ### SCRAMBLER???
    if ($i -ge $videos.Length) {
        $inputString = "$inputString -f lavfi -i color=color=black:s=320x240"
    }
    else {
        $inputString = "$inputString -i $($videos[$i])"
    }
    $filterString = "$filterString[$($i):v]setpts=PTS-STARTPTS,scale=$tileRes[a$i];"
    $xstackString = "$xstackString[a$i]"

    # write layout
    $column = [Math]::Floor($i/ $leastRoot)
    $row = $i % $leastRoot
    $rowIndex = ""
    For ( $j=$row; $j -ge 0; $j-- ) {
        if  ($rowIndex -eq "") {
            if ($j -eq 0) {
                $rowIndex = "0"
            }
            else {
                $rowIndex = "w$($j-1)"
            } 
        }
        else {
            if ($j -eq 0) {
                continue
            }
            else {
                $rowIndex = "w$($j-1)+$rowIndex"
            }
        }
    }
    $colIndex = ""
    For ( $j=$column; $j -ge 0; $j-- ) {
        if  ($colIndex -eq "") {
            if ($j -eq 0) {
                $colIndex = "0"
            }
            else {
                $colIndex = "h$($j-1)"
            } 
        }
        else {
            if ($j -eq 0) {
                continue
            }
            else {
                $colIndex = "h$($j-1)+$colIndex"
            }
        }
    }
    if ($layoutString -eq "") {
        $layoutString = "$($rowIndex)_$($colIndex)"
    }
    else {
        $layoutString = "$layoutString|$($rowIndex)_$($colIndex)"
    }
}

$filter = "$filterString$($xstackString)xstack=inputs=$($leastSquare):$layoutString[v]"


# Run command

if ($p) {
    $tempFile = New-TemporaryFile
    ffmpeg.exe -hide_banner -stats $inputString -c:v prores -profile:v 3 -filter_complex $filter -map "[v]" -f matroska $tempFile
    ffplay.exe $tempFile
    
    Write-Host @"


*******START FFPLAY COMMANDS*******

ffmpeg.exe -hide_banner -stats -y $video -c:v prores -profile:v 3 -filter_complex $filter -map "[v]" -f matroska $tempFile
ffplay $tempFile.FullName

********END FFPLAY COMMANDS********


"@
}
else {
    ffmpeg -hide_banner $inputString -c:v prores -profile:v 3 -filter_complex "$filter" -map "[v]" "xstack.mov"

    Write-Host @"


*******START FFMPEG COMMANDS*******
needs -vsync 2 -t 10 
ffmpeg -hide_banner $inputString -c:v prores -profile:v 3 -vsync 2 -t 10 -filter_complex '$filter' -map "[v]" "xstack.mov"

********END FFMPEG COMMANDS********


"@
}

