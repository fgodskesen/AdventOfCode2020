# Part 1 
# what is acc upon first time an instruction is executed second time
Set-StrictMode -Version latest
$ErrorActionPreference = "Stop"


function Test-Preamble {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [int64]
        $Number,

        [Parameter(Mandatory)]
        [int64[]]
        $Preamble
    )
    end {
        for ($x = 0; $x -lt ($Preamble.Count - 1); $x++) {
            for ($y = $x + 1; $y -lt $Preamble.Count; $y++) {
                if (($Preamble[$x] + $Preamble[$y]) -eq $Number) {
                    return $true
                }
            }
        }
        return $false
    }
}




# Lets try with the sample
$inputData = Get-Content ".\day9\input_sample.txt" | ForEach-Object { [int64]$_ }

$preambleLength = 5
for ($x = $preambleLength; $x -lt $inputData.Count; $x++) {
    $preamble = $inputData[($x - $preambleLength)..($x - 1)]
    if (-not (Test-Preamble -Number $inputData[$x] -Preamble $preamble)) {
        Write-Host "Number at position $x : $($inputData[$x]) failed preamble test."
        Write-Host "Preamble: $($preamble -join ',')"
    }
}



""
""
""

# And with actual input
$inputData = Get-Content ".\day9\input.txt" | ForEach-Object { [int64]$_ }

$preambleLength = 25
for ($x = $preambleLength; $x -lt $inputData.Count; $x++) {
    $preamble = $inputData[($x - $preambleLength)..($x - 1)]
    if (-not (Test-Preamble -Number $inputData[$x] -Preamble $preamble)) {
        Write-Host "Number at position $x : $($inputData[$x]) failed preamble test."
        Write-Host "Preamble: $($preamble -join ',')"
        break
    }
}