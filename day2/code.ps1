

$inputData = Get-Content ".\day2\input.txt" | ConvertFrom-Csv -Header "Times", "Letter", "Pwd" -Delimiter " "



# Part 1
$inputData | ForEach-Object {
    $_ | Add-Member -MemberType NoteProperty -Name "Min" -Value ($_.times.Split("-")[0])
    $_ | Add-Member -MemberType NoteProperty -Name "Max" -Value ($_.times.Split("-")[1])
    $_.Letter = $_.Letter.TrimEnd(":")
    $_ | Add-Member -MemberType NoteProperty -Name "MatchCount" -Value $( ($_.Pwd | Select-String -Pattern $_.Letter -AllMatches).Matches.Count )
    $_ | Add-Member -MemberType NoteProperty -Name "Valid" -Value $( $_.MatchCount -ge $_.Min -and $_.MatchCount -le $_.Max )
}

$inputData | select  Pwd, letter, min, max, MatchCount, valid | Out-GridView

($inputData | ? Valid).Count



# Part 2 - exactly one of the positions must contain the specified letter
$inputData = Get-Content ".\day2\input.txt" | ConvertFrom-Csv -Header "Times", "Letter", "Pwd" -Delimiter " "
$outputData = @()
foreach ($row in $inputData) {
    $outObj = [pscustomobject]@{
        Pwd = $row.Pwd
        Letter = $row.Letter.TrimEnd(':')
        Pos1 = $row.Times.Split("-")[0] - 1
        Pos2 = $row.Times.Split("-")[1] - 1
        Pos1Val = ""
        Pos2Val = ""
        Valid = $false
    }    
    $outObj.Pos1Val = $row.Pwd[$outObj.Pos1]
    $outObj.Pos2Val = $row.Pwd[$outObj.Pos2]
    $outObj.Valid = [bool]($outObj.Pos1Val -eq $outObj.Letter -xor $outObj.Pos2Val -eq $outObj.Letter)
    $outputData += $outObj
}
$outputData | Out-GridView
($outputData | ? Valid).Count

$inputData | Out-GridView