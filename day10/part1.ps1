# Part 1 
# what is acc upon first time an instruction is executed second time
Set-StrictMode -Version latest
$ErrorActionPreference = "Stop"



# Lets try with the sample
$inputData = Get-Content ".\day10\input_sample.txt" | ForEach-Object { [int]$_ }

# Add 0 as the socket is always rated 0
# sort by size
$inputData += 0 
$inputData = $inputData | Sort-Object


$outObject = [pscustomobject]@{
    JumpsOfOne = 0
    JumpsOfTwo = 0
    JumpsOfThree = 0
}

for ($x = 1; $x -lt $inputData.Count; $x++) {
    $diff = $inputData[$x] - $inputData[$x-1]
    switch ($diff) {
        1 {$outObject.JumpsOfOne++; break}
        2 {$outObject.JumpsOfTwo++; break}
        3 {$outObject.JumpsOfThree++; break}
        default {throw 'Invalid Data'}
    }
}
# add device rated +3
$outObject.JumpsOfThree++

$outObject | Format-Table

Write-Host "jumps of one multiplied by jumps of three"
$outObject.JumpsOfOne * $outObject.JumpsOfThree



"---"
"---"
"---"
"---"

# Lets try with the sample
$inputData = Get-Content ".\day10\input.txt" | ForEach-Object { [int]$_ }

# Add 0 as the socket is always rated 0
# sort by size
$inputData += 0 
$inputData = $inputData | Sort-Object


$outObject = [pscustomobject]@{
    JumpsOfOne = 0
    JumpsOfTwo = 0
    JumpsOfThree = 0
}

for ($x = 1; $x -lt $inputData.Count; $x++) {
    $diff = $inputData[$x] - $inputData[$x-1]
    switch ($diff) {
        1 {$outObject.JumpsOfOne++; break}
        2 {$outObject.JumpsOfTwo++; break}
        3 {$outObject.JumpsOfThree++; break}
        default {throw 'Invalid Data'}
    }
}
# add device rated +3
$outObject.JumpsOfThree++ 
$outObject | Format-Table

Write-Host "jumps of one multiplied by jumps of three"
$outObject.JumpsOfOne * $outObject.JumpsOfThree