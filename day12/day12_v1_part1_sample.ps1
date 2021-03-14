############
############ BEGIN
############

#Requires -Version 7
$ErrorActionPreference = "Stop"
$inputData = Get-Content ".\day12\input_sample.txt"


$xpos = 0
$ypos = 0
$heading = 0


foreach ($line in $inputData) {
    $command = $line[0]
    $argument = $line.SubString(1)

    switch($command) {
        {$_ -eq 'E' -or ($_ -eq 'F' -and $heading -eq 0)} {
            $xpos += $argument
            break
        }        
        {$_ -eq 'N' -or ($_ -eq 'F' -and $heading -eq 90)} {
            $ypos += $argument 
            break
        }
        {$_ -eq 'W' -or ($_ -eq 'F' -and $heading -eq 180)} {
            $xpos -= $argument
            break
        }
        {$_ -eq 'S' -or ($_ -eq 'F' -and $heading -eq 270)} {
            $ypos -= $argument
            break
        }
        'L' {
            $heading = ($heading + $argument) % 360
            break
        }
        'R' {
            $heading = ($heading - $argument + 360) % 360
            break
        }
        default {
            throw 'NotImplemented'
            break
        }
    }

    Write-Host "X: $xpos - Y: $ypos - Bearing: $heading "
}

Write-Host "Manhattan distance: $([math]::Abs($xpos) + [math]::Abs($ypos))"