# Part 1 
# how many passports are valid

$inputData = Get-Content ".\day4\input.txt"
$longString = ""
$inputData | ForEach-Object { $longString += "$_¤" }
$passportsRaw = $longString.Split('¤¤')

$ErrorActionPreference = "Stop"


# define properties of a passport
<#
class Passport {
    [string]$byr
    [string]$iyr
    [string]$eyr
    [string]$hgt
    [string]$hcl
    [string]$ecl
    [string]$pid
    [string]$cid
    
    
    Passport() {
        $this |Add-Member -Name IsValid -MemberType ScriptProperty -Value {
            # only cid is optional
            foreach ($prop in ($this | Get-Member -MemberType Property).Name) {
                if ($prop -notin @('cid') -and -not $this.$prop) {
                    return $false
                }
            }
            return $true
        } -SecondValue {
            throw "property is read-only"
        }
    }
}



$passports = @()
$passportsRaw | ForEach-Object {
    $passport = [Passport]::new()
    $_.Split(' ').Split('¤') | Where-Object {$_ -match '\S+'} | ForEach-Object {
        $key = $_.Split(':')[0]
        $value = $_.Split(':')[1]
        $passport.$key = $value
    }
    $passports += $passport
}

$passports | Out-GridView
$passports | ? IsValid |Measure-Object
#>








# Part 2
<#
byr (Birth Year) - four digits; at least 1920 and at most 2002.
iyr (Issue Year) - four digits; at least 2010 and at most 2020.
eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
hgt (Height) - a number followed by either cm or in:
If cm, the number must be at least 150 and at most 193.
If in, the number must be at least 59 and at most 76.
hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
pid (Passport ID) - a nine-digit number, including leading zeroes.
cid (Country ID) - ignored, missing or not.
#>


function Assert-PassportValidity {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline, Mandatory)]
        [Passport]
        $Passport
    )
    begin {}
    process {    }
    end {
        # only cid is optional
        foreach ($prop in ($Passport | Get-Member -MemberType Property).Name) {
            switch ($prop) {
                'byr' {
                    # four digits; at least 1920 and at most 2002.
                    if ($Passport.$prop -cnotmatch '^\d{4}$') { return $false }
                    elseif ($Passport.$prop -lt 1920 -or $Passport.$prop -gt 2002) { return $false }
                    break
                }
    
                'iyr' {
                    # four digits; at least 2010 and at most 2020.
                    if ($Passport.$prop -cnotmatch '^\d{4}$') { return $false }
                    elseif ($Passport.$prop -lt 2010 -or $Passport.$prop -gt 2020) { return $false }
                    break
                }
    
                'eyr' {
                    # four digits; at least 2020 and at most 2030.
                    if ($Passport.$prop -cnotmatch '^\d{4}$') { return $false }
                    elseif ($Passport.$prop -lt 2020 -or $Passport.$prop -gt 2030) { return $false }
                    break
                }
    
                'hgt' {
                    # a number followed by either cm or in:
                    # If cm, the number must be at least 150 and at most 193.
                    # If in, the number must be at least 59 and at most 76.

                    if ($Passport.$prop -cmatch "^\d+cm$") {
                        $ordinal = $Passport.$prop.TrimEnd('cm')
                        if ($ordinal -lt 150 -or $ordinal -gt 193) { return $false }
                    }
                    elseif ($Passport.$prop -cmatch "^\d+in$") {
                        $ordinal = $Passport.$prop.TrimEnd('in')
                        if ($ordinal -lt 59 -or $ordinal -gt 76) { return $false }
                    }
                    else {
                        return $false
                    }
                    break
                }
    
                'hcl' {
                    # followed by exactly six characters 0-9 or a-f.
                    if ($Passport.$prop -cnotmatch '^#[0-9a-f]{6}$') { return $false }
                    break
                }

                'ecl' {
                    # exactly one of: amb blu brn gry grn hzl oth.
                    if ($Passport.$prop -cnotmatch '^(amb|blu|brn|gry|grn|hzl|oth)$') { return $false }
                    break                    
                }
    
                'pid' {
                    # a nine-digit number, including leading zeroes.
                    if ($Passport.$prop -cnotmatch '^\d{9}$') { return $false }
                    break                    
                }

                'cid' {
                    #optional, just ignore
                    break
                }

                default {
                    throw "NotImplemented"
                    break
                }
    
            }
                
        }
        return $true
    }
}



class Passport {
    [string]$byr
    [string]$iyr
    [string]$eyr
    [string]$hgt
    [string]$hcl
    [string]$ecl
    [string]$pid
    [string]$cid
    
    
    Passport() {
        $this | Add-Member -Name IsValid -MemberType ScriptProperty -Value {
            $this | Assert-PassportValidity
        } -SecondValue {
            throw "property is read-only"
        }
    }
}



$passports = @()
$passportsRaw | ForEach-Object {
    $passport = [Passport]::new()
    $_.Split(' ').Split('¤') | Where-Object { $_ -match '\S+' } | ForEach-Object {
        $key = $_.Split(':')[0]
        $value = $_.Split(':')[1]
        $passport.$key = $value
    }
    $passports += $passport
}

$passport | Assert-PassportValidity

#$passports | Out-GridView
#$passports | ? IsValid | Measure-Object
