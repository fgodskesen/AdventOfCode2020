

$inputData = Get-Content ".\input.txt" | ForEach-Object { [int]($_) } | Sort-Object

# Part 1 - find two numbers whose sum is 2020
$sums = @()
for ($x = 0; $x -lt $inputData.Count - 1; $x++) {
    for ($y = $x + 1; $y -lt $inputData.Count; $y++) {
        $thisSum = $inputData[$x] + $inputData[$y]
        #$thisSum
        if ($thisSum -eq 2020) {
            $sums += $inputData[$x], $inputData[$y]
        }
    }
}

$sums[0] * $sums[1]




# Part two - find three numbers whose sum is 2020

$sums = @()
:x for ($x = 0; $x -lt $inputData.Count - 2; $x++) {
    :y for ($y = $x + 1; $y -lt $inputData.Count - 1; $y++) {
        :z for ($z = $y + 1; $z -lt $inputData.Count; $z++) {
            $thisSum = $inputData[$x] + $inputData[$y] + $inputData[$z]
            if ($thisSum -eq 2020) {
                $sums += $inputData[$x], $inputData[$y], $inputData[$z], $x,$y,$z

            }
            elseif ($thisSum -gt 2020) {
                continue y
            }
        }
    }
}

$sums[0]*$sums[1]*$sums[2]