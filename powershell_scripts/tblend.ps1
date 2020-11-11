<#
.DESCRIPTION
    applies the tblend filter with arbitrary blend mode
.PARAMETER h
    display this help
.PARAMETER p
    previews in FFplay
.PARAMETER s
    saves to file with FFmpeg
.PARAMETER video
    path to the video
.PARAMETER blendMode
    type of blend mode to use. Options include: addition, addition128, 
    grainmerge, and, average, burn, darken, difference, difference128, grainextract,
    divide, dodge, freeze, exclusion, extremity, glow, hardlight, hardmix, heat,
    lighten, linearlight, multiply, multiply128, negation, normal, or, overlay,
    phoenix, pinlight, reflect, screen, softlight, subtract, vividlight, xor   
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
    [ValidateSet("addition", "addition128", "grainmerge", "and", "average", "burn", "darken", "difference", "difference128", "grainextract",
    "divide", "dodge", "freeze", "exclusion", "extremity", "glow", "hardlight", "hardmix", "heat",
    "lighten", "linearlight", "multiply", "multiply128", "negation", "normal", "or", "overlay",
    "phoenix", "pinlight", "reflect", "screen", "softlight", "subtract", "vividlight", "xor")]
    [string]$blendMode = "addition128"
)


# Display help

if (($h) -or ($PSBoundParameters.Values.Count -eq 0 -and $args.count -eq 0)){
    Get-Help $MyInvocation.MyCommand.Definition -detailed
    if (!$video) {
        exit
    }
}


# Create filter string

$filter = "format=gbrp10le,tblend=all_mode=$($blendMode),format=yuv422p10le"


# Run command

if ($p) {
    $tempFile = New-TemporaryFile
    ffmpeg.exe -hide_banner -stats -y -i $video -c:v prores -profile:v 3 -vf $filter -f matroska $tempFile
    ffplay.exe $tempFile
    Remove-Item $tempFile
    
    Write-Host @"


*******START FFPLAY COMMANDS*******

ffmpeg.exe -hide_banner -stats -y -i $video -c:v prores -profile:v 3 -vf `"$($filter)`" -f matroska $tempFile
ffplay $tempFile.FullName
Remove-Item $tempFile

********END FFPLAY COMMANDS********


"@
}
else {
    ffmpeg.exe -hide_banner -i $video -c:v prores -profile:v 3 -vf $filter "$(Join-path (Get-Item $video).DirectoryName -ChildPath (Get-Item $video).BaseName)_tblend_$($blendMode).mov"

    Write-Host @"


*******START FFMPEG COMMANDS*******

ffmpeg.exe -hide_banner -i $video -c:v prores -profile:v 3 -vf `"$($filter)`" `"$(Join-path (Get-Item $video).DirectoryName -ChildPath (Get-Item $video).BaseName)_tblend_$($blendMode).mov`"

********END FFMPEG COMMANDS********


"@
}

