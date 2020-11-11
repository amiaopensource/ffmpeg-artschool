<#
.DESCRIPTION
    Create visuals based on Conway's Game of Life
.PARAMETER h
    display this help
.PARAMETER p
    previews in FFplay
.PARAMETER s
    saves to file with FFmpeg
.PARAMETER size
    size of particles [default: medium] small, medium, large
.PARAMETER lifeColor
    the color of the simulation [default: yellow] blue, green, red, yello, purple, or orange
.PARAMETER deathColor
    the color of the death [default: red] blue, green, red, yello, purple, or orange
.PARAMETER rate
    the speed of movement [default: random] slow, medium, fast
.PARAMETER ratio
    the speed of movement [default: random] low, medium, high
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

    [Parameter(Position=0, ParameterSetName="Run")]
    [ValidateSet("small", "medium", "large")]
    [string]$size = "medium",

    [Parameter(Position=1, ParameterSetName="Run")]
    [ValidateSet("blue", "green", "red", "yellow", "orange", "purple")]
    [string]$lifeColor = "yellow",

    [Parameter(Position=2, ParameterSetName="Run")]
    [ValidateSet("blue", "green", "red", "yellow", "orange", "purple")]
    [string]$deathColor = "red",

    [Parameter(Position=3, ParameterSetName="Run")]
    [ValidateSet("slow", "medium", "fast")]
    [string]$rate = $(Get-Random -InputObject @("slow", "medium", "fast")),

    [Parameter(Position=4, ParameterSetName="Run")]
    [ValidateSet("low", "medium", "high")]
    [string]$ratio = $(Get-Random -InputObject @("low", "medium", "high"))
)


# Display help

if (($h) -or ($PSBoundParameters.Values.Count -eq 0 -and $args.count -eq 0)){
    Get-Help $MyInvocation.MyCommand.Definition -detailed
    if (!$video) {
        exit
    }
}


# Set size

Switch ($size)
{
    "small" {$ffSize = "320x240"}
    "medium" {$ffSize = "640x480"}
    "large" {$ffSize = "1280x960"}
}


# Set life color

Switch ($lifeColor)
{
    "blue" {$ffLifeColor="#0000FF"}
    "green" {$ffLifeColor="#00FF00"}
    "red" {$ffLifeColor="#C83232"}
    "purple" {$ffLifeColor="#9900FF"}
    "orange" {$ffLifeColor="#0099FF"}
    "yellow" {$ffLifeColor="#FFFF00"}
}

# Set death color

Switch ($deathColor)
{
    "blue" {$ffDeathColor="#0000FF"}
    "green" {$ffDeathColor="#00FF00"}
    "red" {$ffDeathColor="#C83232"}
    "purple" {$ffDeathColor="#9900FF"}
    "orange" {$ffDeathColor="#0099FF"}
    "yellow" {$ffDeathColor="#FFFF00"}
}


# Set rate

Switch ($rate)
{
    "slow" {$ffRate = 20}
    "medium" {$ffRate = 60}
    "fast" {$ffRate = 100}
}


# Set ratio

Switch ($ratio)
{
    "low" {$ffRatio = 1}
    "medium" {$ffRatio = 5}
    "high" {$ffRatio = 8}
}


# Create life string

$life_string = "life=s=$($ffSize):mold=10:r=$($ffRate):ratio=0.$($ffRatio):death_color=$($ffDeathColor):life_color=$($ffLifeColor),scale=640:480:flags=16"


# Run command

if ($p) {
    ffplay.exe -f lavfi -i $life_string
    
Write-Host @"


*******START FFPLAY COMMANDS*******

ffplay -f lavfi -i $life_string

********END FFPLAY COMMANDS********
Rate: $rate
Ratio: $ratio


"@
}
else {
    ffmpeg.exe -f lavfi -i $life_string,format=yuv422p10le -c:v prores -profile:v 3 -t 10 life.mov

Write-Host @"


*******START FFMPEG COMMANDS*******

ffmpeg.exe -f lavfi -i $($life_string),format=yuv422p10le -c:v prores -profile:v 3 -t 10 life.mov

********END FFMPEG COMMANDS********
Rate: $rate
Ratio: $ratio

"@
}

