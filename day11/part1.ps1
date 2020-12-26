# Part 1 
# seating arrangement
Set-StrictMode -Version latest
$ErrorActionPreference = "Stop"



# Lets try with the sample
$inputData = Get-Content ".\day11\input_sample.txt"

$rowSum = $inputData.Count
$colSum = $inputData[0].Length


$floorMatrix = [bool[][]]::new($rowSum, $colSum)
$seatingMatrix = [bool[][]]::new($rowSum, $colSum)
for ($i = 0; $i -lt $rowSum; $i++) {
    for ($j = 0; $j -lt $colSum; $j++) {
        $floorMatrix[$i][$j] = [bool]($inputData[$i][$j] -ne '.')
        $seatingMatrix[$i][$j] = 0
    }
}


function Get-Neighbours {
    # return amount of seats occupied at the 8 possible positions around [RowNum][ColNum]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [bool[][]]
        $Seating,

        [Parameter(Mandatory, Position = 1)]
        [int]
        $RowNum,

        [Parameter(Mandatory, Position = 2)]
        [int]
        $ColNum
    )
    end {
        $hits = 0

        for ($row = $RowNum - 1; $row -le $RowNum + 1; $row++) {

            # skip column if it is out of bounds
            if ($row -lt 0 -or $row -ge $Seating.Count) { continue }
            
            for ($col = $ColNum - 1; $col -le $ColNum + 1; $col++) {
                # and skip row if that is out of bounds
                if ($col -lt 0 -or $col -ge $Seating[0].Count) { continue }

                # skip if we are looking at the persons own seat
                if ($row -eq $RowNum -and $col -eq $ColNum) { continue }

                if ($Seating[$row][$col]) {
                    $hits++
                }
            }
        }
        $hits
    }
}


function Update-Seating {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [bool[][]]
        $Seating,

        [Parameter(Mandatory)]
        [bool[][]]
        $FloorTiles
    )

    begin {
    }

    end {
        # add changes to a new list and apply afterwards as they are all applied simultaneously
        # will contain objects where elements are 
        # @($row, $col, newValueOfSeat)
        $changes = [System.Collections.ArrayList]::new()

        for ($row = 0; $row -lt $Seating.Count; $row++) {
            for ($col = 0; $col -lt $Seating[0].Count; $col++) {
                # if this is a floor tile, continue
                if ($FloorTiles[$row][$col]) {
                    continue
                }

                # get info about current seat
                $adjacentSeats = Get-Neighbours -Seating $Seating -RowNum $row -ColNum $col
                $thisSeat = $Seating[$row][$col]

                #If a seat is empty (L) and there are no occupied seats adjacent to it, the seat becomes occupied.
                if (-not $thisSeat -and $adjacentSeats -eq 0) {
                    $null = $changes.Add(
                        [pscustomobject]@{
                            Row      = $row
                            Col      = $col
                            NewValue = $true
                        }
                    )
                    continue
                }

                #If a seat is occupied (#) and four or more seats adjacent to it are also occupied, the seat becomes empty.
                if ($thisSeat -and $adjacentSeats -ge 4) {
                    $null = $changes.Add(
                        [pscustomobject]@{
                            Row      = $row
                            Col      = $col
                            NewValue = $false
                        }
                    )
                    continue
                }

                #Otherwise, the seat's state does not change.
            }
        }

        # apply changes
        $changes.GetEnumerator() | ForEach-Object {
            $Seating[$_.Row][$_.Col] = $_.NewValue
        }
        return $changes.Count
    }
}




$x = 0
do {
    $x++
    $changeNum = Update-Seating -Seating $seatingMatrix -FloorTiles $floorMatrix
    Write-Host "Iteration $x : $changeNum changes"
} while ($changeNum -gt 0)


# count occupied seats
$occupiedSeats = 0
$lines = @()
for ($row = 0; $row -lt $SeatingMatrix.Count; $row++) {
    $line = ""
    for ($col = 0; $col -lt $SeatingMatrix[0].Count; $col++) {
        if ($floorMatrix[$row][$col]) {
            $line += "."
        } elseif ($seatingMatrix[$row][$col]) {
            $line += "#"
            $occupiedSeats++
        } else {
            $line += "L"
        }
    }
    $lines += $line
}
$occupiedSeats
$lines




