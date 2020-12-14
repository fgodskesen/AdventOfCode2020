# Part 2
# total amount of bags inside a shiny gold

Set-StrictMode -Version latest
$ErrorActionPreference = "Stop"

# 
$inputData = Get-Content ".\day7\input.txt"


class Bag {
    [string]$Name

    # Contents is a hashtable, where key is Bag Name, Value is [int] quantity. E.g. "gold" = 1
    [hashtable]$Contents

    Bag ([string]$Name) {
        $this.Name = $Name
        $this.Contents = @{}
    }
}



# Create HashTable with all bag colors. Key is bag name (= color). Value is a Bag object
$AllBagrules = @{}

# Parse input and convert to bag objects
$inputData | ForEach-Object {
    $regexOptions = '(?x)'   # set ignorewhitespace in pattern option
    $pattern = $regexOptions + "
    (?:^   # match everything
        (?<name>[a-z ]+)
        \s+bags\ contain\s+
        (
            \s*
            (?<qty>\d+)
            \s+
            (?<contains>[a-z ]+)
            \s+bags?(,|\.$)
        )*
    )"

    $rx = [regex]::Match($_, $pattern)
    $newBag = [Bag]::new($rx.Groups['name'].Value)

    for ($x = 0; $x -lt $rx.Groups['qty'].Captures.Count; $x++) {
        $newBag.Contents += @{
            $rx.Groups['contains'].Captures[$x].Value = $rx.Groups['qty'].Captures[$x].Value
        }
    }

    $null = $AllBagrules.Add(
        $newBag.Name,
        $newBag
    )
}





function Get-AllBags {
    [CmdletBinding()]
    param (
        [Parameter()]
        [object]
        $Bag,

        [Parameter()]
        [int]
        $BagQty
    )

    end {
        [pscustomobject]@{
            Name = $Bag.Name
            Qty = $BagQty
        }

        foreach ($key in $Bag.Contents.Keys) {
            Get-AllBags -Bag $AllBagrules[$key] -BagQty ($BagQty * $Bag.Contents[$key])
        }
    }
}


Write-Host "Add up all bags"


$allBagsInAGoldBag = $AllBagrules['shiny gold'] | ForEach-Object { 
    Get-AllBags -Bag $_ -BagQty 1
}


# Total qty is Sum - 1 (we do not count the outermost shiny gold bag)
$allBagsInAGoldBag | Measure-Object -Sum Qty
