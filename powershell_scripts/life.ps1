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
.PARAMETER color
    the color of the simulation [default: yellow] blue, green, red, yello, purple, or orange
.PARAMETER death_color
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
    [string]$color = "yellow",

    [Parameter(Position=2, ParameterSetName="Run")]
    [ValidateSet("blue", "green", "red", "yellow", "orange", "purple")]
    [string]$death_color = "red",

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
    "small" {$ff_size = "320x240"}
    "medium" {$ff_size = "640x480"}
    "large" {$ff_size = "1280x960"}
}


# Set life color

Switch ($color)
{
    "blue" {$ff_color="#0000FF"}
    "green" {$ff_color="#00FF00"}
    "red" {$ff_color="#C83232"}
    "purple" {$ff_color="#9900FF"}
    "orange" {$ff_color="#0099FF"}
    "yellow" {$ff_color="#FFFF00"}
}

# Set death color

Switch ($death_color)
{
    "blue" {$ff_death_color="#0000FF"}
    "green" {$ff_death_color="#00FF00"}
    "red" {$ff_death_color="#C83232"}
    "purple" {$ff_death_color="#9900FF"}
    "orange" {$ff_death_color="#0099FF"}
    "yellow" {$ff_death_color="#FFFF00"}
}


# Set rate

Switch ($rate)
{
    "slow" {$ff_rate = 20}
    "medium" {$ff_rate = 60}
    "fast" {$ff_rate = 100}
}


# Set ratio

Switch ($ratio)
{
    "low" {$ff_ratio = 1}
    "medium" {$ff_ratio = 5}
    "high" {$ff_ratio = 8}
}


# Create life string

$life_string = "life=s=$($ff_size):mold=10:r=$($ff_rate):ratio=0.$($ff_ratio):death_color=$($ff_death_color):life_color=$($ff_color),scale=640:480:flags=16"


# Run command

if ($p) {
    $tempFile = New-TemporaryFile
    ffmpeg.exe -f lavfi -i $life_string,format=yuv422p10le -c:v prores -profile:v 3 -t 10 $tempFile
    ffplay.exe $tempFile
    
Write-Host @"


*******START FFPLAY COMMANDS*******

ffmpeg.exe -f lavfi -i $($life_string),format=yuv422p10le -c:v prores -profile:v 3 -t 10 $tempFile
ffplay $tempFile.FullName

********END FFPLAY COMMANDS********


"@
}
else {
    ffmpeg.exe -f lavfi -i $life_string,format=yuv422p10le -c:v prores -profile:v 3 -t 10 life.mov

Write-Host @"


*******START FFMPEG COMMANDS*******

ffmpeg.exe -f lavfi -i $($life_string),format=yuv422p10le -c:v prores -profile:v 3 -t 10 life.mov

********END FFMPEG COMMANDS********


"@
}

