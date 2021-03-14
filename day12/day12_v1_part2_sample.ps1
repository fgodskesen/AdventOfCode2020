############
############ BEGIN
############

#Requires -Version 7
$ErrorActionPreference = "Stop"
$inputData = Get-Content ".\day12\input_sample.txt"

$vesselPosX = 0
$vesselPosY = 0
$waypointPosX = 10
$waypointPosY = 1


$step = 0
foreach ($line in $inputData) {
    $command = $line[0]
    $argument = $line.SubString(1)

    switch ($command) {
        'E' {
            $waypointPosX += $argument
            break
        }        
        'N' {
            $waypointPosY += $argument 
            break
        }
        'W' {
            $waypointPosX -= $argument
            break
        }
        'S' {
            $waypointPosY -= $argument
            break
        }
        'L' {
            for ($i = 1; $i -le ($argument / 90); ++$i) {
                $temp = $waypointPosX
                $waypointPosX = - $waypointPosY
                $waypointPosY = $temp
            }
            break
        }
        'R' {
            for ($i = 1; $i -le ($argument / 90); ++$i) {
                $temp = $waypointPosX
                $waypointPosX = $waypointPosY
                $waypointPosY = - $temp
            }
            break
        }
        'F' {
            $vesselPosX += [int]$argument * $waypointPosX
            $vesselPosY += [int]$argument * $waypointPosY
            break
        }
        default {
            throw 'NotImplemented'
            break
        }
    }

    ++$step
    Write-Host ("Step {0:000} - {1,-4} - VesselPos: {2:+000;-000},{3:+000;-000} - Waypoint: {4:+000;-000},{5:+000;-000} - Manhat: $([math]::Abs($vesselPosX) + [math]::Abs($vesselPosY))" -f $step, $line, $vesselPosX, $vesselPosY, $waypointPosX,$waypointPosY)
}