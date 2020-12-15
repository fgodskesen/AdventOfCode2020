# Part 1 
# what is acc upon first time an instruction is executed second time
Set-StrictMode -Version latest
$ErrorActionPreference = "Stop"



# logic: consider each adapter a node
# each connection a vertex
# nodes can then be connected to either 1, 2 or three other nodes backwards
# since nodes are ordered and unique, and we never move backwards
# we can recursively calculate the amount of different ways to get to a given node by adding the amount of ways we can get to the three possible preceding nodes.




# Lets try with the small sample
$inputData = Get-Content ".\day10\input_sample_small.txt" | ForEach-Object { [int]$_ }

# Add 0 as the socket is always rated 0
$inputData += 0

# sort by size
$inputData = $inputData | Sort-Object

# Add device which is max + 3
$inputData += $inputData[-1] + 3

# Array of same length containing amount of paths from [0] to the given node
$sums = (0..($inputData.Count - 1)) | Foreach-Object { 0 }

#we can always get to the outlet. 
$sums[0] = 1
for ($x = 1; $x -lt $inputData.Count; $x++) {
    if ($inputData[$x-1] -ge $inputData[$x] - 3) {
        $sums[$x] += $sums[$x-1]
    }
    if ($inputData[$x-2] -ge $inputData[$x] - 3) {
        $sums[$x] += $sums[$x-2]
    }
    if ($inputData[$x-3] -ge $inputData[$x] - 3) {
        $sums[$x] += $sums[$x-3]
    }
}

Write-Host "Pathwalking on small sample"
(0..($sums.Count - 1)) | % {
    Write-Host " $($inputData[$_]) - $($sums[$_]) "
}




""
""
""
""


# Lets try with the small sample
$inputData = Get-Content ".\day10\input_sample.txt" | ForEach-Object { [int]$_ }

# Add 0 as the socket is always rated 0
$inputData += 0

# sort by size
$inputData = $inputData | Sort-Object

# Add device which is max + 3
$inputData += $inputData[-1] + 3

# Array of same length containing amount of paths from [0] to the given node
$sums = (0..($inputData.Count - 1)) | Foreach-Object { 0 }

#we can always get to the outlet. 
$sums[0] = 1
for ($x = 1; $x -lt $inputData.Count; $x++) {
    if ($inputData[$x-1] -ge $inputData[$x] - 3) {
        $sums[$x] += $sums[$x-1]
    }
    if ($inputData[$x-2] -ge $inputData[$x] - 3) {
        $sums[$x] += $sums[$x-2]
    }
    if ($inputData[$x-3] -ge $inputData[$x] - 3) {
        $sums[$x] += $sums[$x-3]
    }
}

Write-Host "Pathwalking on larger sample"
(0..($sums.Count - 1)) | % {
    Write-Host " $($inputData[$_]) - $($sums[$_]) "
}




""
""
""
""


# Lets try with the small sample
$inputData = Get-Content ".\day10\input.txt" | ForEach-Object { [int]$_ }

# Add 0 as the socket is always rated 0
$inputData += 0

# sort by size
$inputData = $inputData | Sort-Object

# Add device which is max + 3
$inputData += $inputData[-1] + 3

# Array of same length containing amount of paths from [0] to the given node
$sums = (0..($inputData.Count - 1)) | Foreach-Object { 0 }

#we can always get to the outlet. 
$sums[0] = 1
for ($x = 1; $x -lt $inputData.Count; $x++) {
    if ($inputData[$x-1] -ge $inputData[$x] - 3) {
        $sums[$x] += $sums[$x-1]
    }
    if ($inputData[$x-2] -ge $inputData[$x] - 3) {
        $sums[$x] += $sums[$x-2]
    }
    if ($inputData[$x-3] -ge $inputData[$x] - 3) {
        $sums[$x] += $sums[$x-3]
    }
}

Write-Host "Pathwalking on actual input"
(0..($sums.Count - 1)) | % {
    Write-Host " $($inputData[$_]) - $($sums[$_]) "
}
