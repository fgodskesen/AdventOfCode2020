# Part 1 
# seating arrangement

#Requires -Version 7
$ErrorActionPreference = "Stop"


$inputData = Get-Content ".\day11\input_sample.txt"



$rowSum = $inputData.Count
$colSum = $inputData[0].Length


# create array as a true 2 dimensional array by adding comma in the [] and two numbers in the constructor indicating size
# as opposed to e.g.  [char[][]]::new($rowSum, $colSum) which would create a jagged array (each row could be different size)
$Seating = [char[, ]]::new($rowSum, $colSum)
for ($row = 0; $row -lt $rowSum; $row++) {
    for ($col = 0; $col -lt $colSum; $col++ ) {
        $Seating[$row, $col] = $inputData[$row][$col]
    }
}

$Neighbours = [int[, ]]::new($rowSum, $colSum)
for ($row = 0; $row -lt $rowSum; $row++ ) {
    for ($col = 0; $col -lt $colSum; $col++) {
        $Neighbours[$row, $col] = 0
    }
}


function Update-Neighbours {
    # foreach change in Changes, update Neighbours accordingly
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [int[, ]]
        $Neighbours,

        [Parameter(Position = 1)]
        [System.Collections.ArrayList]
        $Changes

    )
    end {
        $rowMax = $Neighbours.GetUpperBound(0)
        $colMax = $Neighbours.GetUpperBound(1)


        foreach ($change in $changes) {
            # single variable access is slightly faster than array or object property access
            $changerow = $change[0]
            $changecol = $change[1]
            $changeval = ($change[2] -eq '#') ? 1 : -1

            # N - S
            for (
                $row = [math]::Max(0, $changerow - 1);
                $row -le [math]::Min($rowMax, $changerow + 1);
                ++$row) {
                $Neighbours[$row, $changecol] += $changeval
            }

            # E - W
            for (
                $col = [math]::Max(0, $changecol - 1);
                $col -le [math]::Min($colMax, $changecol + 1);
                ++$col) {
                $Neighbours[$changerow, $col] += $changeval
            }

            # NW - SE

            $minOffSet = - [Math]::Min($changerow, $changecol)
            $maxOffset = [Math]::Min( ($rowMax - $changerow), ($colMax - $changecol) )
            for (
                $offset = [Math]::Max(-1, $minOffSet);
                $offset -le [Math]::Min(1, $maxOffset);
                ++$offset) {
                $Neighbours[($changerow + $offset), ($changecol + $offset)] += $changeval
            }
          
            # SW - NE
            $minOffSet = - [Math]::Min( ($rowMax - $changerow), $changecol)
            $maxOffset = [Math]::Min( $changerow, ($colMax - $changecol) )            
            for (
                $offset = [Math]::Max(-1, $minOffSet);
                $offset -le [Math]::Min(1, $maxOffset);
                ++$offset) {
                $Neighbours[($changerow - $offset), ($changecol + $offset)] += $changeval
            }

            # and adjust by 3 since we looped over [currentseat] 3 times
            $Neighbours[$changerow, $changecol] += - 4 * $changeval

            #Write-Host "[$changerow, $changecol] : $changeVal"
            #Write-Host ""
            
            #Invoke-PrintNCount $Neighbours
            #pause
        } # end foreach change
    }
}



function Invoke-PrintSeating {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [char[, ]]
        $Seating
    )

    begin {}
    process {}
    end {
        for ($row = 0; $row -le $Seating.GetUpperBound(0); $row++) {
            $slice = (0..$Seating.GetUpperBound(1)) | Foreach-Object {
                , @($row, $_)
            }
            Write-Host "$($Seating[$slice] -join ' ')"
        }
    }
}


function Invoke-PrintNCount {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [int[, ]]
        $Neighbours
    )

    begin {}
    process {}
    end {
        for ($row = 0; $row -le $Seating.GetUpperBound(0); $row++) {
            $slice = (0..$Seating.GetUpperBound(1)) | Foreach-Object {
                , @($row, $_)
            }
            Write-Host "$($Neighbours[$slice] -join ' ')"
        }
    }
}


function Update-Seating {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [char[, ]]
        $Seating,

        [Parameter(Mandatory)]
        [int[, ]]
        $Neighbours
    )

    begin {}
    process {}
    end {
        $changes = [System.Collections.ArrayList]::new()

        # generate new changes
        for ($row = 0; $row -le $Seating.GetUpperBound(0); $row++) {
            for ($col = 0; $col -le $Seating.GetUpperBound(1); $col++) {
                $thisSeat = $Seating[$row, $col]

                # if floor tile, do nothing
                if ($thisSeat -eq '.') {
                    continue
                }

                #If a seat is empty (L) and there are no occupied seats adjacent to it, the seat becomes occupied.
                if ($thisSeat -eq 'L' -and $Neighbours[$row, $col] -eq 0) {
                    $null = $changes.Add( @($row, $col, '#') )
                    continue
                }

                #If a seat is occupied (#) and four or more seats adjacent to it are also occupied, the seat becomes empty.
                if ($thisSeat -eq '#' -and $Neighbours[$row, $col] -ge 4) {
                    $null = $changes.Add( @($row, $col, 'L') )
                    continue
                }
            }
        }

        # apply all changes
        $changes.GetEnumerator() | Foreach-Object {
            $Seating[$_[0], $_[1]] = $_[2]
        }

        
        return ,$changes
    }
}










do {
    $changes = Update-Seating -Seating $Seating -Neighbours $Neighbours
    Update-Neighbours -Neighbours $Neighbours -Changes $changes
    #Invoke-PrintSeating $Seating
    #Invoke-PrintNCount $Neighbours

    Write-Host "changes : $($changes.Count)"
} while ($changes.Count -gt 0)



$seated = 0
for ($row = 0; $row -lt $Seating.GetUpperBound(0); ++$row) {
    for ($col = 0; $col -lt $Seating.GetUpperBound(1); ++$col) {
        if ($Seating[$row,$col] -eq '#') {
            $seated++
        }
    }
}
$seated