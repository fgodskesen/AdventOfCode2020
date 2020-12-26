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
                $thisSeat = $Seating[$row, $col]
                $color = "Gray"
                if ($thisSeat.IsFloor) {
                    $char = "."
                    $color = "Gray"
                }
                elseif ($thisSeat.IsOccupied) {
                    $char = '#'
                }
                else {
                    $char = 'L'
                }
                Write-Host -Object $char -ForegroundColor $color -NoNewline
            }
            Write-Host ""
        }
    }
}


function Get-NeighbourCount {
    # foreach change in Changes, update Neighbours accordingly
    [CmdletBinding()]
    param (
        [Parameter()]
        [object[, ]]
        $Seating,

        # Row of changed cell
        [Parameter()]
        [int]
        $Row,

        # Column of changed cell
        [Parameter()]
        [int]
        $Column
    )
    end {
        $rowMax = $Seating.GetUpperBound(0)
        $colMax = $Seating.GetUpperBound(1)

        $thisSeat = $Seating[$Row, $Column]
        $slice = $thisSeat.Neighbours | ForEach-Object {
            , @($_.R, $_.C)
        }
        return ($Seating[$slice] | Where-Object { $_.IsOccupied }).Count
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

                if (!$thisSeat.IsFloor) {
                    $count = Get-NeighbourCount -Seating $Seating -Row $row -Column $col

                    if (!$thisSeat.IsOccupied -and $count -eq 0) {
                        # If a seat is empty (L) and there are no occupied seats adjacent to it, the seat becomes occupied.
                        $null = $changes.Add( @($row, $col, $true) )
                    }
                    elseif ($thisSeat.IsOccupied -and $count -ge 5) {
                        # If a seat is occupied (#) and four or more seats adjacent to it are also occupied, the seat becomes empty.
                        $null = $changes.Add( @($row, $col, $false) )
                    }
                }                    
                else {
                    # do nothing
                }
            }
        }

        
        # apply changes
        $changes.GetEnumerator() | Foreach-Object {
            $Seating[$_[0], $_[1]].IsOccupied = $_[2]
        }
        return $changes.Count
    }
}





############
############ BEGIN
############
$inputData = Get-Content ".\day11\input_sample.txt"

# create array as a true 2 dimensional array by adding comma in the [] and the two integers in the constructor indicating size
$Seating = [object[, ]]::new($inputData.Count, $inputData[0].Length)
for ($row = 0; $row -le $Seating.GetUpperBound(0); ++$row) {
    for ($col = 0; $col -le $Seating.GetUpperBound(1); ++$col ) {
        $Seating[$row, $col] = [pscustomobject]@{
            IsFloor    = ($inputdata[$row][$col] -eq ".") ? $true : $false
            IsOccupied = $false
            #IsOccupied = ($inputdata[$row][$col] -eq ".") ? $false : $true
            Neighbours = @()
        }
    }
}
# fill in coordinates of neighbours for each cell
for ($row = 0; $row -le $Seating.GetUpperBound(0); ++$row) {
    for ($col = 0; $col -le $Seating.GetUpperBound(1); ++$col ) {
        $seatNeighbours = [System.Collections.ArrayList]::new()

        # N
        for (
            $dist = 1;
            ($row - $dist) -ge 0;
            ++$dist) {
            if (!$Seating[($row - $dist), ($col)].IsFloor) {
                $null = $seatNeighbours.Add( [pscustomobject]@{ R = $row - $dist; C = $col })
                break
            }
        }

        # S
        for (
            $dist = 1;
            ($row + $dist) -le $Seating.GetUpperBound(0);
            ++$dist) {
            if (!$Seating[($row + $dist), ($col)].IsFloor) {
                $null = $seatNeighbours.Add( [pscustomobject]@{ R = $row + $dist; C = $col })
                break
            }
        }

        # W
        for (
            $dist = 1;
            ($col - $dist) -ge 0;
            ++$dist) {
            if (!$Seating[($row), ($col - $dist)].IsFloor) {
                $null = $seatNeighbours.Add( [pscustomobject]@{ R = $row; C = $col - $dist })
                break
            }
        }

        # E
        for (
            $dist = 1;
            ($col + $dist) -le $Seating.GetUpperBound(1);
            ++$dist) {
            if (!$Seating[($row), ($col + $dist)].IsFloor) {
                $null = $seatNeighbours.Add( [pscustomobject]@{ R = $row; C = $col + $dist })
                break
            }
        }

        # NW
        for (
            $dist = 1;
            $dist -le ([Math]::Min($row, $col));
            ++$dist) {
            if (!$Seating[($row - $dist), ($col - $dist)].IsFloor) {
                $null = $seatNeighbours.Add( [pscustomobject]@{ R = $row - $dist; C = $col - $dist })
                break
            }
        }

        # NE
        for (
            $dist = 1;
            $dist -le ([Math]::Min($row, ($Seating.GetUpperBound(1) - $col)));
            ++$dist) {
            if (!$Seating[($row - $dist), ($col + $dist)].IsFloor) {
                $null = $seatNeighbours.Add( [pscustomobject]@{ R = $row - $dist; C = $col + $dist })
                break
            }
        }


        # SW
        for (
            $dist = 1;
            $dist -le ([Math]::Min(($Seating.GetUpperBound(0) - $row), $col));
            ++$dist) {
            if (!$Seating[($row + $dist), ($col - $dist)].IsFloor) {
                $null = $seatNeighbours.Add( [pscustomobject]@{ R = $row + $dist; C = $col - $dist })
                break
            }
        }

        # SE
        for (
            $dist = 1;
            $dist -le ([Math]::Min(($Seating.GetUpperBound(0) - $row), ($Seating.GetUpperBound(1) - $col)));
            ++$dist) {
            if (!$Seating[($row + $dist), ($col + $dist)].IsFloor) {
                $null = $seatNeighbours.Add( [pscustomobject]@{ R = $row + $dist; C = $col + $dist })
                break
            }
        }
        $Seating[$row, $col].Neighbours = $seatNeighbours.ToArray()

    }
}



do {
    $changecount = Update-Seating -Seating $Seating
    #Update-Neighbours -Seating $Seating -ChangeRow 2 -ChangeCol 0 -OccupantAdded $true

    Invoke-PrintSeating -Seating $Seating
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