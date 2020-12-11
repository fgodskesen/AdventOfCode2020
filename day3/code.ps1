# Part 1 
# how many trees do we pass on the way down.....

$inputData = Get-Content ".\day3\input.txt"

# zero indexed 
$columns = $inputData[0].Length
$rows = $inputData.Count - 1

$rnum = 0
$cnum = 0

$count = 0

while ($rnum -lt $rows) {
    if ($inputData[$rnum][$cnum] -eq '#') {
        $count++
    }

    $rnum++
    $cnum = ($cnum + 3) % $columns
}
$count
    




# Part 2
$slopes = @(
    @{R = 1; D = 1 }
    @{R = 3; D = 1 }
    @{R = 5; D = 1 }
    @{R = 7; D = 1 }
    @{R = 1; D = 2 }
)

$columns = $inputData[0].Length
$rows = $inputData.Count - 1

$multipliedResult = 1
foreach ($slope in $slopes) {
    $rnum = 0
    $cnum = 0
    $count = 0

    while ($rnum -lt $rows) {
        if ($inputData[$rnum][$cnum] -eq '#') {
            $count++
        }
            
        $rnum = $rnum + $slope.D
        $cnum = ($cnum + $slope.R) % $columns
    }

        $multipliedResult = $multipliedResult * $count
}
$multipliedResult

