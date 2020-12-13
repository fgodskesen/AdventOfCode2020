# Part 1 
# Sum of each groups yes answers where all members of the group answered yes

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
            pAnswers = [System.Collections.Generic.HashSet[char]]::new($line)
        }
    }
}



$totalSum = 0
$groups = $gAnswers | Group-Object GroupNum
$outObjects = @()
foreach ($grp in $groups) {
    $outObject = [pscustomobject]@{
        GroupNum = $grp.Name
        NumberOfMembers = $grp.Count
        AnswersGrouped = $grp.Group.pAnswers | Group-Object | Select-Object Name, Count | Sort-Object Name
    }
    $outObjects+= $outObject

}


foreach ($outObject in $outObjects) {
    $outObject.AnswersGrouped | ForEach-Object {
        if ($_.Count -eq $outObject.NumberOfMembers) {
            $totalSum++
        }
    }
}

Write-Host "Total answers where whole group answered yes is $totalSum"
