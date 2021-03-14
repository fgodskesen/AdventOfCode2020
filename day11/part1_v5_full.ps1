# Part 1 
# seating arrangement

#Requires -Version 7
$ErrorActionPreference = "Stop"



function Invoke-PrintSeating {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [object[, ]]
        $Seating
    )

    begin {}
    process {}
    end {
        for ($row = 0; $row -lt $Seating.GetUpperBound(0); $row++) {
            for ($col = 0; $col -lt $Seating.GetUpperBound(1); $col++) {
                if ($Seating[$row, $col].IsFloor) {
                    $char = " ."

                    $color = "Gray"
                }
                else {
                    $char = ($Seating[$row, $col].Neighbours).ToString().PadLeft(2, ' ')
                    if ($Seating[$row, $col].IsOccupied) {
                        $color = "Green"
                    }
                    else {
                        $color = "Yellow"
                    }
                }
                Write-Host -Object $char -ForegroundColor $color -NoNewline
                
            }
            Write-Host ""
        }
    }
}


function Update-Neighbours {
    # foreach change in Changes, update Neighbours accordingly
    [CmdletBinding()]
    param (
        [Parameter()]
        [object[, ]]
        $Seating,

        # Row of changed cell
        [Parameter()]
        [int]
        $ChangeRow,

        # Column of changed cell
        [Parameter()]
        [int]
        $ChangeCol,

        # Column of changed cell
        [Parameter()]
        [bool]
        $OccupantAdded
    )
    end {
        $rowMax = $Seating.GetUpperBound(0)
        $colMax = $Seating.GetUpperBound(1)

        $changeval = ($OccupantAdded) ? 1 : -1

        # N - S
        for (
            $row = [math]::Max(0, $changerow - 1);
            $row -le [math]::Min($rowMax, $changerow + 1);
            ++$row) {
            $Seating[$row, $changecol].Neighbours += $changeval
        }

        # E - W
        for (
            $col = [math]::Max(0, $changecol - 1);
            $col -le [math]::Min($colMax, $changecol + 1);
            ++$col) {
            $Seating[$changerow, $col].Neighbours += $changeval
        }

        # NW - SE

        $minOffSet = - [Math]::Min($changerow, $changecol)
        $maxOffset = [Math]::Min( ($rowMax - $changerow), ($colMax - $changecol) )
        for (
            $offset = [Math]::Max(-1, $minOffSet);
            $offset -le [Math]::Min(1, $maxOffset);
            ++$offset) {
            $Seating[($changerow + $offset), ($changecol + $offset)].Neighbours += $changeval
        }

        # SW - NE
        $minOffSet = - [Math]::Min( ($rowMax - $changerow), $changecol)
        $maxOffset = [Math]::Min( $changerow, ($colMax - $changecol) )            
        for (
            $offset = [Math]::Max(-1, $minOffSet);
            $offset -le [Math]::Min(1, $maxOffset);
            ++$offset) {
            $Seating[($changerow - $offset), ($changecol + $offset)].Neighbours += $changeval
        }

        $Seating[$changerow, $changecol].Neighbours += - 4 * $changeval        
    } # end foreach change
}


function Update-Seating {
    [CmdletBinding()]
    param (
        [Parameter()]
        [object[, ]]
        $Seating
    )

    begin {}
    process {}
    end {
        $changes = [System.Collections.ArrayList]::new()

        # generate new changes
        for ($row = 0; $row -le $Seating.GetUpperBound(0); $row++) {
            for ($col = 0; $col -le $Seating.GetUpperBound(1); $col++) {
                $thisSeat = $Seating[$row, $col]

                if ($thisSeat.IsFloor) {
                    # if floor tile, do nothing
                }
                elseif (!$thisSeat.IsOccupied -and $thisSeat.Neighbours -eq 0) {
                    # If a seat is empty (L) and there are no occupied seats adjacent to it, the seat becomes occupied.
                    $null = $changes.Add( @($row, $col, $true) )
                }
                elseif ($thisSeat.IsOccupied -and $thisSeat.Neighbours -ge 4) {
                    # If a seat is occupied (#) and four or more seats adjacent to it are also occupied, the seat becomes empty.
                    $null = $changes.Add( @($row, $col, $false) )
                }
                else {
                    # do nothing
                }
            }
        }

        
        # apply changes
        $changes.GetEnumerator() | Foreach-Object {
            $Seating[$_[0], $_[1]].IsOccupied = $_[2]
            Update-Neighbours -Seating $Seating -ChangeRow $_[0] -ChangeCol $_[1] -OccupantAdded $_[2]
        }
        return $changes.Count
    }
}



$inputData = Get-Content ".\day11\input.txt"




# create array as a true 2 dimensional array by adding comma in the [] and the two integers in the constructor indicating size
$Seating = [object[, ]]::new($inputData.Count, $inputData[0].Length)
for ($row = 0; $row -le $Seating.GetUpperBound(0); ++$row) {
    for ($col = 0; $col -le $Seating.GetUpperBound(1); ++$col ) {
        $Seating[$row, $col] = [pscustomobject]@{
            IsFloor    = ($inputdata[$row][$col] -eq ".") ? $true : $false
            IsOccupied = $false
            Neighbours = [byte]0
        }
    }
}




do {
    $changecount = Update-Seating -Seating $Seating
    #Update-Neighbours -Seating $Seating -ChangeRow 2 -ChangeCol 0 -OccupantAdded $true

    #Invoke-PrintSeating -Seating $Seating
    Write-Host "$changecount Changes"
} while ($changecount)






""
$seated = [int]0
for ($row = 0; $row -le $Seating.GetUpperBound(0); ++$row) {
    for ($col = 0; $col -le $Seating.GetUpperBound(1); ++$col) {
        if ($Seating[$row, $col].IsOccupied) {
            $seated++
        }
    }
}
Write-Host "Total seated: $seated"