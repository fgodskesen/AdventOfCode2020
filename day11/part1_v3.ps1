# Part 1 
# seating arrangement

#Requires -Version 7
$ErrorActionPreference = "Stop"


enum SeatState {
    Floor
    Free
    Occupied
}

$inputData = Get-Content ".\day11\input.txt"

$rowSum = $inputData.Count
$colSum = $inputData[0].Length

$Seating = [SeatState[][]]::new($rowSum, $colSum)
for ($row = 0; $row -lt $rowSum ; $row++) {
    for ($col = 0; $col -lt $colSum ; $col++) {
        $Seating[$row][$col] = ($inputData[$row][$col] -eq 'L') ? [SeatState]::Free :[SeatState]::Floor
    }
}







function Get-Neighbours {
    # return amount of seats occupied at the 8 possible positions around [RowNum][ColNum]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [SeatState[][]]
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

        $rowBegin = [math]::Max(0, $RowNum - 1)
        $rowEnd = [math]::Min($Seating.Count - 1, $RowNum + 1)
        $colBegin = [math]::Max(0, $ColNum - 1)
        $colEnd = [math]::Min($Seating[0].Count - 1, $ColNum + 1)


        for ($row = $rowBegin; $row -le $rowEnd; $row++) {
            for ($col = $colBegin; $col -le $colEnd; $col++) {
                # skip if we are looking at "self"
                if ($row -eq $RowNum -and $col -eq $ColNum) { continue }

                if ($Seating[$row][$col] -eq [SeatState]::Occupied) {
                    $hits++
                }
            }
        }
        $hits
    }
}

function Invoke-PrintSeating {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [SeatState[][]]
        $Seating,

        [Parameter(Mandatory, Position = 1)]
        [hashtable]
        $Changes
    )

    begin {}
    process {}
    end {
        $rowSum = $Seating.Count
        $colSum = $Seating[0].Count
    
        for ($row = 0; $row -lt $rowSum ; $row++) {
            for ($col = 0; $col -lt $colSum ; $col++) { 
                $color = $changes.Contains("$($row),$($col)") ? 'Green' : 'Gray'

                switch ($Seating[$row][$col]) {
                    { $_ -eq [SeatState]::Floor } { 
                        Write-Host "." -NoNewLine -ForeGroundColor $color
                        break
                    }
                    { $_ -eq [SeatState]::Free } { 
                        Write-Host "L" -NoNewLine -ForeGroundColor $color
                        break
                    }
                    { $_ -eq [SeatState]::Occupied } { 
                        Write-Host "#" -NoNewLine -ForeGroundColor $color
                        break 
                    }
                    default { break }
                }
            } 
            Write-Host ""
        }
    }
}



function Update-Seating {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [SeatState[][]]
        $Seating
    )

    begin {}
    process {}

    end {
        $changes = @{}


        # generate new changes
        for ($row = 0; $row -lt $Seating.Count; $row++) {
            for ($col = 0; $col -lt $Seating[0].Count; $col++) {
                $thisSeat = $Seating[$row][$col]

                # if floor tile, do nothing
                if ($thisSeat -eq [SeatState]::Floor) {
                    continue
                }


                # Get amount of neighbours
                $adjacentSeats = Get-Neighbours -Seating $Seating -RowNum $row -ColNum $col

                #If a seat is empty (L) and there are no occupied seats adjacent to it, the seat becomes occupied.
                if ($thisSeat -eq [SeatState]::Free -and $adjacentSeats -eq 0) {
                    $null = $changes.Add("$($row),$($col)", [SeatState]::Occupied)
                    continue
                }

                #If a seat is occupied (#) and four or more seats adjacent to it are also occupied, the seat becomes empty.
                if ($thisSeat -eq [SeatState]::Occupied -and $adjacentSeats -ge 4) {
                    $null = $changes.Add("$($row),$($col)", [SeatState]::Free)
                    continue
                }

                #Otherwise, the seat's state does not change.
            }
        }

        # apply all changes
        $changes.Keys.GetEnumerator() | Foreach-Object {
            $rc = $_ -split ","
            $Seating[$rc[0]][$rc[1]] = $changes[$_]
        }

        return $changes
    }
}





""
do {
    $changes = Update-Seating -Seating $Seating
    #Invoke-PrintSeating -Seating $Seating -Changes $changes
    Write-Host "changes : $($changes.Count)"
} while ($changes.Count -gt 0)


$occupied = 0
# cound occupied
for ($row = 0; $row -lt $Seating.Count; $row++) {
    for ($col = 0; $col -lt $Seating[0].Count; $col++) {
        if ($Seating[$row][$col] -eq [SeatState]::Occupied) {
            $occupied++
        }
    }
}
Write-Host "Number of occupied seats: $occupied"