# Part 1 
# amount of unique colours that can contain a gold bag directly or indirectly

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

<#

function Add-BagToXml {
    [CmdletBinding()]
    param (
        [Parameter()]
        [object]
        $Bag,

        [Parameter()]
        [int]
        $BagQuantity,

        [Parameter()]
        [System.Xml.XmlNode]
        $ParentNode
    )

    end {
        $newElement = $ParentNode.OwnerDocument.CreateElement('Bag')

        $newAttribute = $xmlDoc.CreateAttribute('Name')
        $newAttribute.Value = $Bag.Name
        $null = $newElement.Attributes.Append($newAttribute)
        
        $newAttribute = $xmlDoc.CreateAttribute('Qty')
        $newAttribute.Value = $BagQuantity
        $null = $newElement.Attributes.Append($newAttribute)
        
        $null = $ParentNode.AppendChild($newElement)

        foreach ($key in $Bag.Contents.Keys) {
            Add-BagToXml -Bag $AllBagrules[$key] -BagQuantity $Bag.Contents[$key] -ParentNode $newElement
        }
    }
}


Write-Host "Create XML tree"

$xmlDoc = [xml]::new()
$rootElement = $xmlDoc.AppendChild( $xmlDoc.CreateElement("Bags") )


$AllBagrules.GetEnumerator() | ForEach-Object {
    Add-BagToXml -Bag $_.Value -BagQuantity 1 -ParentNode $rootElement
}

Write-Host "Using XPath: "
($xmlDoc.SelectNodes("/Bags/Bag[*//@Name='shiny gold']")).Count
#$xmlDoc.SelectNodes("/Bags//*[@Name='shiny gold']")


#>



Write-Host "Using code"
$lookups = [System.Collections.Generic.HashSet[string]]::new()
$lookups.Add('shiny gold')

$interestingBags = [System.Collections.Generic.HashSet[string]]::new()
while ($lookups.Count -gt 0) {
    $newlookup = [System.Collections.Generic.HashSet[string]]::new()
    foreach($lookup in $lookups) {
        $AllBagrules.GetEnumerator() | ForEach-Object { 
            if ($_.Value.Contents.Keys -contains $lookup) { 
                $null = $interestingBags.Add($_.Key)
                $null = $newlookup.Add($_.Key)
            }
        }
    }

    $lookups = $newlookup
    Write-Host " $($lookups.Count) new lookups. $($interestingBags.Count) found in total"
}


