# Part 1 
# Sum of each groups unique yes answers

Set-StrictMode -Version latest
$ErrorActionPreference = "Stop"

# 
$inputData = Get-Content ".\day6\input.txt"



$gAnswers = @()
$groupNum = 0
foreach ($line in $inputData) {
    if ($line -eq "") {
        $groupNum++
    }
    else {
        $gAnswers += [pscustomobject]@{
            GroupNum = $groupNum
            pAnswers = $line
        }
    }
}


$totalSum = 0
$gAnswers | Group-Object GroupNum | Foreach-Object {
    $gUniqueAnswers = [System.Collections.Generic.HashSet[char]]::new()
    $_.Group.pAnswers.ToCharArray() | ForEach-Object {

        $null = $gUniqueAnswers.Add($_)
    }
    $totalSum += $gUniqueAnswers.Count 
}

Write-Host "Total unique answers (per group) is $totalSum"
