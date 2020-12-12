# Part 1 
# highest ID of any passport

$inputData = Get-Content ".\day5\input.txt"

function Get-SeatIDFromText {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [string[]]
        $Text
    )

    begin {}
    process {
        foreach ($inText in $Text) {
            # .NET type byte is an unsigned 8 bit integer, the text string is 10 bits long,
            # so we use a 16 bit uint to represent the ID instead
            $binaryText = $inText -replace ('B|R', 1) -replace ('F|L', 0)
            $binaryNum = [Convert]::ToUInt16($binaryText,2)
            
            [pscustomobject]@{
                Text = $inText
                Binary = $binaryText
                Integer = $binaryNum
            }
        }
    }
    end {}
}



$exists = [System.Collections.Generic.HashSet[uint16]]::new()
$inputData | Get-SeatIDFromText | ForEach-Object {
    $null = $exists.Add($_.Integer)
}

for ($x=0;$x -lt [Convert]::ToUInt16('1111111111',2); $x++) {
    if (-not $exists.Contains($x) -and $exists.Contains($x+1) -and $exists.Contains($x-1)) {
        Write-Host "My seat is $x"
    }
}



