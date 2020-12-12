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



$inputData | Get-SeatIDFromText | select -first 10 | Format-Table

$inputData | Get-SeatIDFromText | Measure-Object Integer -Maximum
