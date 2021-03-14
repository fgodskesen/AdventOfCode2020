$day = 12


$AoCCookies = Import-PowerShellDataFile 'C:\users\flgod\OneDrive - DFDS\PoSH\GIT\adventcookie.psd1'

$session = [Microsoft.PowerShell.Commands.WebRequestSession]::new()
$AoCCookies.Keys | ForEach-Object {
    $cookie = [System.Net.Cookie]::new()
    $cookie.Name = $_
    $cookie.Value = $AoCCookies[$_]
    $cookie.Domain = "adventofcode.com"
    $session.Cookies.Add($cookie);
}



New-Item -ItemType Directory -Name "day$day" -force

$downloadToPath = ".\day$day\input.txt"
$remoteFileLocation = "https://adventofcode.com/2020/day/$day/input"
Invoke-WebRequest $remoteFileLocation -OutFile $downloadToPath -WebSession $session
