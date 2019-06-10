$packageName = "$($env:chocolateyPackageName)"
# This function is from the chocolatey-core.extension package (https://chocolatey.org/packages/chocolatey-core.extension)
# Example: choco upgrade ht_SousChef --params="/InstallDir:'c:\program files\Huron\PIT_Tools\ht_SousChef'" -y
function Get-PackageParameters([string] $Parameters = $Env:ChocolateyPackageParameters) {
    $res = @{}

    $re = "\/([a-zA-Z0-9]+)(:([`"'])?([a-zA-Z0-9- _\\:\.]+)([`"'])?)?" #"
    $results = $Parameters | Select-String $re -AllMatches | select -Expand Matches
    foreach ($m in $results) {
        if (!$m) { continue } # must because of posh 2.0 bug: https://github.com/chocolatey/chocolatey-coreteampackages/issues/465

        $a = $m.Value -split ':'
        $opt = $a[0].Substring(1); $val = $a[1..100] -join ':'
        if ($val -match '^(".+")|(''.+'')$') {$val = $val -replace '^.|.$'}
        $res[ $opt ] = if ($val) { $val } else { $true }
    }
    $res
}

$Params = Get-PackageParameters
# We can give this a default installation path here if we want
if (!($Params.InstallDir)){
    $Params.InstallDir = "I:\DailyDataFiles\PIT_Tools\$packageName"
}

function New-UpgradeBat ($installDirectory) {
    $UpgradebatCommandPart1 = @'
    choco upgrade ht_SousChef --params="/InstallDir:'
'@
    $UpgradebatCommandPart2 = @'
'" -y
'@

    $UpgradebatCommand = $UpgradebatCommandPart1 + $installDirectory + $UpgradebatCommandPart2
    $UpgradeBatPath = Join-path $installDirectory 'Upgrade SousChef.bat'
    
    New-Item -Path $UpgradeBatPath -Value $UpgradebatCommand -Force
}

#copy $packageName package from inside the choco package lib to the location specified in the parameters

#copy files only the PowerShell module files
$from = "$($env:chocolateyPackageFolder)"
$to = "$($Params.InstallDir)\"

New-Item -ItemType Directory -Force -Path $Params.InstallDir

$cookbooksFolderPath = Join-Path $to 'CookBooks'
try
{
    if (Test-Path ($cookbooksFolderPath))
    {
        Remove-Item ($cookbooksFolderPath) -Recurse -Force
    }
} catch {
    Write-Warning "Failed to remove $cookbooksFolderPath.  Continuing install attempt..."
}

# Exclude file extenstions
$exclude = @('*.nuspec','*.nupkg','*.chocolateyPending')
# Exclude subfolders
$excludeMatch = @("\tools\","\Kitchens\","\DefaultKitchen\")

$installPathListFile = "$($env:chocolateyPackageFolder)\installed_path.txt"
if (Test-Path $installPathListFile){
    remove-item $installPathListFile -Force
}

[regex] $excludeMatchRegEx = '(?i)' + (($excludeMatch |foreach {[regex]::escape($_)}) -join "|") + ''
Write-Output $excludeMatchRegEx
$directories = @()
Get-ChildItem -Path $from -Recurse -Exclude $exclude | 
 where { $excludeMatch -eq $null -or $_.FullName.Replace($from, "") -notmatch $excludeMatchRegEx} | 
  %{ if ($_.PSIsContainer) {
        $dest = Join-Path $to $_.FullName.Substring($from.length)
        "directory=$dest" | out-file $installPathListFile -append
        $directories += $_.FullName
      } else {
        $dest = Join-Path $to $_.FullName.Substring($from.length)
        "file=$dest" | out-file $installPathListFile -append
        $parentFolder = Split-Path $dest
        if (!(Test-Path $parentFolder)){
            New-Item -ItemType "directory" -Path $parentFolder -force
        }
        move-item $_.FullName $dest -Force
      }
  }


# dealing with subfolders in install directory
$installPath = split-path $($Params.InstallDir)
$hasParent = $true
while ($hasParent){
    $lookAhead = split-path $installPath
    # Don't want to include root directory
    if (!$lookAhead){
        $hasParent = $false
    } else {
        $directoryInfo = Get-ChildItem $installPath | Measure-Object
        # if the parent directories only have the one folder created in them, then add to the list
        if($directoryInfo.count -eq 1){
            "directory=$installPath" | Out-File $installPathListFile -append
        } else {
            # if there's something with more than one folder here, then we'll stop looking
            break
        }
        $installPath = $lookAhead
    }
}

"directory=$($Params.InstallDir)" | Out-File $installPathListFile -append
New-UpgradeBat -installDirectory $params.InstallDir